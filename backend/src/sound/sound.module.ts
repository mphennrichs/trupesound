import { Module } from '@nestjs/common';
import { PrismaService } from '../common/application/service/prisma-client.service';
import { AppConfigModule } from '../app-config/app-config.module';
import { SoundRepository } from './adapters/repository/sound.repository';
import { SoundPrismaRepository } from './adapters/repository/sound-prisma.repository';
import { SoundController } from './adapters/controller/v1/sound.controller';
import { ListSoundsUseCase } from './use-cases/list-sounds.use-case';
import { CreateSoundUseCase } from './use-cases/create-sound.use-case';
import { UpdateSoundUseCase } from './use-cases/update-sound.use-case';
import { ArchiveSoundUseCase } from './use-cases/archive-sound.use-case';
import { UploadLocalSoundUseCase } from './use-cases/upload-local-sound.use-case';
import { ServeLocalSoundUseCase } from './use-cases/serve-local-sound.use-case';
import { SyncLocalSoundsUseCase } from './use-cases/sync-local-sounds.use-case';

@Module({
  imports: [AppConfigModule],
  controllers: [SoundController],
  providers: [
    PrismaService,
    ListSoundsUseCase,
    CreateSoundUseCase,
    UpdateSoundUseCase,
    ArchiveSoundUseCase,
    UploadLocalSoundUseCase,
    ServeLocalSoundUseCase,
    SyncLocalSoundsUseCase,
    { provide: SoundRepository, useClass: SoundPrismaRepository },
  ],
})
export class SoundModule {}
