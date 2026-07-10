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

### `postgres_data` volume credentials mismatch (P1000)

Postgres only initialises `POSTGRES_USER` / `POSTGRES_PASSWORD` on **first volume creation**. If the `postgres_data` volume already exists (from a prior deployment with different credentials), those env vars are silently ignored and the backend gets `P1000: Authentication failed`.

**Diagnostic:** `docker exec trupe-sound-db psql -U postgres -c "\du"` — check whether the `trupesound` role exists and has login.

**Fix (without data loss):** `docker exec trupe-sound-db psql -U postgres -c "ALTER USER trupesound WITH PASSWORD 'trupesound';"`

**Fix (with data loss):** `docker volume rm trupesound_postgres_data` then redeploy.

---

### Storage mode detection broken for local-only config (fixed 2026-06-11)
`StorageConfigService.load()` on the frontend returned `null` whenever `endpoint` was empty, even when `localFolder` was set. This caused `storageModeProvider` to resolve to `unknown` and hide both the Sync and Upload buttons.

**Fix:** `load()` now returns a valid config if either `endpoint` or `localFolder` is non-empty.

---

### SeaweedFS presign uses virtual-hosted URLs (fixed 2026-06-11)
The MinIO JS client defaults to virtual-hosted style (`https://bucket.host/...`), which SeaweedFS does not support without wildcard DNS. Added `pathStyle: true` to the MinIO client instantiation in `GenerateUploadUrlUseCase`.

---

### `tsconfig.build.tsbuildinfo` must not be committed (fixed 2026-06-08)
If this file is present in the Docker build context, `tsc` treats the project as already compiled and emits only `.d.ts` declarations — no `.js` files. The backend container will crash-loop with `Error: Cannot find module '/app/dist/main'`.

**Fix applied:** file removed from git, added to `.gitignore`, and `rm -f tsconfig*.tsbuildinfo` added to `backend/Dockerfile` before the build step.

**Diagnostic:** `docker run --rm <backend-image> find /app/dist -name "*.js"` — if empty, the build is broken.

---

### Cloudflare edge-caches the Flutter `.js`, freezing an old app version (fixed 2026-07-10)
After a deploy, the app kept showing the **old** UI — even in a fresh incognito window and in a clean, never-used browser. That ruled out browser cache and pointed at the **edge**: Cloudflare was caching the static `.js` by file extension, so `main.dart.js` was served stale (`cf-cache-status: HIT`, `age` ~2h) while `index.html` stayed dynamic. A fresh `index.html` loading a stale `main.dart.js` pins the whole app to the old build for **everyone**, since the cache is at the CDN, before the client.

Why it's sneaky:
- **Incognito / clean browser don't help** — the stale copy lives at Cloudflare's edge, not in any browser.
- **The container is correct.** The image ships the new build; only the public response is stale.
- The Flutter `main.dart.js` has **no content hash in its filename**, so a cached copy is never invalidated by a new build (unlike hashed assets).

**Fix:** the frontend nginx now sends `Cache-Control: no-store` on the files that point at the current version — `index.html`, `main.dart.js`, `flutter_bootstrap.js`, `flutter_service_worker.js`, `flutter.js`, `version.json` — while hashed assets (`/assets/`, `/canvaskit/`, `/icons/`) keep a long cache. Config is versioned at `frontend/nginx.conf` (previously an inline `RUN echo` in the Dockerfile with no cache headers). After deploy, Cloudflare returns `cf-cache-status: BYPASS` on those files and always serves the live version — so **future deploys appear immediately**, no manual cache clearing.

**One-time cleanup after deploying the fix:** items already cached with the old headers (notably `flutter_service_worker.js`, cached with `max-age=14400`) stay stale until they expire, because the `no-store` header only applies to *new* origin responses. Purge them once via Cloudflare dashboard → Caching → Configuration → **Purge Everything**. Not needed again afterwards.

**Diagnostic:** compare what the edge serves vs. what the container ships —
```bash
B=https://trupesound.foguinhodogoias.com
curl -sI "$B/main.dart.js" | grep -i cf-cache-status         # want BYPASS, not HIT
CTR=$(docker exec trupe-sound-frontend md5sum /usr/share/nginx/html/main.dart.js | cut -d' ' -f1)
PUB=$(curl -s "$B/main.dart.js" | md5sum | cut -d' ' -f1)
[ "$CTR" = "$PUB" ] && echo "edge serves live version" || echo "edge is stale"
```
The Cloudflare API token on the host has DNS-edit permission only (no cache-purge), so purging must be done in the dashboard or with a token that has the Cache Purge scope.

