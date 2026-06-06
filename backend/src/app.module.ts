import { Controller, Get, Module } from '@nestjs/common';
import { ActModule } from './act/act.module';
import { AppConfigModule } from './app-config/app-config.module';
import { PlayModule } from './play/play.module';

@Controller()
class PingController {
  @Get('ping')
  ping() {
    return { status: 'ok' };
  }
}

@Module({
  imports: [PlayModule, ActModule, AppConfigModule],
  controllers: [PingController],
})
export class AppModule {}
