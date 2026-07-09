import { HttpStatus } from '@nestjs/common';
import { ErrorCodes } from '../../common/constants/errors';
import { TrupeHTTPException } from '../../common/exceptions/trupe-http.exception';

export class EmailAlreadyRegisteredException extends TrupeHTTPException {
  constructor() {
    super(ErrorCodes.EMAIL_ALREADY_REGISTERED, HttpStatus.CONFLICT);
  }
}
