import { Controller, HttpCode, HttpStatus, Post } from '@nestjs/common';
import { ApiResponse, ApiTags } from '@nestjs/swagger';
import { InitAppUseCase } from '../../../use-cases/init-app.use-case';
import { AppConfigResponseDto } from './dto/response/app-config-response.dto';

@ApiTags('app')
@Controller('v1/app')
export class AppConfigController {
  constructor(private readonly initApp: InitAppUseCase) {}

  @Post('init')
  @HttpCode(HttpStatus.OK)
  @ApiResponse({ status: 200, type: AppConfigResponseDto })
  async init(): Promise<AppConfigResponseDto> {
    const appId = await this.initApp.execute();
    return { appId };
  }
}
