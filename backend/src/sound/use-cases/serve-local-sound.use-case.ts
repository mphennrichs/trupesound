import { Injectable } from '@nestjs/common';
import { createReadStream, existsSync, statSync } from 'fs';
import { join, extname } from 'path';
import { ReadStream } from 'fs';
import { AppConfigRepository } from '../../app-config/adapters/repository/app-config.repository';
import { StorageNotConfiguredException } from '../../app-config/exceptions/storage-not-configured.exception';
import { SoundFileNotFoundException } from '../exceptions/sound-file-not-found.exception';

const MIME_TYPES: Record<string, string> = {
  '.mp3': 'audio/mpeg',
  '.wav': 'audio/wav',
  '.ogg': 'audio/ogg',
  '.aiff': 'audio/aiff',
  '.aif': 'audio/aiff',
  '.flac': 'audio/flac',
};

export interface ServeResult {
  stream: ReadStream;
  mimeType: string;
  size: number;
}

@Injectable()
export class ServeLocalSoundUseCase {
  constructor(private readonly appConfigRepository: AppConfigRepository) {}

  async execute(fileName: string): Promise<ServeResult> {
    const config = await this.appConfigRepository.getStorageConfig();
    if (!config?.localFolder) throw new StorageNotConfiguredException();

    const filePath = join(config.localFolder, fileName);
    if (!existsSync(filePath)) throw new SoundFileNotFoundException();

    const ext = extname(fileName).toLowerCase();
    const mimeType = MIME_TYPES[ext] ?? 'application/octet-stream';
    const size = statSync(filePath).size;

    return { stream: createReadStream(filePath), mimeType, size };
  }
}
