import { Injectable } from '@nestjs/common';
import { AppConfigRepository, StorageConfig } from '../adapters/repository/app-config.repository';

@Injectable()
export class GetStorageConfigUseCase {
  constructor(private readonly appConfigRepository: AppConfigRepository) {}

  async execute(): Promise<StorageConfig | null> {
    return this.appConfigRepository.getStorageConfig();
  }
}
