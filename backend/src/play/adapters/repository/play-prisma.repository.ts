import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../../../common/application/service/prisma-client.service';
import { FilterPlayEntity } from '../../entities/filter-play.entity';
import { FilterPlayResultEntity } from '../../entities/filter-play-result.entity';
import { PlayEntity, PlayStatusEnum } from '../../entities/play.entity';
import { PlayRepository } from './play.repository';
import { PlayModel } from './model/play.model';

@Injectable()
export class PlayPrismaRepository implements PlayRepository {
  constructor(private readonly prisma: PrismaService) {}

  async save(play: PlayModel): Promise<PlayModel> {
    const { id, acts, ...data } = play;
    const saved = await this.prisma.play.create({
      data: data as Prisma.PlayCreateInput,
    });
    return saved as unknown as PlayModel;
  }

  async update(play: PlayModel): Promise<PlayModel> {
    const { id, acts, ...data } = play;
    const updated = await this.prisma.play.update({
      where: { id },
      data: data as Prisma.PlayUpdateInput,
    });
    return updated as unknown as PlayModel;
  }

  async findByID(id: number): Promise<PlayModel> {
    const play = await this.prisma.play.findUnique({
      where: { id, active: true },
      include: {
        acts: {
          orderBy: { number: 'asc' },
          select: { id: true, number: true, name: true },
        },
      },
    });
    return play as unknown as PlayModel;
  }

  async filter(filter: FilterPlayEntity): Promise<FilterPlayResultEntity> {
    const where: Prisma.PlayWhereInput = { active: true };

    if (filter.title) {
      where.title = { contains: filter.title, mode: 'insensitive' };
    }
    if (filter.author) {
      where.author = { contains: filter.author, mode: 'insensitive' };
    }

    const [count, plays] = await Promise.all([
      this.prisma.play.count({ where }),
      this.prisma.play.findMany({ where }),
    ]);

    return FilterPlayResultEntity.new({
      total: count,
      data: plays.map((p) => PlayEntity.fromModel(p as unknown as PlayModel)),
    });
  }

  async softDelete(id: number): Promise<void> {
    await this.prisma.play.update({
      where: { id },
      data: { active: false, status: PlayStatusEnum.INACTIVE },
    });
  }
}
