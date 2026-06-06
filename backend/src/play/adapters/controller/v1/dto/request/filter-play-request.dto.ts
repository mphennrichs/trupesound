import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString } from 'class-validator';
import { FilterPlayEntity } from '../../../../../entities/filter-play.entity';

export class FilterPlayRequestDto {
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  title?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  author?: string;

  toDomain(): FilterPlayEntity {
    return FilterPlayEntity.new({
      title: this.title,
      author: this.author,
    });
  }
}
