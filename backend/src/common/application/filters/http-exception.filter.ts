import { ExceptionFilter, Catch, ArgumentsHost, HttpException } from '@nestjs/common';
import { Request, Response } from 'express';
import { TrupeHTTPException } from '../../exceptions/trupe-http.exception';

@Catch(HttpException)
export class HttpExceptionFilter implements ExceptionFilter {
  catch(exception: HttpException, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();
    const status = exception.getStatus();

    const isTrupe = exception instanceof TrupeHTTPException;
    const errorCode = isTrupe ? exception.errorCode : exception.message;
    const retryable = isTrupe ? exception.retryable : false;

    response.status(status).json({
      statusCode: status,
      errorCode,
      retryable,
      timestamp: new Date().toISOString(),
      path: request.url,
    });
  }
}
