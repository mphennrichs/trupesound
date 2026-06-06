import { ActEntity } from '../../../entities/act.entity';

export class ActModel {
  id: number;
  playId: number;
  number: number;
  name: string;
  script: unknown; // Json — cast to ScriptLine[] in the entity layer
  cues: unknown;   // Json — cast to SoundCue[] in the entity layer
  createdAt: Date;
  createdBy: number | null;
  lastUpdatedAt: Date | null;
  lastUpdatedBy: number | null;

  static fromDomain(entity: ActEntity): ActModel {
    return {
      id: entity.id,
      playId: entity.playId,
      number: entity.number,
      name: entity.name,
      script: entity.script,
      cues: entity.cues,
      createdAt: entity.audit.createdAt,
      createdBy: entity.audit.createdBy,
      lastUpdatedAt: entity.audit.lastUpdatedAt,
      lastUpdatedBy: entity.audit.lastUpdatedBy,
    };
  }
}
