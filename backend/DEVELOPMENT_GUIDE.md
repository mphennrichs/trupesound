# Backend Development Guide

TypeScript · NestJS · PostgreSQL · Prisma

For domain terminology (Sound, Play, Act, SoundCue, etc.) refer to [`CONTEXT.md`](../frontend/CONTEXT.md).

---

## 1. Architecture Overview

The backend follows a **DDD + Hexagonal Architecture** style. Each business domain lives in its own NestJS module. The module is divided into three layers:

```
src/
├── common/                        ← shared infrastructure
│   ├── application/
│   │   ├── filters/               ← global exception filters
│   │   └── service/               ← PrismaService
│   ├── constants/                 ← error codes, API version strings
│   └── entities/                  ← Entity, ValueObject, Audit base classes
├── <domain>/                      ← one folder per bounded context
│   ├── entities/                  ← domain model (pure, no framework)
│   ├── use-cases/                 ← application logic (one class = one action)
│   ├── adapters/
│   │   ├── controller/v1/         ← HTTP controllers (versioned)
│   │   │   └── dto/
│   │   │       ├── request/       ← input DTOs (validation decorators)
│   │   │       └── response/      ← output DTOs
│   │   └── repository/            ← abstract + memory + prisma implementations
│   │       └── model/             ← flat Prisma-shaped POJOs
│   ├── exceptions/                ← domain-specific HTTP exceptions
│   └── <domain>.module.ts         ← NestJS wiring
├── app.module.ts
└── main.ts
```

---

## 2. Domain Layer — Entities & Value Objects

### Base classes

`Entity<T>` — any object with identity. Identity is a numeric `id`.

```ts
export abstract class Entity<T> {
  protected readonly _id?: number;
  protected props: T;

  protected constructor(props: T, id?: number) {
    this._id = id;
    this.props = props;
  }

  get id() { return this._id; }

  public equals(object?: Entity<T>): boolean { ... }
}
```

`ValueObject<T>` — an immutable object defined only by its properties (no identity). Props are frozen.

```ts
export abstract class ValueObject<T extends ValueObjectProps> {
  protected readonly props: T;

  protected constructor(props: T) {
    this.props = Object.freeze(props);
  }
}
```

> **Important:** because `ValueObject` freezes `props`, do **not** add setters to ValueObject subclasses. Use `new` to replace the value object entirely.

### Defining a domain entity

```ts
export interface SoundProps {
  title: string;
  fileUrl: string;
  status: SoundStatusEnum;
  audit: Audit;
}

export class SoundEntity extends Entity<SoundProps> {
  private constructor(props: SoundProps, id?: number) {
    super(props, id);
  }

  static new(props: SoundProps, id?: number): SoundEntity {
    return new SoundEntity(props, id);
  }

  // Getters/setters for each prop
  get title(): string { return this.props.title; }
  set title(v: string) { this.props.title = v; }

  // Reconstruction from DB model (bridge between layers)
  static fromModel(model: SoundModel): SoundEntity {
    return SoundEntity.new({
      title: model.title,
      fileUrl: model.fileUrl,
      status: model.status as SoundStatusEnum,
      audit: Audit.new({
        createdAt: model.createdAt,
        createdBy: model.createdBy,
        lastUpdatedAt: model.lastUpdatedAt,
        lastUpdatedBy: model.lastUpdatedBy,
      }),
    }, model.id);
  }
}
```

Rules:
- Constructor is `private`. Always expose a `static new(...)` factory.
- `fromModel()` is the only place that converts a DB row back into a domain entity.
- Entities own business-rule behaviour methods (e.g. `isDeleted()`, `canBePublished()`).
- No framework imports (`@nestjs/*`, `class-validator`, etc.) inside `entities/`.

### Audit value object

Every entity should carry an `Audit` value object:

```ts
Audit.new({
  createdAt: new Date(),
  createdBy: null,   // null during MVP (no auth); populated from JWT once auth is implemented
  lastUpdatedAt: null,
  lastUpdatedBy: null,
})
```

---

## 3. Application Layer — Use Cases

One class, one action. Each use case is a NestJS `@Injectable()` that receives its dependencies via constructor injection and exposes a single `execute()` method.

```ts
@Injectable()
export class CreateSoundUseCase {
  constructor(private readonly soundRepository: SoundRepository) {}

  async execute(sound: SoundEntity): Promise<SoundEntity> {
    // business guards go here
    const model = SoundModel.fromDomain(sound);
    const saved = await this.soundRepository.save(model);
    return SoundEntity.fromModel(saved);
  }
}
```

Rules:
- Use cases depend on the **abstract** `SoundRepository`, never on its Prisma implementation.
- Use cases never import controllers or DTOs.
- Throw domain exceptions (from `exceptions/`) — never raw `HttpException`.
- File name: `<verb>-<noun>.use-case.ts` (e.g. `create-sound.use-case.ts`, `find-sound-by-id.use-case.ts`).

---

## 4. Adapter Layer

### 4a. Repository

Three files per aggregate:

| File | Purpose |
|---|---|
| `sound.repository.ts` | Abstract class — the port |
| `sound-prisma.repository.ts` | Prisma implementation — the real adapter |
| `sound-memory.repository.ts` | In-memory implementation — for unit tests |

**Abstract repository (port):**

```ts
export abstract class SoundRepository {
  abstract save(sound: SoundModel): Promise<SoundModel>;
  abstract update(sound: SoundModel): Promise<SoundModel>;
  abstract findByID(id: number): Promise<SoundModel>;
  abstract filter(filter: FilterSoundEntity): Promise<FilterSoundResultEntity>;
}
```

> Use an `abstract class`, not an `interface`. NestJS DI resolves tokens at runtime, so interfaces (erased at compile time) cannot be injection tokens.

**Prisma implementation:**

```ts
@Injectable()
export class SoundPrismaRepository implements SoundRepository {
  constructor(private readonly prisma: PrismaService) {}

  async save(sound: SoundModel): Promise<SoundModel> {
    const data = { ...sound };
    delete data.id;
    return this.prisma.sound.create({ data }) as unknown as SoundModel;
  }
  // ...
}
```

**Model (flat POJO):**

```ts
export class SoundModel {
  id: number;
  title: string;
  fileUrl: string;
  status: string;
  // audit fields flattened:
  createdAt: Date;
  createdBy: number;
  lastUpdatedAt?: Date | null;
  lastUpdatedBy?: number | null;

  static fromDomain(entity: SoundEntity): SoundModel {
    return {
      id: entity.id,
      title: entity.title,
      fileUrl: entity.fileUrl,
      status: entity.status,
      createdAt: entity.audit.createdAt,
      createdBy: entity.audit.createdBy,   // may be null
      lastUpdatedAt: entity.audit.lastUpdatedAt,
      lastUpdatedBy: entity.audit.lastUpdatedBy,
    };
  }
}
```

- `SoundModel` mirrors the Prisma schema row exactly (audit fields are flattened, not nested).
- `fromDomain()` converts `Entity → Model` (for writes).
- `Entity.fromModel()` converts `Model → Entity` (for reads).

### 4b. Controller

Controllers are versioned via the route prefix:

```ts
@Controller('v1/sounds')
@UseInterceptors(ClassSerializerInterceptor)
export class SoundController {
  constructor(
    private readonly createSound: CreateSoundUseCase,
    private readonly findSoundById: FindSoundByIdUseCase,
  ) {}

  @Post()
  @ApiBody({ type: SoundRequestDto })
  @ApiResponse({ status: 201, type: SoundResponseDto })
  async create(@Body() body: SoundRequestDto): Promise<SoundResponseDto> {
    const entity = body.toDomain(requestingUserID);
    const saved = await this.createSound.execute(entity);
    return SoundResponseDto.fromDomain(saved);
  }
}
```

Rules:
- Controllers only translate HTTP ↔ domain. No business logic here.
- All ID params must be validated with `Number(param)` + `isNaN` guard before calling use cases.
- Swagger decorators (`@ApiBody`, `@ApiResponse`) are required on every endpoint.

### 4c. DTOs

**Request DTO** — validates input, converts to domain entity:

```ts
export class SoundRequestDto {
  @ApiProperty()
  @IsString()
  title: string;

  @ApiProperty()
  @IsUrl()
  fileUrl: string;

  toDomain(createdBy: number): SoundEntity {
    return SoundEntity.new({
      title: this.title,
      fileUrl: this.fileUrl,
      status: SoundStatusEnum.ACTIVE,
      audit: Audit.new({
        createdAt: new Date(),
        createdBy,
        lastUpdatedAt: null,
        lastUpdatedBy: null,
      }),
    });
  }
}
```

**Response DTO** — shapes the API response from a domain entity:

```ts
export class SoundResponseDto {
  id: number;
  title: string;
  fileUrl: string;
  status: SoundStatusEnum;

  static fromDomain(entity: SoundEntity): SoundResponseDto {
    return {
      id: entity.id,
      title: entity.title,
      fileUrl: entity.fileUrl,
      status: entity.status,
    };
  }
}
```

---

## 5. Exception Handling

### Domain exceptions

Extend `TrupeHTTPException`. Exceptions carry a machine-readable `errorCode` string — the frontend is responsible for mapping codes to localized messages.

```ts
export abstract class TrupeHTTPException extends HttpException {
  readonly errorCode: string;
  readonly retryable: boolean;

  constructor(errorCode: string, status: number, retryable = false) {
    super(errorCode, status);
    this.errorCode = errorCode;
    this.retryable = retryable;
  }
}
```

```ts
export class SoundNotFoundException extends TrupeHTTPException {
  constructor() {
    super('SOUND_NOT_FOUND', HttpStatus.NOT_FOUND);
  }
}
```

Error codes are plain `SCREAMING_SNAKE_CASE` strings defined as constants in `src/common/constants/errors.ts`:

```ts
export const ErrorCodes = Object.freeze({
  SOUND_NOT_FOUND: 'SOUND_NOT_FOUND',
  EMAIL_IN_USE: 'EMAIL_IN_USE',
  INVALID_ID: 'INVALID_ID',
});
```

### Global filters (registered in `main.ts`)

- `HttpExceptionFilter` — catches all `HttpException`, formats the JSON error response:

```json
{
  "statusCode": 404,
  "errorCode": "SOUND_NOT_FOUND",
  "retryable": false,
  "timestamp": "2026-06-05T12:00:00.000Z",
  "path": "/api/v1/sounds/99"
}
```

- `ValidationExceptionFilter` — catches `BadRequestException` from `class-validator`, logs and returns the validation errors.

---

## 6. NestJS Module Wiring

```ts
@Module({
  providers: [
    PrismaService,
    CreateSoundUseCase,
    FindSoundByIdUseCase,
    {
      provide: SoundRepository,      // token = abstract class
      useClass: SoundPrismaRepository, // implementation
    },
  ],
  exports: [FindSoundByIdUseCase, SoundRepository],
  controllers: [SoundController],
})
export class SoundModule {}
```

Rules:
- Register the abstract repository as the token, provide the Prisma implementation. Swap to memory for tests.
- Export use cases or repositories only when another module needs them.
- `PrismaService` should be provided locally in each module that uses it. Do not make it global.

---

## 7. Prisma Schema Conventions

```prisma
model Sound {
  id            Int       @id @default(autoincrement())
  title         String
  fileUrl       String
  status        String    // SoundStatusEnum: ACTIVE | INACTIVE
  active        Boolean   @default(true)
  // audit
  createdAt     DateTime
  createdBy     Int?      // null = system-initiated write
  lastUpdatedAt DateTime?
  lastUpdatedBy Int?
}
```

- IDs are `Int @id @default(autoincrement())`.
- Enum columns are stored as `String` in the DB and cast to TypeScript enums in the entity layer.
- Audit fields (`createdAt`, `createdBy`, `lastUpdatedAt`, `lastUpdatedBy`) are flattened on every model — no separate audit table.
- **Soft-delete** (`active Boolean @default(true)`) only on entities that other records reference by ID. Deleting them sets `active = false` — the row is kept so foreign-key references remain valid. Purely transient or junction records with no dependents are hard-deleted.

---

## 8. MVP Scope

The following modules are in scope for the proof-of-concept backend:

| Module | Description |
|---|---|
| `sound` | Audio file metadata (title, fileUrl, status). The foundational media entity. |
| `sound-cue` | A reference to a `Sound` with playback parameters (volume, offset, etc.). |
| `act` | An ordered collection of `SoundCue`s. |
| `play` | An ordered collection of `Acts`. |

**Out of scope for MVP:**
- `musician` / user management — no auth, no user accounts.
- Any admin or management endpoints beyond basic CRUD.

---

## 9. File Storage

Audio files live in external object storage (S3-compatible). The backend never buffers or streams audio — it only stores the resulting URL.

**Upload flow:**

```
1. Frontend requests a pre-signed upload URL from the storage provider directly.
2. Frontend uploads the file to object storage using that URL.
3. Frontend calls POST /v1/sounds with the metadata + the final file URL.
4. Backend persists the metadata row (including fileUrl) to the DB.
```

The `fileUrl` column on any media entity is a plain `String` — a fully-qualified HTTPS URL pointing to the file in object storage. The backend never constructs or validates this URL beyond presence checks.

---

## 10. Data Flow Summary

```
HTTP Request
  └── Controller                      ← validates route params, calls DTO.toDomain()
        └── Use Case (execute)        ← business logic, throws domain exceptions
              └── Repository (save/find)
                    ├── Model.fromDomain()  ← Entity → flat POJO
                    ├── Prisma             ← DB operation
                    └── Entity.fromModel()  ← flat POJO → Entity
  └── ResponseDto.fromDomain(entity)  ← Entity → HTTP response shape
```

---

## 11. Naming Conventions

| Artifact | Convention | Example |
|---|---|---|
| Domain entity | `<Entity>Entity` | `SoundEntity` |
| Entity file | `<entity>.entity.ts` | `sound.entity.ts` |
| DB model | `<Entity>Model` | `SoundModel` |
| Model file | `<entity>.model.ts` | `sound.model.ts` |
| Repository (abstract) | `<Entity>Repository` | `SoundRepository` |
| Repository file | `<entity>.repository.ts` | `sound.repository.ts` |
| Prisma repository | `<Entity>PrismaRepository` | `SoundPrismaRepository` |
| Memory repository | `<Entity>MemoryRepository` | `SoundMemoryRepository` |
| Use case class | `<Verb><Noun>UseCase` | `CreateSoundUseCase` |
| Use case file | `<verb>-<noun>.use-case.ts` | `create-sound.use-case.ts` |
| Controller | `<Entity>Controller` | `SoundController` |
| Request DTO | `<Entity>RequestDto` | `SoundRequestDto` |
| Response DTO | `<Entity>ResponseDto` | `SoundResponseDto` |
| Exception | `<Reason>Exception` | `SoundNotFoundException` |
| Module | `<Entity>Module` | `SoundModule` |
| Module file | `<entity>.module.ts` | `sound.module.ts` |

---

## 12. Testing

### Unit tests (controller layer)

Use `@nestjs/testing` with mocked use cases. Place spec files alongside the file under test (`*.spec.ts`).

```ts
describe('SoundController', () => {
  let controller: SoundController;
  const mockCreateSound = { execute: jest.fn() };

  beforeEach(async () => {
    const module = await Test.createTestingModule({
      controllers: [SoundController],
      providers: [{ provide: CreateSoundUseCase, useValue: mockCreateSound }],
    }).compile();

    controller = module.get<SoundController>(SoundController);
  });

  it('should create a sound', async () => {
    // given
    const entity = SoundEntity.new({ ... });
    mockCreateSound.execute.mockResolvedValue(entity);

    // when
    const result = await controller.create(dto);

    // then
    expect(result.title).toBe(entity.title);
  });
});
```

### Unit tests (use case / repository layer)

Inject the `MemoryRepository` implementation to avoid DB dependency:

```ts
const repo = new SoundMemoryRepository();
const useCase = new CreateSoundUseCase(repo);
```

### Test naming style

Use `given / when / then` comments inside each test case (see example above).

---

## 13. Project Setup

```bash
pnpm install
pnpm start:dev          # watch mode
pnpm test               # unit tests
pnpm test:e2e           # end-to-end tests
pnpm prisma migrate dev # apply migrations
pnpm prisma generate    # regenerate client after schema changes
```

Environment variables go in `.env` (not committed). Minimum required:

```
DATABASE_URL=postgresql://user:password@localhost:5432/trupesound
```

---

## 14. Authentication

> **Not implemented in the MVP.** All endpoints are unauthenticated during the proof-of-concept phase.

When authentication is added, the chosen strategy is **email + password with JWT** (`@nestjs/jwt`). The plan:

- An `auth` module owns the `POST /v1/auth/login` endpoint and issues a signed JWT.
- Protected routes use a NestJS `AuthGuard` that validates the token and attaches the resolved user ID to the request.
- The `createdBy` / `lastUpdatedBy` audit fields are populated from the authenticated user ID extracted from the JWT — not from the request body.
- OAuth providers (Google, etc.) can be added later as additional adapters inside the `auth` module without touching any other module.
