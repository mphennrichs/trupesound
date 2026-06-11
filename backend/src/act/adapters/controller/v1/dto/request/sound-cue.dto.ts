import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsIn, IsInt, IsOptional, IsString } from 'class-validator';

export class SoundCueDto {
  @ApiProperty() @IsInt() id: number;
  @ApiProperty() @IsInt() line: number;
  @ApiProperty() @IsString() hotkey: string;
  @ApiProperty({ enum: ['once', 'repeat'] }) @IsIn(['once', 'repeat']) mode: 'once' | 'repeat';
  @ApiProperty() @IsString() soundId: string;
  @ApiProperty() @IsString() createdAt: string;
  @ApiPropertyOptional() @IsInt() @IsOptional() startMs?: number;
  @ApiPropertyOptional() @IsInt() @IsOptional() endMs?: number;
}
