import { Injectable } from '@nestjs/common';
import { Sound } from '../entities/sound.entity';
import { SoundRepository } from '../adapters/repository/sound.repository';

export interface CreateSoundCommand {
  name: string;
  category: string;
  durationMs: number;
  url: string;
}

@Injectable()
export class CreateSoundUseCase {
  constructor(private readonly soundRepository: SoundRepository) {}

  async execute(command: CreateSoundCommand): Promise<Sound> {
    return this.soundRepository.create(command);
  }
}
