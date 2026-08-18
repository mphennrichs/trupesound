import 'dotenv/config';
import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { json, urlencoded } from 'express';
import { AppModule } from './app.module';
import { HttpExceptionFilter } from './common/application/filters/http-exception.filter';
import { ValidationExceptionFilter } from './common/application/filters/validation-exception.filter';
import { HttpLoggingInterceptor } from './common/observability/http-logging.interceptor';
import { JsonLogger } from './common/observability/json-logger';

async function bootstrap() {
  if (!process.env.JWT_SECRET) {
    throw new Error('JWT_SECRET environment variable is required');
  }

  const app = await NestFactory.create(AppModule, {
    // JSON em vez do console colorido do Nest: os codigos ANSI viravam lixo no
    // Loki e a linha inteira era uma string opaca, sem campos para filtrar.
    logger: new JsonLogger(),
    bodyParser: false,
  });
  app.enableCors();

  // Re-enable body-parser for all routes except raw binary uploads.
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  app.use((req: any, res: any, next: any) => {
    if (req.path.startsWith('/v1/sounds/upload/')) return next();
    json()(req, res, (err: unknown) => {
      if (err) return next(err);
      urlencoded({ extended: true })(req, res, next);
    });
  });
  app.useGlobalPipes(new ValidationPipe({ transform: true, whitelist: true }));
  app.useGlobalFilters(new HttpExceptionFilter(), new ValidationExceptionFilter());
  app.useGlobalInterceptors(new HttpLoggingInterceptor());
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

  // Linha única e estruturada em vez do banner de 5 linhas: é ela que marca o
  // deploy no Grafana. `version` só aparece aqui quando o processo NOVO de fato
  // começou a servir — um deploy que morre no boot nunca produz esta linha, e é
  // essa ausência que o alerta de deploy incompleto detecta.
  // Escrita direta (não pelo Logger do Nest, que só aceita string e aninharia
  // este objeto dentro do campo `msg` — ver o fix em http-logging.interceptor).
  process.stdout.write(
    `${JSON.stringify({
      time: new Date().toISOString(),
      level: 'INFO',
      msg: 'service started',
      context: 'Bootstrap',
      event: 'service_started',
      version: process.env.APP_VERSION ?? 'dev',
      commit: process.env.APP_COMMIT ?? 'unknown',
      port,
    })}\n`,
  );
}
bootstrap();
