# Self-hosted JWT auth, implemented in-app

TrupeSound is meant to be cloned and self-hosted by anyone, via `docker compose up`, not just run on the maintainer's own homelab. Fronting the app with an external identity provider would give per-user login, branding, and RBAC with almost no application code, but would require every self-hoster to also stand up and operate a multi-container identity provider — a disproportionate operational burden for a small-trupe tool with a handful of users per installation. Instead, auth is implemented directly in the stack: `@nestjs/jwt` + email/password on the backend, a real login screen in Flutter. This trades "zero auth code to maintain" for "zero extra infrastructure to run" — the right trade for this project's target audience.

## Considered Options

- **External IdP via Traefik forward-auth** — rejected due to the operational weight described above.
- **Traefik basicauth per-user (htpasswd)** — rejected: no programmatic identity for `createdBy`, no branded login screen, shared-secret model doesn't fit "who did what."
- **Self-hosted JWT + email/password (chosen)** — no extra containers; all identity logic lives in the existing NestJS backend and Flutter frontend.

## Consequences

- Registration is open (no invite/admin approval) for MVP — anyone with network access to the instance can create an account.
- Single-tenant: one instance = one trupe. No `Organization`/`Trupe` entity; all `User`s in an instance share the same Plays/Sounds.
- JWT is long-lived (30 days), no refresh token, stored in browser localStorage on the Flutter Web client.
- The NestJS backend goes from fully unauthenticated (MVP proof-of-concept state) to a global `APP_GUARD` requiring a valid JWT on every route by default, with `@Public()` as the explicit opt-out.
