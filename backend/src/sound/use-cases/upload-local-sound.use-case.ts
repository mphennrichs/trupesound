import { Injectable } from '@nestjs/common';
import { createWriteStream, mkdirSync } from 'fs';
import { join } from 'path';
import { Readable } from 'stream';
import { AppConfigRepository } from '../../app-config/adapters/repository/app-config.repository';
import { StorageNotConfiguredException } from '../../app-config/exceptions/storage-not-configured.exception';

@Injectable()
export class UploadLocalSoundUseCase {
  constructor(private readonly appConfigRepository: AppConfigRepository) {}

  async execute(fileName: string, stream: Readable): Promise<void> {
    const config = await this.appConfigRepository.getStorageConfig();
    if (!config?.localFolder) throw new StorageNotConfiguredException();

    const destPath = join(config.localFolder, fileName);
    mkdirSync(config.localFolder, { recursive: true });

    await new Promise<void>((resolve, reject) => {
      const dest = createWriteStream(destPath);
      dest.on('finish', resolve);
      dest.on('error', reject);
      stream.on('error', reject);
      stream.pipe(dest);
    });
  }
}
