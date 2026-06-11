import { ApiProperty } from '@nestjs/swagger';

export class StorageModeResponseDto {
  @ApiProperty({ enum: ['local', 'cloud', 'unknown'] })
  mode: 'local' | 'cloud' | 'unknown';
}
