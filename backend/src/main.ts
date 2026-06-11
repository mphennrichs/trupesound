import 'dotenv/config';
import { NestFactory } from '@nestjs/core';
import { Logger, ValidationPipe } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { AppModule } from './app.module';
import { HttpExceptionFilter } from './common/application/filters/http-exception.filter';
import { ValidationExceptionFilter } from './common/application/filters/validation-exception.filter';
import { LoggingInterceptor } from './common/application/interceptors/logging.interceptor';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, {
    logger: ['error', 'warn', 'log', 'debug'],
  });
  app.enableCors();
  app.useGlobalPipes(new ValidationPipe({ transform: true, whitelist: true }));
  app.useGlobalFilters(new HttpExceptionFilter(), new ValidationExceptionFilter());
  app.useGlobalInterceptors(new LoggingInterceptor());
  app.setGlobalPrefix('/api');

  const config = new DocumentBuilder()
    .setTitle('TrupeSound API')
    .setDescription('TrupeSound Backend API')
    .setVersion('1.0')
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document);

  const port = 3000;
  await app.listen(port);

  const logger = new Logger('Bootstrap');
  logger.log('----------------------------------------------');
  logger.log(' TrupeSound API is up and running');
  logger.log(` API:     http://localhost:${port}/api/v1`);
  logger.log(` Swagger: http://localhost:${port}/api`);
  logger.log('----------------------------------------------');
}
bootstrap();
