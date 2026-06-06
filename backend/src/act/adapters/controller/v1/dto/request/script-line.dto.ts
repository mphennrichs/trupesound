import { ApiProperty } from '@nestjs/swagger';
import { IsInt, IsString, Min } from 'class-validator';

export class ScriptLineDto {
  @ApiProperty()
  @IsInt()
  @Min(1)
  lineNumber: number;

  @ApiProperty()
  @IsString()
  text: string;
}
