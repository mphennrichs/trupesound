import { Injectable } from '@nestjs/common';
import { Client } from 'minio';
import { AppConfigRepository } from '../adapters/repository/app-config.repository';
import { StorageNotConfiguredException } from '../exceptions/storage-not-configured.exception';

const SOUNDS_PREFIX = 'sounds';
const PRESIGN_EXPIRY_SECONDS = 60 * 15;

export interface UploadUrlResult {
  uploadUrl: string;
  objectUrl: string;
}

@Injectable()
export class GenerateUploadUrlUseCase {
  constructor(private readonly appConfigRepository: AppConfigRepository) {}

  async execute(fileName: string): Promise<UploadUrlResult> {
    const config = await this.appConfigRepository.getStorageConfig();
    if (!config) throw new StorageNotConfiguredException();

    if (config.localFolder) {
      return this.localUrls(fileName);
    }

    return this.presignedUrls(fileName, config);
  }

  private localUrls(fileName: string): UploadUrlResult {
    const appUrl = process.env.APP_URL ?? 'http://localhost:3000';
    return {
      uploadUrl: `${appUrl}/api/v1/sounds/upload/${encodeURIComponent(fileName)}`,
      objectUrl: `${appUrl}/api/v1/sounds/file/${encodeURIComponent(fileName)}`,
    };
  }

  private async presignedUrls(
    fileName: string,
    config: { endpoint: string; accessKey: string; secretKey: string },
  ): Promise<UploadUrlResult> {
    const appId = await this.appConfigRepository.findOrCreate();

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

    const bucketExists = await client.bucketExists(appId);
    if (!bucketExists) {
      await client.makeBucket(appId);
    }

    const objectName = `${SOUNDS_PREFIX}/${fileName}`;
    const uploadUrl = await client.presignedPutObject(appId, objectName, PRESIGN_EXPIRY_SECONDS);
    const objectUrl = `${url.origin}/${appId}/${objectName}`;

    return { uploadUrl, objectUrl };
  }
}
