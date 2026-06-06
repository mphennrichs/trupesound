import {
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  BadRequestException,
  Logger,
} from '@nestjs/common';
import { Response, Request } from 'express';

@Catch(BadRequestException)
export class ValidationExceptionFilter implements ExceptionFilter {
  private readonly logger = new Logger('ValidationFilter');

  catch(exception: BadRequestException, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();
    const exceptionResponse: any = exception.getResponse();

    this.logger.error(`Validation failed for ${request.method} ${request.url}`);
    this.logger.error(`Detail: ${JSON.stringify(exceptionResponse.message, null, 2)}`);

    response.status(400).json(exceptionResponse);
  }
}
