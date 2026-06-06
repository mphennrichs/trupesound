import { Injectable } from '@nestjs/common';
import { PlayRepository } from '../adapters/repository/play.repository';
import { PlayEntity } from '../entities/play.entity';
import { PlayNotFoundException } from '../exceptions/play-not-found.exception';

@Injectable()
export class FindPlayByIdUseCase {
  constructor(private readonly playRepository: PlayRepository) {}

  async execute(id: number): Promise<PlayEntity> {
    const model = await this.playRepository.findByID(id);
    if (!model) throw new PlayNotFoundException();
    return PlayEntity.fromModel(model);
  }
}
