import { Injectable } from '@nestjs/common';
import { PlayRepository } from '../adapters/repository/play.repository';
import { PlayEntity } from '../entities/play.entity';
import { PlayModel } from '../adapters/repository/model/play.model';
import { PartialPlayEntity } from '../entities/partial-play.entity';
import { PlayNotFoundException } from '../exceptions/play-not-found.exception';

@Injectable()
export class UpdatePlayUseCase {
  constructor(private readonly playRepository: PlayRepository) {}

  async execute(id: number, partial: PartialPlayEntity): Promise<PlayEntity> {
    const existing = await this.playRepository.findByID(id);
    if (!existing) throw new PlayNotFoundException();

    const { acts, ...data } = existing;
    const updated: PlayModel = {
      ...data,
      ...(partial.title !== undefined && { title: partial.title }),
      ...(partial.author !== undefined && { author: partial.author }),
      ...(partial.status !== undefined && { status: partial.status }),
      ...(partial.icon !== undefined && { icon: partial.icon }),
      ...(partial.backgroundColor !== undefined && { backgroundColor: partial.backgroundColor }),
      lastUpdatedAt: new Date(),
      lastUpdatedBy: null,
    };

    const saved = await this.playRepository.update(updated);
    return PlayEntity.fromModel(saved);
  }
}
