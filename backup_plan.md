# TrupeSound Backup — Plano Final

## Arquitetura split

```
┌─ EXPORT (novo — fogolab) ─────────────┐   ┌─ TRANSPORTE (Duplicati existente) ─┐
│ image: postgres:alpine (sem build)     │   │ stack duplicati (project 119)       │
│ rede: traefik                          │   │ monta docker_volumes → /source      │
│ cron 03:00:                            │   │ job ~04:00:                         │
│  1. curl /v1/sounds → manifest.json    │──►│  /source/trupesound-backup/ → Drive │
│  2. pg_dump → db.sql.gz                │   │  versionamento + retenção + cripto  │
│  3. baixa sons (url presigned)         │   │  (tudo gerenciado pelo Duplicati)   │
│  4. grava em:                          │   └─────────────────────────────────────┘
│     docker_volumes/trupesound-backup/  │
│       trupesound-YYYY-MM-DD/           │
└────────────────────────────────────────┘
```

## Decisões (todas travadas)

| Tema | Decisão |
|---|---|
| O que | Postgres (pg_dump) + sons archived=false. Código fica no GitHub, skip |
| Arquitetura | Split: export leve + Duplicati transporta |
| Imagem | postgres:alpine (tem pg_dump/psql) + wget/jq no entrypoint. Sem Dockerfile/build |
| Stack | service `backup` dentro de `trupesound/docker-compose.yaml` (fogolab) |
| Rede | traefik · hosts `trupe-sound-db`, `trupe-sound-backend` (nunca `db` — colisão P1000) |
| Download sons | via `GET /v1/sounds` (presigned embutido) — zero credencial S3 |
| Filtro archived | já feito pela API |
| Postgres | reusa `TRUPE_DB_USER`/`PASSWORD`/`NAME` (Infisical), monta conn string |
| Destino | `/home/fogo/docker_volumes/trupesound-backup/trupesound-YYYY-MM-DD/` |
| Naming | nome original do objeto + `manifest.json` (id↔name↔arquivo) |
| Ordem | manifesto antes do pg_dump (consistência) |
| Schedule | export cron 03:00; Duplicati ~04:00 (desacoplado) |
| Drive | configurado no Duplicati, não no app |
| backupDriveFolderId | ❌ removido do escopo — Duplicati controla o destino |
| Validação | `pg_restore --list` no dump + contagem arquivos vs manifesto; logar |
| Falha | retry 3x/15min, log-only (Portainer logs) |
| Encriptação | no Duplicati (se desejada); dataset não-sensível |

## Secrets

Nenhum secret novo. Só os já existentes em Infisical `/trupesound`:
- `TRUPE_DB_USER`, `TRUPE_DB_PASSWORD`, `TRUPE_DB_NAME`
- `BACKUP_BACKEND_URL=http://trupe-sound-backend:3000` — não-secreto, vai no compose

## Trabalho necessário

| Onde | O quê |
|---|---|
| fogolab | service `backup` em `trupesound/docker-compose.yaml` |
| fogolab | `backup.sh` (montado via config/volume do compose) |
| host | criar `docker_volumes/trupesound-backup/` |
| Duplicati (UI) | 1 job: `/source/trupesound-backup/` → Google Drive, schedule 04:00 |
| repo do app | ❌ nada |

## backup.sh — passos

```sh
1. mkdir -p /out/trupesound-$(date +%F)
2. wget /v1/sounds → manifest.json            # já filtra archived
3. pg_dump (host trupe-sound-db, TRUPE_DB_*) | gzip → db.sql.gz
4. para cada .url do manifest: wget -O sounds/<obj-name>   # presigned
5. validação: pg_restore --list db.sql.gz ; contar sounds/ vs manifest
6. log resultado (sucesso/falha por etapa)
   [Duplicati assume daqui: envia a pasta ao Drive às 4am]
```

## Premissas validadas

- `db`/`backend` só na rede `traefik`; `trupesound-internal` órfã
- `GET /v1/sounds` → `id,name,category,durationMs,url(presigned),archived,createdAt`; filtra archived
- `Sound.url` path-style: `https://s3.../<appId>/sounds/<arquivo>`
- `AppConfig` singleton id=1, `appId=7c4d2177-...` (não usado no design final)
- `/v1/app/*` sem auth (proteção no Traefik)
- fogolab não builda imagens; Duplicati monta `docker_volumes→/source`

## Pontos operacionais

- Export depende do backend no ar às 3am — retry 3x/15min cobre janelas curtas
- Janela export→Duplicati (3am→4am) — se export passar de 1h, Duplicati pode pegar dia incompleto (improvável: 2 sons atualmente)
- Restore é manual — documentar procedimento
- `manifest.json` é a chave do restore (mapeia nome amigável ↔ arquivo) — incluir sempre
