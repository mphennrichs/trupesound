import { Injectable } from '@nestjs/common';
import { ActRepository } from '../adapters/repository/act.repository';
import { ActNotFoundException } from '../exceptions/act-not-found.exception';

@Injectable()
export class DeleteActUseCase {
  constructor(private readonly actRepository: ActRepository) {}

  async execute(id: number): Promise<void> {
    const existing = await this.actRepository.findByID(id);
    if (!existing) throw new ActNotFoundException();
    await this.actRepository.delete(id);
  }
}
