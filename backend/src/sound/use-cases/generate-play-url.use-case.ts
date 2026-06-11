import { Injectable } from '@nestjs/common';
import { Client } from 'minio';
import { AppConfigRepository } from '../../app-config/adapters/repository/app-config.repository';

const PRESIGN_EXPIRY_SECONDS = 60 * 60; // 1 hour

@Injectable()
export class GeneratePlayUrlUseCase {
  constructor(private readonly appConfigRepository: AppConfigRepository) {}

  async execute(soundUrl: string): Promise<string> {
    const config = await this.appConfigRepository.getStorageConfig();

    if (!config?.endpoint) {
      // Local mode — URL is already a direct backend serve URL, return as-is.
      return soundUrl;
    }

    const url = new URL(config.endpoint.startsWith('http') ? config.endpoint : `https://${config.endpoint}`);
    const useSSL = url.protocol === 'https:';
    const port = url.port ? parseInt(url.port) : useSSL ? 443 : 80;

    const client = new Client({
      endPoint: url.hostname,
      port,
      accessKey: config.accessKey,
      secretKey: config.secretKey,
      useSSL,
      pathStyle: true,
    });

    // soundUrl is https://host/bucket/sounds/file.mp3 — extract bucket and object.
    const soundUrlParsed = new URL(soundUrl);
    const [, bucket, ...objectParts] = soundUrlParsed.pathname.split('/');
    const objectName = objectParts.join('/');

    return client.presignedGetObject(bucket, objectName, PRESIGN_EXPIRY_SECONDS);
  }
}
