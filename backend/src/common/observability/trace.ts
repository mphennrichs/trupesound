import { AsyncLocalStorage } from 'node:async_hooks';
import { randomBytes } from 'node:crypto';
import type { Request } from 'express';

/**
 * Trace context da requisição.
 *
 * Usa o header W3C `traceparent` (e não um X-Trace-Id próprio) porque é o que
 * proxies e serviços externos já entendem — se um dia entrar OpenTelemetry na
 * stack, o mesmo id continua valendo, sem migração.
 *
 * O AsyncLocalStorage propaga o contexto por toda a cadeia async da requisição,
 * então um use-case no fundo do stack consegue logar com o mesmo trace_id sem
 * receber nada por parâmetro.
 */

export const TRACEPARENT_HEADER = 'traceparent';

export interface TraceContext {
  traceId: string;
  /** Quem disparou a requisição. Ausente enquanto não autenticado. */
  userId?: string;
}

const storage = new AsyncLocalStorage<TraceContext>();

/** trace-id do W3C: 16 bytes em hex. */
export function newTraceId(): string {
  return randomBytes(16).toString('hex');
}

/**
 * Extrai o trace-id de um `traceparent` ("00-<trace-id>-<span-id>-<flags>").
 * Devolve undefined se ausente ou malformado — aí o chamador gera um novo.
 */
export function traceIdFromHeader(header?: string): string | undefined {
  if (!header) return undefined;
  const parts = header.split('-');
  return parts.length >= 3 && parts[1]?.length === 32 ? parts[1] : undefined;
}

/** Roda `fn` dentro de um trace context. */
export function runWithTrace<T>(ctx: TraceContext, fn: () => T): T {
  return storage.run(ctx, fn);
}

export function currentTrace(): TraceContext | undefined {
  return storage.getStore();
}

export function currentTraceId(): string | undefined {
  return storage.getStore()?.traceId;
}

/**
 * Registra quem é o usuário autenticado da requisição corrente. Chamado pelo
 * guard de JWT, depois que o trace já existe.
 */
export function setCurrentUser(userId: string | number): void {
  const ctx = storage.getStore();
  // Normaliza para string: o id e uuid num app e numerico noutro, e um campo
  // com tipo variavel quebraria filtros no Grafana.
  if (ctx) ctx.userId = String(userId);
}

/**
 * Cabeçalhos para propagar o trace numa chamada de SAÍDA. É o que fecha o ciclo
 * distribuído: o serviço chamado loga o mesmo trace_id, e o Grafana mostra a
 * cadeia inteira filtrando por um valor só.
 */
export function outboundTraceHeaders(): Record<string, string> {
  const traceId = currentTraceId();
  if (!traceId) return {};
  const spanId = randomBytes(8).toString('hex');
  return { [TRACEPARENT_HEADER]: `00-${traceId}-${spanId}-01` };
}

/** Lê o trace do header da requisição (ou cria um novo). */
export function traceFromRequest(req: Request): string {
  return traceIdFromHeader(req.header(TRACEPARENT_HEADER)) ?? newTraceId();
}
