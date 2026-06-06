import { ApiProperty } from '@nestjs/swagger';

export class SoundResponseDto {
  @ApiProperty() id: number;
  @ApiProperty() name: string;
  @ApiProperty() category: string;
  @ApiProperty() durationMs: number;
  @ApiProperty() url: string;
  @ApiProperty() archived: boolean;
  @ApiProperty() createdAt: Date;
}
