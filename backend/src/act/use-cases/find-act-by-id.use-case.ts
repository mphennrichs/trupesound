import { Injectable } from '@nestjs/common';
import { ActRepository } from '../adapters/repository/act.repository';
import { ActEntity } from '../entities/act.entity';
import { ActNotFoundException } from '../exceptions/act-not-found.exception';

@Injectable()
export class FindActByIdUseCase {
  constructor(private readonly actRepository: ActRepository) {}

  async execute(id: number): Promise<ActEntity> {
    const model = await this.actRepository.findByID(id);
    if (!model) throw new ActNotFoundException();
    return ActEntity.fromModel(model);
  }
}
