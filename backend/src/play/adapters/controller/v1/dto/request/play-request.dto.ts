import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsInt, IsNotEmpty, IsOptional, IsString } from 'class-validator';
import { Audit } from '../../../../../../common/entities/audit';
import { PlayEntity, PlayStatusEnum } from '../../../../../entities/play.entity';

export class PlayRequestDto {
  @ApiProperty()
  @IsString()
  @IsNotEmpty()
  title: string;

  @ApiProperty()
  @IsString()
  @IsNotEmpty()
  author: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsInt()
  icon?: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  backgroundColor?: string;

  toDomain(): PlayEntity {
    return PlayEntity.new({
      title: this.title,
      author: this.author,
      status: PlayStatusEnum.ACTIVE,
      icon: this.icon ?? null,
      backgroundColor: this.backgroundColor ?? null,
      audit: Audit.new({
        createdAt: new Date(),
        createdBy: null,
        lastUpdatedAt: null,
        lastUpdatedBy: null,
      }),
    });
  }
}
