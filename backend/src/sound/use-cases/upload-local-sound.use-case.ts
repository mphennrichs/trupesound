import { Injectable, Logger } from '@nestjs/common';
import { createWriteStream, mkdirSync } from 'fs';
import { join } from 'path';
import { Readable } from 'stream';
import { AppConfigRepository } from '../../app-config/adapters/repository/app-config.repository';
import { StorageNotConfiguredException } from '../../app-config/exceptions/storage-not-configured.exception';

@Injectable()
export class UploadLocalSoundUseCase {
  private readonly logger = new Logger(UploadLocalSoundUseCase.name);

  constructor(private readonly appConfigRepository: AppConfigRepository) {}

  async execute(fileName: string, stream: Readable): Promise<void> {
    this.logger.log(`Starting upload for file: ${fileName}`);

    const config = await this.appConfigRepository.getStorageConfig();
    this.logger.log(`Storage config: localFolder=${config?.localFolder}, hasEndpoint=${!!config?.endpoint}`);

    if (!config?.localFolder) throw new StorageNotConfiguredException();

    const destPath = join(config.localFolder, fileName);
    this.logger.log(`Writing to: ${destPath}`);
    this.logger.log(`Stream readable: ${stream.readable}, destroyed: ${stream.destroyed}`);

    mkdirSync(config.localFolder, { recursive: true });

    await new Promise<void>((resolve, reject) => {
      const dest = createWriteStream(destPath);
      let bytesWritten = 0;

      stream.on('data', (chunk) => { bytesWritten += chunk.length; });
      dest.on('finish', () => {
        this.logger.log(`Upload complete: ${bytesWritten} bytes written to ${destPath}`);
        resolve();
      });
      dest.on('error', (err) => {
        this.logger.error(`Write error: ${err.message}`);
        reject(err);
      });
      stream.on('error', (err) => {
        this.logger.error(`Stream error: ${err.message}`);
        reject(err);
      });

      stream.pipe(dest);
    });
  }
}
