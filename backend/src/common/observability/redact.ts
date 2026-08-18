/**
 * Redação de dados sensíveis antes de qualquer body virar log.
 *
 * O Loki retém 14 dias e o Grafana é acessível na rede: uma senha logada em
 * texto puro fica legível por duas semanas. Como o log de body existe para
 * depurar formato e conteúdo de negócio — e credencial não é nenhum dos dois —
 * o valor desses campos nunca sai daqui.
 */

/** Teto por body. Um Scan/listagem grande não pode virar KBs de log por request. */
export const MAX_BODY_BYTES = 4096;

/**
 * Comparação por substring em minúsculas, então "currentPassword",
 * "password_hash" e "accessToken" caem todos nas entradas abaixo.
 */
const SENSITIVE_KEYS = [
  'password',
  'senha',
  'token',
  'secret',
  'authorization',
  'apikey',
  'api_key',
  'credential',
  'jwt',
  'cookie',
];

const REDACTED = '[REDACTED]';

export function isSensitiveKey(key: string): boolean {
  const k = key.toLowerCase();
  return SENSITIVE_KEYS.some((s) => k.includes(s));
}

/** Percorre a árvore trocando valores sensíveis, em qualquer profundidade. */
function redactValue(value: unknown): unknown {
  if (Array.isArray(value)) return value.map(redactValue);

  if (value !== null && typeof value === 'object') {
    const out: Record<string, unknown> = {};
    for (const [k, v] of Object.entries(value as Record<string, unknown>)) {
      out[k] = isSensitiveKey(k) ? REDACTED : redactValue(v);
    }
    return out;
  }

  return value;
}

/**
 * Devolve uma versão do body segura para log.
 *
 * Um body que não é objeto (string crua de um POST form-encoded, Buffer de
 * upload) NÃO é logado como veio: poderia ser justamente um login carregando a
 * senha. Nesses casos devolvemos só um marcador.
 */
export function redactBody(body: unknown): string {
  if (body === undefined || body === null || body === '') return '';

  if (typeof body !== 'object' || Buffer.isBuffer(body)) {
    return '[non-object body omitted]';
  }

  try {
    return truncate(JSON.stringify(redactValue(body)));
  } catch {
    // Referência circular, BigInt, etc.
    return '[unserializable body omitted]';
  }
}

/** Corta no limite e sinaliza, para ninguém ler um payload cortado como completo. */
export function truncate(s: string): string {
  return s.length <= MAX_BODY_BYTES ? s : `${s.slice(0, MAX_BODY_BYTES)}...[truncated]`;
}
