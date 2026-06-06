import { ApiProperty } from '@nestjs/swagger';
import { Type } from 'class-transformer';
import { IsArray, IsInt, IsNotEmpty, IsString, Min, ValidateNested } from 'class-validator';
import { Audit } from '../../../../../../common/entities/audit';
import { ActEntity } from '../../../../../entities/act.entity';
import { ScriptLineDto } from './script-line.dto';

export class ActRequestDto {
  @ApiProperty()
  @IsInt()
  playId: number;

  @ApiProperty()
  @IsInt()
  @Min(1)
  number: number;

  @ApiProperty()
  @IsString()
  name: string;

  @ApiProperty({ type: [ScriptLineDto] })
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => ScriptLineDto)
  script: ScriptLineDto[];

  toDomain(): ActEntity {
    return ActEntity.new({
      playId: this.playId,
      number: this.number,
      name: this.name,
      script: this.script,
      audit: Audit.new({
        createdAt: new Date(),
        createdBy: null,
        lastUpdatedAt: null,
        lastUpdatedBy: null,
      }),
    });
  }
}
