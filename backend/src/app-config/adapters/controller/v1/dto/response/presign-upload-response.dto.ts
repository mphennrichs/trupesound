import { ApiProperty } from '@nestjs/swagger';

export class PresignUploadResponseDto {
  @ApiProperty() uploadUrl: string;
  @ApiProperty() objectUrl: string;
}
