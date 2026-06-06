import { Injectable } from '@nestjs/common';
import { Sound } from '../entities/sound.entity';
import { SoundRepository } from '../adapters/repository/sound.repository';

@Injectable()
export class ListSoundsUseCase {
  constructor(private readonly soundRepository: SoundRepository) {}

  async execute(): Promise<Sound[]> {
    return this.soundRepository.list();
  }
}
