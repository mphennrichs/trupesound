import { HttpStatus } from '@nestjs/common';
import { ErrorCodes } from '../constants/errors';
import { TrupeHTTPException } from './trupe-http.exception';

export class UnauthorizedException extends TrupeHTTPException {
  constructor() {
    super(ErrorCodes.UNAUTHORIZED, HttpStatus.UNAUTHORIZED);
  }
}
