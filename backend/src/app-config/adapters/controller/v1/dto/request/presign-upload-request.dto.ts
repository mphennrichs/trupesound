import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsString } from 'class-validator';

export class PresignUploadRequestDto {
  @ApiProperty() @IsString() @IsNotEmpty() fileName: string;
}
