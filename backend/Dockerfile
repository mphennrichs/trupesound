# --- Build stage ---
FROM node:22-alpine AS builder
WORKDIR /app

COPY package.json pnpm-lock.yaml prisma.config.mjs ./
COPY prisma ./prisma
RUN npm install -g pnpm@8 && pnpm install --frozen-lockfile

COPY . .
RUN rm -f tsconfig*.tsbuildinfo && pnpm run build

# --- Runtime stage ---
FROM node:22-alpine

# Versão do build, para o log de boot dizer QUAL código está servindo.
# É o que marca o deploy no Grafana: a linha só sai quando o processo novo
# de fato subiu — não quando a imagem foi construída ou o deploy disparado.
ARG VERSION=dev
ARG GIT_COMMIT=unknown
ENV APP_VERSION=$VERSION
ENV APP_COMMIT=$GIT_COMMIT
WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY package.json prisma.config.mjs ./
COPY prisma ./prisma

EXPOSE 3000

CMD ["sh", "-c", "node_modules/.bin/prisma migrate deploy && node dist/main"]
