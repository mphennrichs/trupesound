import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { PrismaService } from '../common/application/service/prisma-client.service';
import { AuthController } from './adapters/controller/v1/auth.controller';
import { UserPrismaRepository } from './adapters/repository/user-prisma.repository';
import { UserRepository } from './adapters/repository/user.repository';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { LoginUseCase } from './use-cases/login.use-case';
import { RegisterUseCase } from './use-cases/register.use-case';

@Module({
  imports: [
    JwtModule.register({
      secret: process.env.JWT_SECRET,
      signOptions: { expiresIn: '30d' },
    }),
  ],
  providers: [
    PrismaService,
    RegisterUseCase,
    LoginUseCase,
    JwtAuthGuard,
    {
      provide: UserRepository,
      useClass: UserPrismaRepository,
    },
  ],
  controllers: [AuthController],
  exports: [JwtModule, JwtAuthGuard],
})
export class AuthModule {}
