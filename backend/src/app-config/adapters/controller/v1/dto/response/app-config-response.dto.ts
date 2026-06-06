import { ApiProperty } from '@nestjs/swagger';

export class AppConfigResponseDto {
  @ApiProperty() appId: string;
}
