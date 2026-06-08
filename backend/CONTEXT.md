# TrupeSound Backend — Context

NestJS REST API serving the TrupeSound frontend. Manages Plays, Acts, Sounds, and AppConfig via Prisma + PostgreSQL.

---

## Stack

- **Runtime:** Node.js 22, NestJS 10
- **ORM:** Prisma 7 (`prisma migrate deploy` runs on container startup)
- **DB:** PostgreSQL 16 (`db` hostname on `trupesound-internal` network)
- **Port:** 3000
- **Package manager:** pnpm 8

---

## Project Structure

```
src/
├── main.ts
├── app.module.ts
├── act/              # Act CRUD
├── app-config/       # AppConfig + storage config
├── common/           # PrismaClientService, exceptions, filters, base entities
├── play/             # Play CRUD
└── sound/            # Sound library
prisma/
├── schema.prisma
└── migrations/
```

**Architecture pattern:** each module follows ports-and-adapters:  
`entities/` → `use-cases/` → `adapters/repository/` + `adapters/controller/`

---

## Database Schema (as of 2026-06-08)

| Model | Key fields |
|---|---|
| `AppConfig` | singleton (id=1), appId, storageEndpoint/AccessKey/SecretKey, localFolder |
| `Play` | id, title, author, status, active, icon, backgroundColor, acts[] |
| `Act` | id, playId, number, name, script (JSON), cues (JSON) |
| `Sound` | id, name, category, durationMs, url, archived |

Migrations: `prisma/migrations/` — 5 migrations from 2026-06-06.

---

## Docker Build

```dockerfile
# builder: pnpm install + nest build
# runtime: copies dist/ + node_modules + prisma
CMD: sh -c "node_modules/.bin/prisma migrate deploy && node dist/main"
```

**Critical:** `tsconfig*.tsbuildinfo` must not be in the build context — it causes `tsc` to skip JS emission entirely. The Dockerfile deletes it before building as a safeguard. See root `CONTEXT.md` for the full incident description.

---

## Environment Variables

| Variable | Value in production |
|---|---|
| `DATABASE_URL` | `postgresql://trupesound:trupesound@db:5432/trupesound` |
| `NODE_ENV` | `production` |

---

## Local Development

```bash
pnpm install
pnpm run start:dev   # nest start --watch
```

Requires a running Postgres instance. Use `backend/compose.yml` to spin up just the DB locally.
