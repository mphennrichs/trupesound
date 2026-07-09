# In-app backup and restore via Google Drive (OAuth2, drive.file scope)

An earlier design kept backup entirely outside the app: a lightweight export container plus an already-running Duplicati instance on the maintainer's homelab handled transport to Google Drive. That assumed every self-hoster already runs Duplicati, which isn't true for someone who just clones the repo and runs `docker compose up` — the same self-hosted-by-anyone constraint that shaped [ADR-0001](./0001-self-hosted-jwt-auth.md). Backup is instead implemented in-app: the NestJS backend talks to the Google Drive API directly, scheduled via `@nestjs/schedule`, with no external transport tool required.

## Considered Options

- **External transport tool (Duplicati) on the host** — rejected: assumes infrastructure a generic self-hoster won't have.
- **In-app Google Drive integration (chosen)** — self-contained; works out of the box for anyone with a personal Google account.

## Decisions

- **Auth**: OAuth2 (admin authorizes with their own Google account) rather than a Service Account — no Google Cloud Project setup burden beyond registering OAuth credentials.
- **OAuth client**: each self-hoster registers their own Google Cloud OAuth Client ID/Secret (`GOOGLE_CLIENT_ID`/`GOOGLE_CLIENT_SECRET` env vars) — no shared TrupeSound-wide OAuth client, avoiding centralized quota/review risk.
- **Scope**: `drive.file` only — the app can only see/manage files it created itself. Keeps the OAuth consent screen in Google's "non-sensitive" tier, avoiding CASA security assessment.
- **Token storage**: refresh token stored in plaintext on `AppConfig` (same pattern as existing `storageAccessKey`/`storageSecretKey`) — no new encryption-at-rest mechanism introduced for this one field.
- **Content scope**: `Play`, `Act`, `Sound` tables only (via `pg_dump --table`) + non-archived Sound files + a `manifest.json` mapping sound names to files. `AppConfig` is deliberately excluded — it holds live credentials (storage keys, the Google Drive refresh token itself, backup schedule), and restoring it would risk reverting to stale/revoked credentials or breaking the very connection used to perform the restore. This also keeps credentials out of the archive that gets stored in the user's Drive.
- **Packaging**: one compressed archive (`.tar.gz`) per backup run, uploaded as a single file, rather than a folder of loose files — one upload call, simpler restore.
- **Schedule & retention**: both user-configurable from the Backup section of the System page (frequency dropdown + time, and "keep last N backups") — not hardcoded — because backup needs vary per instance.
- **Retention enforcement**: after each successful upload, older backups beyond the configured N are deleted from Drive. Deletion only runs after the new upload is confirmed, so a failed backup never leaves an instance with fewer than N valid backups.
- **Failure handling**: retried in-run with exponential backoff (5 attempts, starting at 2 minutes: 2→4→8→16→32min) before giving up; failures are logged and surfaced as "last backup failed" in the UI. No email/notification integration — avoids adding an SMTP dependency for MVP.
- **Manual trigger**: `POST /v1/backup/run` exists alongside the cron, mainly to validate a fresh Drive connection immediately instead of waiting for the next scheduled run.

## Restore

Restore is a first-class, in-app operation, not a manual runbook — a backup that can't be reloaded by the app itself isn't a real backup.

- **Source**: manual file upload (file picker → `POST /v1/backup/restore`, `multipart/form-data`), not a pick-from-connected-Drive flow. This covers the actual disaster scenario — a fresh instance with nothing configured yet, possibly no Drive connection at all — not just the happy path of restoring into an already-healthy instance.
- **Strategy**: full replacement of `Play`, `Act`, `Sound` — not a merge. Restore means "roll back to exactly what the backup contains," avoiding the complexity of ID-conflict resolution a merge would require. `AppConfig` is never touched (symmetric with backup's exclusion of it).
- **Validation before mutation**: the uploaded archive is fully validated before any data is touched — `manifest.json` is parsed, `pg_restore --list` is run against the dump, and archive contents are checked against the manifest. If validation fails, nothing is modified.
- **Atomicity**: once validated, the `Play`/`Act`/`Sound` replacement runs inside a single Postgres transaction (all-or-nothing). Sound file re-upload to the currently configured storage backend (local or cloud — whichever this instance uses now, independent of what was active when the backup was taken) happens only after the transaction commits, so the database is left consistent even if a file re-upload fails partway.
- **Confirmation**: destructive and irreversible, so the UI requires an explicit confirmation dialog before the upload is submitted. No role/admin gating — the project has no role concept yet, so any logged-in User can restore.

## Consequences

- `AppConfig` gains backup-related fields: `googleDriveRefreshToken`, `googleDriveFolderId`, `backupFrequency`, `backupTime`, `backupRetentionCount`.
- Restored `Sound` records point at newly generated URLs from the re-upload, not the URLs captured at backup time (which may no longer exist).
- Supersedes the Duplicati-based plan previously recorded in the (now removed) root `backup_plan.md`.
