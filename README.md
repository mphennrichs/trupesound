# TrupeSound

Sistema de sonoplastia para grupos de teatro. Permite acompanhar o texto da peça, criar atalhos de teclado para efeitos sonoros e gerenciar uma biblioteca de sons.

O design foi criado no [Stitch](https://stitch.withgoogle.com/projects/13048112292899790778).

---

## Sugestão de fonte de efeitos sonoros

O site [BBC Sound Effects](https://sound-effects.bbcrewind.co.uk/) oferece milhares de efeitos sonoros gratuitos para uso não-comercial — ótimo ponto de partida para montar a biblioteca de sons da sua peça.

---

## Pré-requisitos

- [Docker](https://docs.docker.com/get-docker/) e Docker Compose
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (para rodar o frontend localmente)
- [Node.js 20+](https://nodejs.org/) e [pnpm](https://pnpm.io/) (para rodar o backend localmente)

---

## Rodar localmente (modo desenvolvimento)

### 1. Suba o banco de dados

```bash
docker compose -f compose.dev.yml up -d
```

Isso sobe apenas o PostgreSQL na porta `5432`.

### 2. Configure as variáveis de ambiente do backend

Crie o arquivo `backend/.env` com base no exemplo abaixo:

```env
DATABASE_URL=postgresql://trupesound:trupesound@localhost:5432/trupesound
NODE_ENV=development
APP_URL=http://localhost:3000

# Armazenamento local (modo desenvolvimento)
STORAGE_LOCAL_FOLDER=/tmp/trupesound-sounds
```

> Para usar armazenamento S3 em vez do local, consulte a seção [Armazenamento em nuvem](#armazenamento-em-nuvem) abaixo.

### 3. Inicie o backend

```bash
cd backend
pnpm install
pnpm start:dev
```

O backend fica disponível em `http://localhost:3000/api`.  
A documentação Swagger fica em `http://localhost:3000/api`.

### 4. Inicie o frontend

```bash
cd frontend
flutter pub get
flutter run -d chrome
```

O frontend abre automaticamente no Chrome.

---

## Armazenamento em nuvem

Por padrão, em produção o TrupeSound usa um bucket S3-compatível (testado com [SeaweedFS](https://github.com/seaweedfs/seaweedfs)). Para usar em desenvolvimento, substitua as variáveis de armazenamento local no `backend/.env`:

```env
STORAGE_ENDPOINT=seu-endpoint-s3.com
STORAGE_ACCESS_KEY=sua-access-key
STORAGE_SECRET_KEY=sua-secret-key
```

> O modo local (`STORAGE_LOCAL_FOLDER`) é suficiente para desenvolvimento e testes. O modo S3 é recomendado para produção.

---

## Rodar remotamente (produção com Docker)

### 1. Configure os segredos

As credenciais de armazenamento são injetadas via variáveis de ambiente — não ficam em arquivos no servidor. Copie `.env.example` como referência:

```bash
cp .env.example .env
# edite .env com os valores reais
```

O arquivo `.env` é lido pelo Docker Compose na hora do deploy. Em ambientes gerenciados (ex: Portainer), configure as variáveis diretamente na interface de stacks.

### 2. Faça o deploy

```bash
docker compose up -d
```

O Compose sobe os serviços:

| Serviço    | Descrição                          |
|------------|------------------------------------|
| `db`       | PostgreSQL                         |
| `backend`  | API NestJS (porta 3000 interna)    |
| `frontend` | Flutter Web via Nginx (porta 80)   |
| `pgadmin`  | Interface web do banco (opcional)  |

### 3. Roteamento (Traefik)

O `compose.yml` já inclui labels para o [Traefik](https://traefik.io/) com TLS automático via Cloudflare. Ajuste os valores de domínio e as credenciais de autenticação básica conforme seu ambiente:

```bash
# como gerar o hash da senha:
htpasswd -Bnb usuario senha | sed -e s/\\$/\\$\\$/g
```

### 4. CI/CD automático

O repositório inclui um workflow GitHub Actions (`.github/workflows/docker-publish.yml`) que constrói e publica as imagens Docker no GHCR a cada push na branch `main`. Após a publicação, atualize os containers no servidor:

```bash
docker pull ghcr.io/mphennrichs/trupesound-frontend:latest
docker pull ghcr.io/mphennrichs/trupesound-backend:latest
docker compose up -d --force-recreate frontend backend
```
