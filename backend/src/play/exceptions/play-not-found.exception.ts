import { HttpStatus } from '@nestjs/common';
import { ErrorCodes } from '../../common/constants/errors';
import { TrupeHTTPException } from '../../common/exceptions/trupe-http.exception';

export class PlayNotFoundException extends TrupeHTTPException {
  constructor() {
    super(ErrorCodes.PLAY_NOT_FOUND, HttpStatus.NOT_FOUND);
  }
}
