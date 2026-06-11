#!/bin/bash
set -e

BACKEND_DIR="$(cd "$(dirname "$0")/../backend" && pwd)"
COMPOSE_FILE="$(cd "$(dirname "$0")/.." && pwd)/compose.yml"
DEV_COMPOSE_FILE="$(cd "$(dirname "$0")/.." && pwd)/compose.dev.yml"

echo "Starting database..."
DATABASE_URL=unused docker compose -f "$COMPOSE_FILE" -f "$DEV_COMPOSE_FILE" up db -d

echo "Waiting for database to be healthy..."
until docker exec trupe-sound-db pg_isready -U trupesound > /dev/null 2>&1; do
  sleep 1
done

echo "Running migrations..."
pnpm --dir "$BACKEND_DIR" exec prisma migrate deploy

echo "Starting backend..."
echo ""
echo "  Run the frontend with:"
echo "  flutter run --dart-define=API_URL=http://localhost:3000/api"
echo ""
cd "$BACKEND_DIR" && pnpm exec ts-node -r tsconfig-paths/register src/main.ts
