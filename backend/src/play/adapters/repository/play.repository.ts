import { FilterPlayEntity } from '../../entities/filter-play.entity';
import { FilterPlayResultEntity } from '../../entities/filter-play-result.entity';
import { PlayModel } from './model/play.model';

export abstract class PlayRepository {
  abstract save(play: PlayModel): Promise<PlayModel>;
  abstract update(play: PlayModel): Promise<PlayModel>;
  abstract findByID(id: number): Promise<PlayModel>;
  abstract filter(filter: FilterPlayEntity): Promise<FilterPlayResultEntity>;
  abstract softDelete(id: number): Promise<void>;
}
