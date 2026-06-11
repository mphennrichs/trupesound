import { Sound } from '../../entities/sound.entity';

export interface CreateSoundInput {
  name: string;
  category: string;
  durationMs: number;
  url: string;
}

export interface UpdateSoundInput {
  name?: string;
  category?: string;
}

export abstract class SoundRepository {
  abstract list(): Promise<Sound[]>;
  abstract findById(id: number): Promise<Sound | null>;
  abstract findByUrl(url: string): Promise<Sound | null>;
  abstract create(input: CreateSoundInput): Promise<Sound>;
  abstract update(id: number, input: UpdateSoundInput): Promise<Sound>;
  abstract updateDuration(id: number, durationMs: number): Promise<void>;
  abstract archive(id: number): Promise<void>;
}
