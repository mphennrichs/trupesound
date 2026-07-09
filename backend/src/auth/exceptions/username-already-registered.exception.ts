import { HttpStatus } from '@nestjs/common';
import { ErrorCodes } from '../../common/constants/errors';
import { TrupeHTTPException } from '../../common/exceptions/trupe-http.exception';

export class UsernameAlreadyRegisteredException extends TrupeHTTPException {
  constructor() {
    super(ErrorCodes.USERNAME_ALREADY_REGISTERED, HttpStatus.CONFLICT);
  }
}
