import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { PlayEntity, PlayStatusEnum, ActSummary } from '../../../../../entities/play.entity';

export class ActSummaryResponseDto {
  @ApiProperty() id: number;
  @ApiProperty() number: number;
  @ApiProperty() name: string;
}

export class PlayResponseDto {
  @ApiProperty() id: number;
  @ApiProperty() title: string;
  @ApiProperty() author: string;
  @ApiProperty({ enum: PlayStatusEnum }) status: PlayStatusEnum;
  @ApiPropertyOptional({ type: [ActSummaryResponseDto] }) acts?: ActSummaryResponseDto[];
  @ApiPropertyOptional() icon?: number | null;
  @ApiPropertyOptional() backgroundColor?: string | null;

  static fromDomain(entity: PlayEntity): PlayResponseDto {
    return {
      id: entity.id,
      title: entity.title,
      author: entity.author,
      status: entity.status,
      acts: entity.acts,
      icon: entity.icon,
      backgroundColor: entity.backgroundColor,
    };
  }
}

export class FilterPlayResponseDto {
  @ApiProperty() total: number;
  @ApiProperty({ type: [PlayResponseDto] }) data: PlayResponseDto[];
}
