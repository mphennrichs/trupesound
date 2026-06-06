import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsNotEmpty, IsOptional, IsString } from 'class-validator';

export class StorageConfigRequestDto {
  @ApiProperty() @IsString() @IsNotEmpty() endpoint: string;
  @ApiProperty() @IsString() @IsNotEmpty() accessKey: string;
  @ApiProperty() @IsString() @IsNotEmpty() secretKey: string;
  @ApiPropertyOptional() @IsString() @IsOptional() localFolder?: string;
}
