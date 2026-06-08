# TrupeSound — Project Context

App for small theater groups to follow scripts and trigger sound cues during live performances.

---

## Repository Structure

```
trupesound/
├── compose.yml          # Portainer production stack (all services)
├── backend/             # NestJS API
│   ├── compose.yml      # Backend-only compose (local dev / backend sub-stack)
│   └── CONTEXT.md       # Backend architecture & ops
├── frontend/            # Flutter Web app
│   ├── compose.yml      # Frontend-only compose
│   └── CONTEXT.md       # Domain glossary (source of truth for domain terms)
└── README.md
```

---

## Production Deployment

**Host:** Self-managed Linux server (Ubuntu, Docker + Traefik + Portainer + Cloudflare tunnel)

**Stack:** Deployed as a Portainer stack from root `compose.yml`.

| Service | Container | Image | URL |
|---|---|---|---|
| frontend | `trupe-sound-frontend` | `ghcr.io/mphennrichs/trupesound-frontend:latest` | https://trupesound.foguinhodogoias.com |
| backend | `trupe-sound-backend` | `ghcr.io/mphennrichs/trupesound-backend:latest` | https://trupesound.foguinhodogoias.com/api |
| db | `trupe-sound-db` | `postgres:16-alpine` | internal only |
| pgadmin | `trupe-sound-pgadmin` | `dpage/pgadmin4:latest` | https://trupedb.foguinhodogoias.com |

**Networks:**
- `traefik` (external) — all internet-facing services
- `trupesound-internal` — backend ↔ db ↔ pgadmin isolation; frontend reaches backend by name

**TLS:** Cloudflare cert resolver via Traefik  
**Auth:** Frontend protected by Traefik basicauth middleware

---

## CI / Image Publishing

Images are built and pushed to `ghcr.io/mphennrichs/` via GitHub Actions on push to `main`. After a push, redeploy the Portainer stack to pull the new image.

---

## Known Pitfalls

### `tsconfig.build.tsbuildinfo` must not be committed (fixed 2026-06-08)
If this file is present in the Docker build context, `tsc` treats the project as already compiled and emits only `.d.ts` declarations — no `.js` files. The backend container will crash-loop with `Error: Cannot find module '/app/dist/main'`.

**Fix applied:** file removed from git, added to `.gitignore`, and `rm -f tsconfig*.tsbuildinfo` added to `backend/Dockerfile` before the build step.

**Diagnostic:** `docker run --rm <backend-image> find /app/dist -name "*.js"` — if empty, the build is broken.
