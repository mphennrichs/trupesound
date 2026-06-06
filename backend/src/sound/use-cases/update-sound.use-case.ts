import { Injectable, NotFoundException } from '@nestjs/common';
import { Sound } from '../entities/sound.entity';
import { SoundRepository } from '../adapters/repository/sound.repository';

export interface UpdateSoundCommand {
  name?: string;
  category?: string;
}

@Injectable()
export class UpdateSoundUseCase {
  constructor(private readonly soundRepository: SoundRepository) {}

  async execute(id: number, command: UpdateSoundCommand): Promise<Sound> {
    const existing = await this.soundRepository.findById(id);
    if (!existing) throw new NotFoundException(`Sound ${id} not found`);
    return this.soundRepository.update(id, command);
  }
}
