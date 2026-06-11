import { Injectable } from '@nestjs/common';
import { randomUUID } from 'crypto';
import { PrismaService } from '../../../common/application/service/prisma-client.service';
import { AppConfigRepository, StorageConfig } from './app-config.repository';

@Injectable()
export class AppConfigPrismaRepository implements AppConfigRepository {
  constructor(private readonly prisma: PrismaService) {}

  async findOrCreate(): Promise<string> {
    const existing = await this.prisma.appConfig.findUnique({ where: { id: 1 } });
    if (existing) return existing.appId;

    const created = await this.prisma.appConfig.create({
      data: { id: 1, appId: randomUUID() },
    });
    return created.appId;
  }

  async getStorageConfig(): Promise<StorageConfig | null> {
    const row = await this.prisma.appConfig.findUnique({ where: { id: 1 } });
    if (!row) return null;
    if (!row.storageEndpoint && !row.localFolder) return null;
    return {
      endpoint: row.storageEndpoint ?? '',
      accessKey: row.storageAccessKey ?? '',
      secretKey: row.storageSecretKey ?? '',
      localFolder: row.localFolder ?? '',
    };
  }

  async saveStorageConfig(config: StorageConfig): Promise<void> {
    await this.prisma.appConfig.upsert({
      where: { id: 1 },
      update: {
        storageEndpoint: config.endpoint,
        storageAccessKey: config.accessKey,
        storageSecretKey: config.secretKey,
        localFolder: config.localFolder,
      },
      create: {
        id: 1,
        appId: randomUUID(),
        storageEndpoint: config.endpoint,
        storageAccessKey: config.accessKey,
        storageSecretKey: config.secretKey,
        localFolder: config.localFolder,
      },
    });
  }
}
