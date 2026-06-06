import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../../../common/application/service/prisma-client.service';
import { FilterActEntity } from '../../entities/filter-act.entity';
import { FilterActResultEntity } from '../../entities/filter-act-result.entity';
import { ActEntity } from '../../entities/act.entity';
import { ActRepository } from './act.repository';
import { ActModel } from './model/act.model';

@Injectable()
export class ActPrismaRepository implements ActRepository {
  constructor(private readonly prisma: PrismaService) {}

  async save(act: ActModel): Promise<ActModel> {
    const { id, ...data } = act;
    const saved = await this.prisma.act.create({
      data: data as Prisma.ActUncheckedCreateInput,
    });
    return saved as unknown as ActModel;
  }

  async update(act: ActModel): Promise<ActModel> {
    const { id, ...data } = act;
    const updated = await this.prisma.act.update({
      where: { id },
      data: data as Prisma.ActUncheckedUpdateInput,
    });
    return updated as unknown as ActModel;
  }

  async findByID(id: number): Promise<ActModel> {
    const act = await this.prisma.act.findUnique({ where: { id } });
    return act as unknown as ActModel;
  }

  async filter(filter: FilterActEntity): Promise<FilterActResultEntity> {
    const where: Prisma.ActWhereInput = {};

    if (filter.playId) {
      where.playId = filter.playId;
    }

    const [count, acts] = await Promise.all([
      this.prisma.act.count({ where }),
      this.prisma.act.findMany({ where, orderBy: { number: 'asc' } }),
    ]);

    return FilterActResultEntity.new({
      total: count,
      data: acts.map((a) => ActEntity.fromModel(a as unknown as ActModel)),
    });
  }

  async delete(id: number): Promise<void> {
    await this.prisma.act.delete({ where: { id } });
  }
}
