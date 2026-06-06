import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class StorageConfigResponseDto {
  @ApiProperty() endpoint: string;
  @ApiProperty() accessKey: string;
  @ApiPropertyOptional() localFolder?: string;
}
