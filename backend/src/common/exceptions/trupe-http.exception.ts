import { HttpException } from '@nestjs/common';

export abstract class TrupeHTTPException extends HttpException {
  readonly errorCode: string;
  readonly retryable: boolean;

  constructor(errorCode: string, status: number, retryable = false) {
    super(errorCode, status);
    this.errorCode = errorCode;
    this.retryable = retryable;
  }
}
