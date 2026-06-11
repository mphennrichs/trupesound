import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../common/application/service/prisma-client.service';
import { Sound } from '../../entities/sound.entity';
import { CreateSoundInput, SoundRepository, UpdateSoundInput } from './sound.repository';

@Injectable()
export class SoundPrismaRepository implements SoundRepository {
  constructor(private readonly prisma: PrismaService) {}

  private toEntity(row: any): Sound {
    return new Sound({
      id: row.id,
      name: row.name,
      category: row.category,
      durationMs: row.durationMs,
      url: row.url,
      archived: row.archived,
      createdAt: row.createdAt,
    });
  }

  async list(): Promise<Sound[]> {
    const rows = await this.prisma.sound.findMany({
      where: { archived: false },
      orderBy: { createdAt: 'desc' },
    });
    return rows.map(this.toEntity);
  }

  async findById(id: number): Promise<Sound | null> {
    const row = await this.prisma.sound.findUnique({ where: { id } });
    return row ? this.toEntity(row) : null;
  }

  async findByUrl(url: string): Promise<Sound | null> {
    const row = await this.prisma.sound.findFirst({ where: { url } });
    return row ? this.toEntity(row) : null;
  }

  async create(input: CreateSoundInput): Promise<Sound> {
    const row = await this.prisma.sound.create({
      data: {
        name: input.name,
        category: input.category,
        durationMs: input.durationMs,
        url: input.url,
        createdAt: new Date(),
      },
    });
    return this.toEntity(row);
  }

  async update(id: number, input: UpdateSoundInput): Promise<Sound> {
    const row = await this.prisma.sound.update({
      where: { id },
      data: {
        ...(input.name !== undefined && { name: input.name }),
        ...(input.category !== undefined && { category: input.category }),
      },
    });
    return this.toEntity(row);
  }

  async updateDuration(id: number, durationMs: number): Promise<void> {
    await this.prisma.sound.update({ where: { id }, data: { durationMs } });
  }

  async archive(id: number): Promise<void> {
    await this.prisma.sound.update({ where: { id }, data: { archived: true } });
  }
}
