import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsString } from 'class-validator';

export class StorageConfigRequestDto {
  @ApiPropertyOptional() @IsString() @IsOptional() endpoint?: string;
  @ApiPropertyOptional() @IsString() @IsOptional() accessKey?: string;
  @ApiPropertyOptional() @IsString() @IsOptional() secretKey?: string;
  @ApiPropertyOptional() @IsString() @IsOptional() localFolder?: string;
}
