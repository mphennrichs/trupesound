import { HttpStatus } from '@nestjs/common';
import { ErrorCodes } from '../constants/errors';
import { TrupeHTTPException } from './trupe-http.exception';

export class InvalidIDException extends TrupeHTTPException {
  constructor() {
    super(ErrorCodes.INVALID_ID, HttpStatus.BAD_REQUEST);
  }
}
