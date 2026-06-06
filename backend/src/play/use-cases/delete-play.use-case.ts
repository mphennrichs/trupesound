import { Injectable } from '@nestjs/common';
import { PlayRepository } from '../adapters/repository/play.repository';
import { PlayNotFoundException } from '../exceptions/play-not-found.exception';

@Injectable()
export class DeletePlayUseCase {
  constructor(private readonly playRepository: PlayRepository) {}

  async execute(id: number): Promise<void> {
    const existing = await this.playRepository.findByID(id);
    if (!existing) throw new PlayNotFoundException();
    await this.playRepository.softDelete(id);
  }
}
