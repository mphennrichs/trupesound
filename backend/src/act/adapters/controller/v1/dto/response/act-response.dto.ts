import { ApiProperty } from '@nestjs/swagger';
import { ActEntity, ScriptLine } from '../../../../../entities/act.entity';

export class ScriptLineResponseDto {
  @ApiProperty() lineNumber: number;
  @ApiProperty() text: string;
}

export class ActResponseDto {
  @ApiProperty() id: number;
  @ApiProperty() playId: number;
  @ApiProperty() number: number;
  @ApiProperty() name: string;
  @ApiProperty({ type: [ScriptLineResponseDto] }) script: ScriptLine[];

  static fromDomain(entity: ActEntity): ActResponseDto {
    return {
      id: entity.id,
      playId: entity.playId,
      number: entity.number,
      name: entity.name,
      script: entity.script,
    };
  }
}

export class FilterActResponseDto {
  @ApiProperty() total: number;
  @ApiProperty({ type: [ActResponseDto] }) data: ActResponseDto[];
}
