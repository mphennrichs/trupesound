import { CallHandler, ExecutionContext, Injectable, NestInterceptor } from '@nestjs/common';
import { Observable, tap } from 'rxjs';
import type { Request, Response } from 'express';
import { redactBody } from './redact';
import { runWithTrace, traceFromRequest } from './trace';

/**
 * Rotas que não geram log de acesso. O healthcheck do Docker bate a cada 10s;
 * eram ~8.6k linhas/dia dizendo "continua vivo" — informação que o próprio
 * healthcheck já dá — enterrando os logs que importam.
 */
const SKIP_ROUTES = new Set(['/api/ping', '/api/health', '/health', '/metrics']);

/**
 * Um objeto JSON por requisição, com bodies de entrada e saída (redigidos),
 * trace id, quem chamou e duração. Substitui o LoggingInterceptor anterior, que
 * emitia `GET /api/ping → 200 (0ms)` como texto — não filtrável no Loki.
 */
@Injectable()
export class HttpLoggingInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<unknown> {
    const http = context.switchToHttp();
    const req = http.getRequest<Request>();

    if (SKIP_ROUTES.has(req.path)) {
      return next.handle();
    }

    const traceId = traceFromRequest(req);
    const start = Date.now();

    // Tudo o que roda a partir daqui — inclusive os use-cases — enxerga este
    // trace pelo AsyncLocalStorage, sem receber nada por parâmetro.
    return runWithTrace({ traceId }, () => {
      const res = http.getResponse<Response>();

      // Devolver o id permite ao usuário relatar um erro citando-o, e a busca
      // no Grafana cair direto na requisição.
      res.setHeader('X-Trace-Id', traceId);

      const emit = (responseBody: unknown, error?: Error) => {
        const status = error ? (error as { status?: number }).status ?? 500 : res.statusCode;

        const fields = {
          trace_id: traceId,
          method: req.method,
          // A rota é o PADRÃO do Express (/api/sounds/:id), não a URL crua: o
          // path real carrega ids que explodiriam a cardinalidade do Loki.
          route: req.route?.path ?? 'unmatched',
          path: req.path,
          status,
          duration_ms: Date.now() - start,
          remote_ip: req.ip,
          user_agent: req.header('user-agent') ?? '',
          request_body: redactBody(req.body),
          response_body: redactBody(responseBody),
          // O guard de JWT preenche req.user; anônimo nas rotas públicas.
          user_id: (req as Request & { user?: { userId?: string } }).user?.userId ?? 'anonymous',
        };

        // Severidade espelha a triagem de quem opera: 5xx é problema nosso,
        // 4xx é do chamador. É o que faz alerta por level="ERROR" significar a
        // mesma coisa em todos os serviços.
        const level = status >= 500 ? 'ERROR' : status >= 400 ? 'WARN' : 'INFO';
        const msg =
          status >= 500
            ? 'http request failed'
            : status >= 400
              ? 'http request rejected'
              : 'http request';

        // Escreve o objeto direto, com os campos no PRIMEIRO NÍVEL. Passar
        // isto pelo Logger do Nest embutiria o JSON dentro do campo `msg`, e
        // no Grafana seria preciso um segundo parse para chegar em `status` ou
        // `trace_id` — em vez de filtrar por campo como nos serviços Go.
        process.stdout.write(
          `${JSON.stringify({
            time: new Date().toISOString(),
            level,
            msg,
            context: 'HTTP',
            ...fields,
          })}\n`,
        );
      };

      return next.handle().pipe(
        tap({
          next: (body) => emit(body),
          // Sem este ramo, toda requisição que lança exceção sairia do log de
          // acesso — justamente as que mais importam.
          error: (err: Error) => emit(undefined, err),
        }),
      ) as Observable<unknown>;
    });
  }
}
