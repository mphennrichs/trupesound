import { Injectable, NotFoundException } from '@nestjs/common';
import { SoundRepository } from '../adapters/repository/sound.repository';

@Injectable()
export class ArchiveSoundUseCase {
  constructor(private readonly soundRepository: SoundRepository) {}

  async execute(id: number): Promise<void> {
    const existing = await this.soundRepository.findById(id);
    if (!existing) throw new NotFoundException(`Sound ${id} not found`);
    return this.soundRepository.archive(id);
  }
}
