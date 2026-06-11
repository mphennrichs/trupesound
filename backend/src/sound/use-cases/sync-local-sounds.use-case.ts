import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import { readdirSync, statSync, existsSync } from 'fs';
import { join, extname, basename } from 'path';
import { parseFile } from 'music-metadata';
import { AppConfigRepository } from '../../app-config/adapters/repository/app-config.repository';
import { SoundRepository } from '../adapters/repository/sound.repository';

const SUPPORTED_EXTENSIONS = new Set(['.mp3', '.wav', '.ogg', '.aiff', '.aif', '.flac']);

@Injectable()
export class SyncLocalSoundsUseCase implements OnModuleInit {
  private readonly logger = new Logger(SyncLocalSoundsUseCase.name);

  constructor(
    private readonly appConfigRepository: AppConfigRepository,
    private readonly soundRepository: SoundRepository,
  ) {}

  async onModuleInit() {
    await this.execute();
  }

  async execute(): Promise<void> {
    const config = await this.appConfigRepository.getStorageConfig();
    if (!config?.localFolder) return;
    if (!existsSync(config.localFolder)) return;

    const appUrl = process.env.APP_URL ?? 'http://localhost:3000';
    const files = this.collectAudioFiles(config.localFolder);

    let synced = 0;
    let updated = 0;

    for (const filePath of files) {
      const fileName = basename(filePath);
      const url = `${appUrl}/api/v1/sounds/file/${encodeURIComponent(fileName)}`;
      const durationMs = await this.readDurationMs(filePath);

      const existing = await this.soundRepository.findByUrl(url);
      if (existing) {
        if (existing.durationMs === 0 && durationMs > 0) {
          await this.soundRepository.updateDuration(existing.id, durationMs);
          updated++;
        }
        continue;
      }

      const name = basename(fileName, extname(fileName));
      await this.soundRepository.create({ name, category: 'effect', durationMs, url });
      synced++;
    }

    if (synced > 0) this.logger.log(`Synced ${synced} new local sound(s) from ${config.localFolder}`);
    if (updated > 0) this.logger.log(`Updated duration for ${updated} existing sound(s)`);
  }

  private collectAudioFiles(dir: string): string[] {
    const results: string[] = [];
    for (const entry of readdirSync(dir)) {
      const fullPath = join(dir, entry);
      try {
        const stat = statSync(fullPath);
        if (stat.isDirectory()) {
          results.push(...this.collectAudioFiles(fullPath));
        } else if (SUPPORTED_EXTENSIONS.has(extname(entry).toLowerCase())) {
          results.push(fullPath);
        }
      } catch {
        // skip unreadable entries
      }
    }
    return results;
  }

  private async readDurationMs(filePath: string): Promise<number> {
    try {
      const metadata = await parseFile(filePath, { duration: true });
      const seconds = metadata.format.duration ?? 0;
      return Math.round(seconds * 1000);
    } catch {
      return 0;
    }
  }
}
