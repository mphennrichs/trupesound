import { Module } from '@nestjs/common';
import { PrismaService } from '../common/application/service/prisma-client.service';
import { ActController } from './adapters/controller/v1/act.controller';
import { ActPrismaRepository } from './adapters/repository/act-prisma.repository';
import { ActRepository } from './adapters/repository/act.repository';
import { CreateActUseCase } from './use-cases/create-act.use-case';
import { DeleteActUseCase } from './use-cases/delete-act.use-case';
import { FilterActUseCase } from './use-cases/filter-act.use-case';
import { FindActByIdUseCase } from './use-cases/find-act-by-id.use-case';
import { UpdateActUseCase } from './use-cases/update-act.use-case';

@Module({
  providers: [
    PrismaService,
    CreateActUseCase,
    FindActByIdUseCase,
    FilterActUseCase,
    UpdateActUseCase,
    DeleteActUseCase,
    {
      provide: ActRepository,
      useClass: ActPrismaRepository,
    },
  ],
  controllers: [ActController],
})
export class ActModule {}
