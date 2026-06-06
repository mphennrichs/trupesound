import { Injectable } from '@nestjs/common';
import { PlayRepository } from '../adapters/repository/play.repository';
import { PlayModel } from '../adapters/repository/model/play.model';
import { PlayEntity } from '../entities/play.entity';

@Injectable()
export class CreatePlayUseCase {
  constructor(private readonly playRepository: PlayRepository) {}

  async execute(play: PlayEntity): Promise<PlayEntity> {
    const model = PlayModel.fromDomain(play);
    const saved = await this.playRepository.save(model);
    return PlayEntity.fromModel(saved);
  }
}
