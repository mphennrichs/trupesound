import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsInt, IsNotEmpty, IsOptional, IsString, Min } from 'class-validator';

export class CreateSoundRequestDto {
  @ApiProperty() @IsString() @IsNotEmpty() name: string;
  @ApiProperty() @IsString() @IsNotEmpty() category: string;
  @ApiProperty() @IsString() @IsNotEmpty() url: string;
  @ApiPropertyOptional() @IsInt() @Min(0) @IsOptional() durationMs?: number;
}
