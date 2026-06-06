import { Injectable } from '@nestjs/common';
import { ActRepository } from '../adapters/repository/act.repository';
import { ActEntity } from '../entities/act.entity';
import { ActModel } from '../adapters/repository/model/act.model';
import { PartialActEntity } from '../entities/partial-act.entity';
import { ActNotFoundException } from '../exceptions/act-not-found.exception';

@Injectable()
export class UpdateActUseCase {
  constructor(private readonly actRepository: ActRepository) {}

  async execute(id: number, partial: PartialActEntity): Promise<ActEntity> {
    const existing = await this.actRepository.findByID(id);
    if (!existing) throw new ActNotFoundException();

    const { id: _id, ...data } = existing;
    const updated: ActModel = {
      id,
      ...data,
      ...(partial.number !== undefined && { number: partial.number }),
      ...(partial.name !== undefined && { name: partial.name }),
      ...(partial.script !== undefined && { script: partial.script }),
      lastUpdatedAt: new Date(),
      lastUpdatedBy: null,
    };

    const saved = await this.actRepository.update(updated);
    return ActEntity.fromModel(saved);
  }
}
