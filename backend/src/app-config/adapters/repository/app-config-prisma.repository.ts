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
    const endpoint = process.env.STORAGE_ENDPOINT ?? '';
    const accessKey = process.env.STORAGE_ACCESS_KEY ?? '';
    const secretKey = process.env.STORAGE_SECRET_KEY ?? '';
    const localFolder = process.env.STORAGE_LOCAL_FOLDER ?? '';

    if (!endpoint && !localFolder) return null;

    return { endpoint, accessKey, secretKey, localFolder };
  }

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  async saveStorageConfig(_config: StorageConfig): Promise<void> {
    // Storage config is now managed via environment variables — this is a no-op.
  }
}
