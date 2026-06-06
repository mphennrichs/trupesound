import { FilterActEntity } from '../../entities/filter-act.entity';
import { FilterActResultEntity } from '../../entities/filter-act-result.entity';
import { ActModel } from './model/act.model';

export abstract class ActRepository {
  abstract save(act: ActModel): Promise<ActModel>;
  abstract update(act: ActModel): Promise<ActModel>;
  abstract findByID(id: number): Promise<ActModel>;
  abstract filter(filter: FilterActEntity): Promise<FilterActResultEntity>;
  abstract delete(id: number): Promise<void>;
}
