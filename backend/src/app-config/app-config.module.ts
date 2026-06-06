import { Module } from '@nestjs/common';
import { PrismaService } from '../common/application/service/prisma-client.service';
import { AppConfigController } from './adapters/controller/v1/app-config.controller';
import { AppConfigPrismaRepository } from './adapters/repository/app-config-prisma.repository';
import { AppConfigRepository } from './adapters/repository/app-config.repository';
import { GetStorageConfigUseCase } from './use-cases/get-storage-config.use-case';
import { InitAppUseCase } from './use-cases/init-app.use-case';
import { SaveStorageConfigUseCase } from './use-cases/save-storage-config.use-case';

@Module({
  providers: [
    PrismaService,
    InitAppUseCase,
    GetStorageConfigUseCase,
    SaveStorageConfigUseCase,
    {
      provide: AppConfigRepository,
      useClass: AppConfigPrismaRepository,
    },
  ],
  controllers: [AppConfigController],
})
export class AppConfigModule {}
