import { Injectable } from '@nestjs/common';
import { AppConfigRepository, StorageConfig } from '../adapters/repository/app-config.repository';

@Injectable()
export class SaveStorageConfigUseCase {
  constructor(private readonly appConfigRepository: AppConfigRepository) {}

  async execute(config: StorageConfig): Promise<void> {
    return this.appConfigRepository.saveStorageConfig(config);
  }
}
