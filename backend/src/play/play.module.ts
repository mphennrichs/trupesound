import { Module } from '@nestjs/common';
import { PrismaService } from '../common/application/service/prisma-client.service';
import { PlayController } from './adapters/controller/v1/play.controller';
import { PlayPrismaRepository } from './adapters/repository/play-prisma.repository';
import { PlayRepository } from './adapters/repository/play.repository';
import { CreatePlayUseCase } from './use-cases/create-play.use-case';
import { DeletePlayUseCase } from './use-cases/delete-play.use-case';
import { FilterPlayUseCase } from './use-cases/filter-play.use-case';
import { FindPlayByIdUseCase } from './use-cases/find-play-by-id.use-case';
import { UpdatePlayUseCase } from './use-cases/update-play.use-case';

@Module({
  providers: [
    PrismaService,
    CreatePlayUseCase,
    FindPlayByIdUseCase,
    FilterPlayUseCase,
    UpdatePlayUseCase,
    DeletePlayUseCase,
    {
      provide: PlayRepository,
      useClass: PlayPrismaRepository,
    },
  ],
  controllers: [PlayController],
})
export class PlayModule {}
