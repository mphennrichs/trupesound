import { Controller, Get, Module } from '@nestjs/common';
import { APP_GUARD } from '@nestjs/core';
import { ActModule } from './act/act.module';
import { AppConfigModule } from './app-config/app-config.module';
import { AuthModule } from './auth/auth.module';
import { Public } from './auth/decorators/public.decorator';
import { JwtAuthGuard } from './auth/guards/jwt-auth.guard';
import { PlayModule } from './play/play.module';
import { SoundModule } from './sound/sound.module';

@Controller()
class PingController {
  @Public()
  @Get('ping')
  ping() {
    return { status: 'ok' };
  }
}

@Module({
  imports: [PlayModule, ActModule, AppConfigModule, SoundModule, AuthModule],
  controllers: [PingController],
  providers: [{ provide: APP_GUARD, useClass: JwtAuthGuard }],
})
export class AppModule {}
