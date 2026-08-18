import { ConsoleLogger, LogLevel } from '@nestjs/common';
import { currentTrace } from './trace';

/**
 * Logger do Nest que escreve JSON em vez do formato colorido padrão.
 *
 * O ConsoleLogger padrão emite algo como
 *   [Nest] 1  - 08/17/2026, 8:43 PM  LOG [HTTP] GET /api/ping → 200 (0ms)
 * com códigos ANSI de cor embutidos. No Loki isso vira uma string opaca — e os
 * `\x1b[32m` viram lixo visível. Sem campos, não dá para filtrar por nível,
 * agregar por rota nem alertar.
 *
 * Aqui cada linha é um objeto JSON. O trace_id e o user_id vêm do
 * AsyncLocalStorage, então QUALQUER log da aplicação (inclusive de dentro de um
 * use-case) sai correlacionado com a requisição que o originou, sem precisar
 * receber contexto por parâmetro.
 */
export class JsonLogger extends ConsoleLogger {
  private write(level: LogLevel, message: unknown, context?: string, extra?: Record<string, unknown>) {
    const trace = currentTrace();

    const entry: Record<string, unknown> = {
      time: new Date().toISOString(),
      level: level.toUpperCase(),
      msg: typeof message === 'string' ? message : JSON.stringify(message),
    };

    if (context ?? this.context) entry.context = context ?? this.context;
    if (trace?.traceId) entry.trace_id = trace.traceId;
    if (trace?.userId) entry.user_id = trace.userId;

    if (extra) Object.assign(entry, extra);

    // stdout direto: o Docker entrega ao Alloy, que entrega ao Loki.
    process.stdout.write(`${JSON.stringify(entry)}\n`);
  }

  log(message: unknown, context?: string) {
    this.write('log', message, context);
  }

  error(message: unknown, stack?: string, context?: string) {
    // O stack vai em campo próprio: é o que se quer ler inteiro quando algo
    // quebra, e concatenar na mensagem tornaria a busca por msg inútil.
    this.write('error', message, context, stack ? { stack } : undefined);
  }

  warn(message: unknown, context?: string) {
    this.write('warn', message, context);
  }

  debug(message: unknown, context?: string) {
    this.write('debug', message, context);
  }

  verbose(message: unknown, context?: string) {
    this.write('verbose', message, context);
  }

  /** Log estruturado com campos arbitrários — usado pelos steps intermediários. */
  event(msg: string, fields: Record<string, unknown>, context?: string) {
    this.write('log', msg, context, fields);
  }
}
