import { HttpStatus } from '@nestjs/common';
import { ErrorCodes } from '../../common/constants/errors';
import { TrupeHTTPException } from '../../common/exceptions/trupe-http.exception';

export class ActNotFoundException extends TrupeHTTPException {
  constructor() {
    super(ErrorCodes.ACT_NOT_FOUND, HttpStatus.NOT_FOUND);
  }
}
