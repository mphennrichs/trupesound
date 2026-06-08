import { ExceptionFilter, Catch, ArgumentsHost, HttpException, Logger } from '@nestjs/common';
import { Request, Response } from 'express';
import { TrupeHTTPException } from '../../exceptions/trupe-http.exception';

@Catch(HttpException)
export class HttpExceptionFilter implements ExceptionFilter {
  private readonly logger = new Logger('HttpException');

  catch(exception: HttpException, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();
    const status = exception.getStatus();

    const isTrupe = exception instanceof TrupeHTTPException;
    const errorCode = isTrupe ? exception.errorCode : exception.message;
    const retryable = isTrupe ? exception.retryable : false;

    if (status >= 500) {
      this.logger.error(`${request.method} ${request.url} → ${status} ${errorCode}`, exception.stack);
    } else {
      this.logger.warn(`${request.method} ${request.url} → ${status} ${errorCode}`);
    }

    response.status(status).json({
      statusCode: status,
      errorCode,
      retryable,
      timestamp: new Date().toISOString(),
      path: request.url,
    });
  }
}
