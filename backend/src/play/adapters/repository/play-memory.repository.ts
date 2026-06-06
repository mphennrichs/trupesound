import { Injectable } from '@nestjs/common';
import { FilterPlayEntity } from '../../entities/filter-play.entity';
import { FilterPlayResultEntity } from '../../entities/filter-play-result.entity';
import { PlayEntity, PlayStatusEnum } from '../../entities/play.entity';
import { PlayRepository } from './play.repository';
import { PlayModel } from './model/play.model';

@Injectable()
export class PlayMemoryRepository implements PlayRepository {
  private plays: PlayModel[] = [];

  async save(play: PlayModel): Promise<PlayModel> {
    play.id = this.plays.length + 1;
    this.plays.push(play);
    return play;
  }

  async update(play: PlayModel): Promise<PlayModel> {
    const index = this.plays.findIndex((p) => p.id === play.id);
    this.plays[index] = play;
    return play;
  }

  async findByID(id: number): Promise<PlayModel> {
    return this.plays.find((p) => p.id === id && p.active);
  }

  async filter(filter: FilterPlayEntity): Promise<FilterPlayResultEntity> {
    let result = this.plays.filter((p) => p.active);

    if (filter.title) {
      result = result.filter((p) =>
        p.title.toLowerCase().includes(filter.title.toLowerCase()),
      );
    }
    if (filter.author) {
      result = result.filter((p) =>
        p.author.toLowerCase().includes(filter.author.toLowerCase()),
      );
    }

    return FilterPlayResultEntity.new({
      total: result.length,
      data: result.map((p) => PlayEntity.fromModel(p)),
    });
  }

  async softDelete(id: number): Promise<void> {
    const index = this.plays.findIndex((p) => p.id === id);
    if (index !== -1) {
      this.plays[index].active = false;
      this.plays[index].status = PlayStatusEnum.INACTIVE;
    }
  }
}
