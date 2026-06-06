import { Module } from '@nestjs/common';
import { PrismaService } from '../common/application/service/prisma-client.service';
import { SoundRepository } from './adapters/repository/sound.repository';
import { SoundPrismaRepository } from './adapters/repository/sound-prisma.repository';
import { SoundController } from './adapters/controller/v1/sound.controller';
import { ListSoundsUseCase } from './use-cases/list-sounds.use-case';
import { CreateSoundUseCase } from './use-cases/create-sound.use-case';
import { UpdateSoundUseCase } from './use-cases/update-sound.use-case';
import { ArchiveSoundUseCase } from './use-cases/archive-sound.use-case';

@Module({
  controllers: [SoundController],
  providers: [
    PrismaService,
    ListSoundsUseCase,
    CreateSoundUseCase,
    UpdateSoundUseCase,
    ArchiveSoundUseCase,
    { provide: SoundRepository, useClass: SoundPrismaRepository },
  ],
})
export class SoundModule {}
