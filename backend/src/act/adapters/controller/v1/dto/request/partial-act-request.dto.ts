import { ApiPropertyOptional } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsArray, IsInt, IsOptional, IsString, Min, ValidateNested } from 'class-validator';
import { PartialActEntity } from '../../../../../entities/partial-act.entity';
import { ScriptLineDto } from './script-line.dto';

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

  toDomain(): PartialActEntity {
    return PartialActEntity.new({
      number: this.number,
      name: this.name,
      script: this.script,
    });
  }
}
