import { Injectable } from '@nestjs/common';
import { ActRepository } from '../adapters/repository/act.repository';
import { ActModel } from '../adapters/repository/model/act.model';
import { ActEntity } from '../entities/act.entity';

@Injectable()
export class CreateActUseCase {
  constructor(private readonly actRepository: ActRepository) {}

  async execute(act: ActEntity): Promise<ActEntity> {
    const model = ActModel.fromDomain(act);
    const saved = await this.actRepository.save(model);
    return ActEntity.fromModel(saved);
  }
}
