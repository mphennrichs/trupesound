import { HttpStatus } from '@nestjs/common';
import { ErrorCodes } from '../../common/constants/errors';
import { TrupeHTTPException } from '../../common/exceptions/trupe-http.exception';

export class InvalidCredentialsException extends TrupeHTTPException {
  constructor() {
    super(ErrorCodes.INVALID_CREDENTIALS, HttpStatus.UNAUTHORIZED);
  }
}
