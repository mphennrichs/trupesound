import { Body, Controller, Get, HttpCode, HttpStatus, Post, Put } from '@nestjs/common';
import { ApiBody, ApiResponse, ApiTags } from '@nestjs/swagger';
import { GenerateUploadUrlUseCase } from '../../../use-cases/generate-upload-url.use-case';
import { GetStorageConfigUseCase } from '../../../use-cases/get-storage-config.use-case';
import { InitAppUseCase } from '../../../use-cases/init-app.use-case';
import { SaveStorageConfigUseCase } from '../../../use-cases/save-storage-config.use-case';
import { PresignUploadRequestDto } from './dto/request/presign-upload-request.dto';
import { StorageConfigRequestDto } from './dto/request/storage-config-request.dto';
import { AppConfigResponseDto } from './dto/response/app-config-response.dto';
import { PresignUploadResponseDto } from './dto/response/presign-upload-response.dto';
import { StorageConfigResponseDto } from './dto/response/storage-config-response.dto';

@ApiTags('app')
@Controller('v1/app')
export class AppConfigController {
  constructor(
    private readonly initApp: InitAppUseCase,
    private readonly getStorageConfig: GetStorageConfigUseCase,
    private readonly saveStorageConfig: SaveStorageConfigUseCase,
    private readonly generateUploadUrl: GenerateUploadUrlUseCase,
  ) {}

  @Post('init')
  @HttpCode(HttpStatus.OK)
  @ApiResponse({ status: 200, type: AppConfigResponseDto })
  async init(): Promise<AppConfigResponseDto> {
    const appId = await this.initApp.execute();
    return { appId };
  }

  @Get('storage-config')
  @ApiResponse({ status: 200, type: StorageConfigResponseDto })
  @ApiResponse({ status: 204 })
  async getStorage(): Promise<StorageConfigResponseDto | null> {
    const config = await this.getStorageConfig.execute();
    if (!config) return null;
    return { endpoint: config.endpoint, accessKey: config.accessKey, localFolder: config.localFolder };
  }

  @Put('storage-config')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiBody({ type: StorageConfigRequestDto })
  @ApiResponse({ status: 204 })
  async saveStorage(@Body() body: StorageConfigRequestDto): Promise<void> {
    await this.saveStorageConfig.execute({
      endpoint: body.endpoint ?? '',
      accessKey: body.accessKey ?? '',
      secretKey: body.secretKey ?? '',
      localFolder: body.localFolder ?? '',
    });
  }

  @Post('storage/presign')
  @ApiBody({ type: PresignUploadRequestDto })
  @ApiResponse({ status: 201, type: PresignUploadResponseDto })
  @ApiResponse({ status: 409, description: 'Storage not configured' })
  async presignUpload(@Body() body: PresignUploadRequestDto): Promise<PresignUploadResponseDto> {
    return this.generateUploadUrl.execute(body.fileName);
  }
}
