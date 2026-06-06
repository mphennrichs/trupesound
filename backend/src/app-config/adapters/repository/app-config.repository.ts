export interface StorageConfig {
  endpoint: string;
  accessKey: string;
  secretKey: string;
  localFolder: string;
}

export abstract class AppConfigRepository {
  abstract findOrCreate(): Promise<string>;
  abstract getStorageConfig(): Promise<StorageConfig | null>;
  abstract saveStorageConfig(config: StorageConfig): Promise<void>;
}
