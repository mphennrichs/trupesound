import { Injectable } from '@nestjs/common';
import { ActRepository } from '../adapters/repository/act.repository';
import { FilterActEntity } from '../entities/filter-act.entity';
import { FilterActResultEntity } from '../entities/filter-act-result.entity';

@Injectable()
export class FilterActUseCase {
  constructor(private readonly actRepository: ActRepository) {}

  async execute(filter: FilterActEntity): Promise<FilterActResultEntity> {
    return this.actRepository.filter(filter);
  }
}
