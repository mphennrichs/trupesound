# TrupeSound — Arquitetura, Decisões e Evolução

Documento vivo. Amarra arquitetura, decisões técnicas, funcionamento e planos de
evolução. Atualize quando uma decisão relevante for tomada.

Documentos irmãos:
- **[CONTEXT.md](./CONTEXT.md)** — estrutura do repo, deploy de produção, pitfalls conhecidos.
- **[backend/CONTEXT.md](./backend/CONTEXT.md)** — arquitetura e schema do backend.
- **[frontend/CONTEXT.md](./frontend/CONTEXT.md)** — glossário de domínio (fonte da verdade dos termos).
- **[backup_plan.md](./backup_plan.md)** — estratégia de backup (export Postgres + Duplicati).

---

## 1. O que é

Sistema de **sonoplastia para grupos de teatro**: acompanhar o texto da peça,
disparar efeitos sonoros por atalhos de teclado durante a apresentação ao vivo, e
gerenciar uma biblioteca de sons. Self-hosted no homelab.

---

## 2. Stack

| Camada | Tecnologia |
| --- | --- |
| **Backend** | NestJS 10 (Node 22) + TypeScript |
| **ORM / DB** | Prisma 7 + PostgreSQL 16 (`prisma migrate deploy` no startup) |
| **Storage de áudio** | MinIO (S3-compatível) — biblioteca de sons |
| **Metadados de áudio** | `music-metadata` |
| **Frontend** | Flutter Web |
| **API docs** | Swagger (`@nestjs/swagger`) |
| **Edge** | Traefik (TLS via Cloudflare resolver) + Cloudflare tunnel; basicauth no frontend |

---

## 3. Arquitetura do backend — Hexagonal (Ports & Adapters)

Cada módulo de domínio segue o mesmo padrão (idêntico em espírito ao tag-anything):

```
src/<módulo>/
  entities/                 # domínio puro
  use-cases/                # uma regra de aplicação por use-case
  adapters/
    repository/             # PORTA (abstrata) + adapters (prisma / memory)
    controller/             # adapter HTTP
  exceptions/
src/common/                 # PrismaClientService, filtros, exceções, base entities
```

**Módulos:** `play` (peças), `act` (atos/cenas), `sound` (biblioteca de sons),
`app-config` (config da app + storage MinIO), `common` (infra compartilhada).

**Modelos (Prisma):** `Play`, `Act`, `Sound`, `AppConfig`. Detalhe dos campos em
[backend/CONTEXT.md](./backend/CONTEXT.md); termos de domínio em
[frontend/CONTEXT.md](./frontend/CONTEXT.md).

**Benefício do padrão:** use-cases dependem das portas (`*.repository.ts`), não do
Prisma nem do MinIO — testável em memória, trocável sem mexer na regra de negócio.

---

## 4. Funcionamento — serviços em produção

| Serviço | Container | Imagem | URL |
| --- | --- | --- | --- |
| frontend | `trupe-sound-frontend` | `ghcr.io/mphennrichs/trupesound-frontend` | https://trupesound.foguinhodogoias.com |
| backend | `trupe-sound-backend` | `ghcr.io/mphennrichs/trupesound-backend` | `…/api` |
| db | `trupe-sound-db` | `postgres:16-alpine` | interno |
| pgadmin | `trupe-sound-pgadmin` | `dpage/pgadmin4` | https://trupedb.foguinhodogoias.com |

**Redes:** `traefik` (externa, tudo que é internet-facing) + `trupesound-internal`
(isola backend ↔ db ↔ pgadmin; o frontend alcança o backend por nome).

---

## 5. Decisões técnicas e pitfalls

- **`prisma migrate deploy` no startup do container.** As migrações rodam quando o
  backend sobe — deploy aplica schema automaticamente. Cuidado: migração destrutiva
  vai junto com o deploy.
- **MinIO para os áudios**, não o Postgres. Arquivos de som ficam no object storage
  (S3-compatível); o banco guarda só metadados/refs.
- **Credenciais do volume `postgres_data` (P1000).** O Postgres só aplica
  `POSTGRES_USER`/`POSTGRES_PASSWORD` na **primeira criação do volume**. Se o volume
  já existe de um deploy anterior com credencial diferente, as envs são ignoradas e o
  backend leva `P1000: Authentication failed`. **Diagnóstico:**
  `docker exec trupe-sound-db psql -U postgres -c "\du"`. **Fix sem perda:**
  `ALTER USER trupesound WITH PASSWORD 'trupesound';` (ver [CONTEXT.md](./CONTEXT.md)).

---

## 6. Planos de evolução

- **Atualizar docs de deploy: Portainer → Komodo.** O [CONTEXT.md](./CONTEXT.md) ainda
  descreve o deploy como "Portainer stack", mas o homelab **migrou para Komodo** e o CI
  já dispara o fogolab (ver §7). Atualizar o CONTEXT.md quando confirmado em produção.
- **Backup.** Ver [backup_plan.md](./backup_plan.md): export do Postgres (container
  `postgres:alpine` sem build, na rede traefik) consumido pelo Duplicati existente do
  fogolab. Concluir/validar a automação.
- **Biblioteca de sons.** Fonte sugerida: [BBC Sound Effects](https://sound-effects.bbcrewind.co.uk/)
  (grátis, uso não-comercial). Evoluir a curadoria/import da biblioteca.

> Ao concluir, mova para a seção apropriada e atualize o CONTEXT.md correspondente.

---

## 7. Deploy (CI → GHCR → fogolab/Komodo)

Push na `main` → `.github/workflows/docker-publish.yml` builda **frontend e backend**,
publica em `ghcr.io/mphennrichs/trupesound-*` e dispara um `repository_dispatch` no
repo de infra **fogolab**, que redeploya via Komodo.

> Nota: partes da doc antiga citam "redeploy da stack no Portainer" — histórico. O
> modelo atual é fogolab/Komodo (o CI já faz o `Notify fogolab to deploy`).

**Rodar local:**
```bash
cd backend && pnpm install && pnpm run start:dev   # Swagger em /api
cd frontend && flutter run -d chrome
```
Requer Postgres + MinIO acessíveis e as envs do Prisma/MinIO (ver `backend/CONTEXT.md`).
