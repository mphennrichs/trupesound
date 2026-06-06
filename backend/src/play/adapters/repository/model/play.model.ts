import { PlayEntity } from '../../../entities/play.entity';

export interface ActSummaryModel {
  id: number;
  number: number;
  name: string;
}

export class PlayModel {
  id: number;
  title: string;
  author: string;
  status: string;
  active: boolean;
  icon: number | null;
  backgroundColor: string | null;
  acts?: ActSummaryModel[];
  createdAt: Date;
  createdBy: number | null;
  lastUpdatedAt: Date | null;
  lastUpdatedBy: number | null;

  static fromDomain(entity: PlayEntity): PlayModel {
    return {
      id: entity.id,
      title: entity.title,
      author: entity.author,
      status: entity.status,
      active: true,
      icon: entity.icon ?? null,
      backgroundColor: entity.backgroundColor ?? null,
      createdAt: entity.audit.createdAt,
      createdBy: entity.audit.createdBy,
      lastUpdatedAt: entity.audit.lastUpdatedAt,
      lastUpdatedBy: entity.audit.lastUpdatedBy,
    };
  }
}
