import { ApiProperty } from '@nestjs/swagger';
import { ActEntity, ScriptLine, SoundCue } from '../../../../../entities/act.entity';

export class ScriptLineResponseDto {
  @ApiProperty() line: number;
  @ApiProperty() text: string;
}

export class SoundCueResponseDto {
  @ApiProperty() id: number;
  @ApiProperty() line: number;
  @ApiProperty() hotkey: string;
  @ApiProperty({ enum: ['once', 'repeat'] }) mode: 'once' | 'repeat';
  @ApiProperty() soundId: string;
  @ApiProperty() createdAt: string;
}

export class ActResponseDto {
  @ApiProperty() id: number;
  @ApiProperty() playId: number;
  @ApiProperty() number: number;
  @ApiProperty() name: string;
  @ApiProperty({ type: [ScriptLineResponseDto] }) script: ScriptLine[];
  @ApiProperty({ type: [SoundCueResponseDto] }) cues: SoundCue[];

  static fromDomain(entity: ActEntity): ActResponseDto {
    return {
      id: entity.id,
      playId: entity.playId,
      number: entity.number,
      name: entity.name,
      script: entity.script,
      cues: entity.cues,
    };
  }
}

export class FilterActResponseDto {
  @ApiProperty() total: number;
  @ApiProperty({ type: [ActResponseDto] }) data: ActResponseDto[];
}
