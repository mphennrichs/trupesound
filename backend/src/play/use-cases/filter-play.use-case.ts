import { Injectable } from '@nestjs/common';
import { PlayRepository } from '../adapters/repository/play.repository';
import { FilterPlayEntity } from '../entities/filter-play.entity';
import { FilterPlayResultEntity } from '../entities/filter-play-result.entity';

@Injectable()
export class FilterPlayUseCase {
  constructor(private readonly playRepository: PlayRepository) {}

  async execute(filter: FilterPlayEntity): Promise<FilterPlayResultEntity> {
    return this.playRepository.filter(filter);
  }
}
