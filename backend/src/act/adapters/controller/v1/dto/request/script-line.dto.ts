import { ApiProperty } from '@nestjs/swagger';
import { IsInt, IsString, Min } from 'class-validator';

export class ScriptLineDto {
  @ApiProperty()
  @IsInt()
  @Min(1)
  line: number;

  @ApiProperty()
  @IsString()
  text: string;
}
