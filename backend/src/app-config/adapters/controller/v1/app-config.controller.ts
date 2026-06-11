import { Body, Controller, Get, HttpCode, HttpStatus, Post } from '@nestjs/common';
import { ApiBody, ApiResponse, ApiTags } from '@nestjs/swagger';
import { GenerateUploadUrlUseCase } from '../../../use-cases/generate-upload-url.use-case';
import { GetStorageConfigUseCase } from '../../../use-cases/get-storage-config.use-case';
import { InitAppUseCase } from '../../../use-cases/init-app.use-case';
import { PresignUploadRequestDto } from './dto/request/presign-upload-request.dto';
import { AppConfigResponseDto } from './dto/response/app-config-response.dto';
import { PresignUploadResponseDto } from './dto/response/presign-upload-response.dto';
import { StorageModeResponseDto } from './dto/response/storage-mode-response.dto';

@ApiTags('app')
@Controller('v1/app')
export class AppConfigController {
  constructor(
    private readonly initApp: InitAppUseCase,
    private readonly getStorageConfig: GetStorageConfigUseCase,
    private readonly generateUploadUrl: GenerateUploadUrlUseCase,
  ) {}

  @Post('init')
  @HttpCode(HttpStatus.OK)
  @ApiResponse({ status: 200, type: AppConfigResponseDto })
  async init(): Promise<AppConfigResponseDto> {
    const appId = await this.initApp.execute();
    return { appId };
  }

  @Get('storage-mode')
  @ApiResponse({ status: 200, type: StorageModeResponseDto })
  async storageMode(): Promise<StorageModeResponseDto> {
    const config = await this.getStorageConfig.execute();
    if (!config) return { mode: 'unknown' };
    if (config.localFolder) return { mode: 'local' };
    return { mode: 'cloud' };
  }

  @Post('storage/presign')
  @ApiBody({ type: PresignUploadRequestDto })
  @ApiResponse({ status: 201, type: PresignUploadResponseDto })
  @ApiResponse({ status: 409, description: 'Storage not configured' })
  async presignUpload(@Body() body: PresignUploadRequestDto): Promise<PresignUploadResponseDto> {
    return this.generateUploadUrl.execute(body.fileName);
  }
}
