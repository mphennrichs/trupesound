import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsEnum, IsInt, IsOptional, IsString } from 'class-validator';
import { PlayStatusEnum } from '../../../../../entities/play.entity';
import { PartialPlayEntity } from '../../../../../entities/partial-play.entity';

export class PartialPlayRequestDto {
  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  title?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  author?: string;

  @ApiPropertyOptional({ enum: PlayStatusEnum })
  @IsOptional()
  @IsEnum(PlayStatusEnum)
  status?: PlayStatusEnum;

  @ApiPropertyOptional()
  @IsOptional()
  @IsInt()
  icon?: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  backgroundColor?: string;

  toDomain(): PartialPlayEntity {
    return PartialPlayEntity.new({
      title: this.title,
      author: this.author,
      status: this.status,
      icon: this.icon,
      backgroundColor: this.backgroundColor,
    });
  }
}
