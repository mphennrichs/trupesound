import { HttpException, HttpStatus } from '@nestjs/common';

export class SoundFileNotFoundException extends HttpException {
  constructor() {
    super('Sound file not found', HttpStatus.NOT_FOUND);
  }
}
