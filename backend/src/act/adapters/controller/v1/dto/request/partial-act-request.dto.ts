import { ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsArray, IsInt, IsOptional, IsString, Min, ValidateNested } from 'class-validator';
import { PartialActEntity } from '../../../../../entities/partial-act.entity';
import { ScriptLineDto } from './script-line.dto';
import { SoundCueDto } from './sound-cue.dto';

export class PartialActRequestDto {
  @ApiPropertyOptional()
  @IsOptional()
  @IsInt()
  @Min(1)
  number?: number;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  name?: string;

  @ApiPropertyOptional({ type: [ScriptLineDto] })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => ScriptLineDto)
  script?: ScriptLineDto[];

  @ApiPropertyOptional({ type: [SoundCueDto] })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => SoundCueDto)
  cues?: SoundCueDto[];

  toDomain(): PartialActEntity {
    return PartialActEntity.new({
      number: this.number,
      name: this.name,
      script: this.script,
      cues: this.cues,
    });
  }
}
