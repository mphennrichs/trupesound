# --- Build stage ---
FROM node:20-alpine AS builder
WORKDIR /app

COPY package.json pnpm-lock.yaml prisma.config.mjs ./
COPY prisma ./prisma
RUN npm install -g pnpm@8 && pnpm install --frozen-lockfile

COPY . .
RUN pnpm run build

# --- Runtime stage ---
FROM node:20-alpine
WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY package.json prisma.config.mjs ./
COPY prisma ./prisma

EXPOSE 3000

# Uses prisma db push (schema-sync, no migration files required).
# When proper migrations are introduced, replace with:
#   node_modules/.bin/prisma migrate deploy && node dist/main
CMD ["sh", "-c", "node_modules/.bin/prisma db push && node dist/main"]
