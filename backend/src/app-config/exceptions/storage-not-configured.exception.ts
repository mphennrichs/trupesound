import { HttpException, HttpStatus } from '@nestjs/common';

export class StorageNotConfiguredException extends HttpException {
  constructor() {
    super('Storage is not configured', HttpStatus.CONFLICT);
  }
}
