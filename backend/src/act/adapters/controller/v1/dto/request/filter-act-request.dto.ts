import { ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsInt, IsOptional } from 'class-validator';
import { FilterActEntity } from '../../../../../entities/filter-act.entity';

export class FilterActRequestDto {
  @ApiPropertyOptional()
  @IsOptional()
  @IsInt()
  @Type(() => Number)
  playId?: number;

  toDomain(): FilterActEntity {
    return FilterActEntity.new({ playId: this.playId });
  }
}
