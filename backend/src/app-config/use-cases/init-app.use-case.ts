import { Injectable } from '@nestjs/common';
import { AppConfigRepository } from '../adapters/repository/app-config.repository';

@Injectable()
export class InitAppUseCase {
  constructor(private readonly appConfigRepository: AppConfigRepository) {}

  async execute(): Promise<string> {
    return this.appConfigRepository.findOrCreate();
  }
}
