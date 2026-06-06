import { Injectable } from '@nestjs/common';
import { FilterActEntity } from '../../entities/filter-act.entity';
import { FilterActResultEntity } from '../../entities/filter-act-result.entity';
import { ActEntity } from '../../entities/act.entity';
import { ActRepository } from './act.repository';
import { ActModel } from './model/act.model';

@Injectable()
export class ActMemoryRepository implements ActRepository {
  private acts: ActModel[] = [];

  async save(act: ActModel): Promise<ActModel> {
    act.id = this.acts.length + 1;
    this.acts.push(act);
    return act;
  }

  async update(act: ActModel): Promise<ActModel> {
    const index = this.acts.findIndex((a) => a.id === act.id);
    this.acts[index] = act;
    return act;
  }

  async findByID(id: number): Promise<ActModel> {
    return this.acts.find((a) => a.id === id);
  }

  async filter(filter: FilterActEntity): Promise<FilterActResultEntity> {
    let result = [...this.acts];

    if (filter.playId) {
      result = result.filter((a) => a.playId === filter.playId);
    }

    result.sort((a, b) => a.number - b.number);

    return FilterActResultEntity.new({
      total: result.length,
      data: result.map((a) => ActEntity.fromModel(a)),
    });
  }

  async delete(id: number): Promise<void> {
    this.acts = this.acts.filter((a) => a.id !== id);
  }
}
