import { Injectable } from '@nestjs/common';
import { randomUUID } from 'crypto';
import { PrismaService } from '../../../common/application/service/prisma-client.service';
import { AppConfigRepository } from './app-config.repository';

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
}
