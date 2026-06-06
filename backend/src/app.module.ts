import { Controller, Get, Module } from '@nestjs/common';
import { ActModule } from './act/act.module';
import { AppConfigModule } from './app-config/app-config.module';
import { PlayModule } from './play/play.module';
import { SoundModule } from './sound/sound.module';

@Controller()
class PingController {
  @Get('ping')
  ping() {
    return { status: 'ok' };
  }
}

@Module({
  imports: [PlayModule, ActModule, AppConfigModule, SoundModule],
  controllers: [PingController],
})
export class AppModule {}
