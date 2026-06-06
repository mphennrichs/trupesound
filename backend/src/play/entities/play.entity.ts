import { Audit } from '../../common/entities/audit';
import { Entity } from '../../common/entities/entity';
import { PlayModel } from '../adapters/repository/model/play.model';

export enum PlayStatusEnum {
  ACTIVE = 'active',
  INACTIVE = 'inactive',
}

export interface ActSummary {
  id: number;
  number: number;
  name: string;
}

export interface PlayProps {
  title: string;
  author: string;
  status: PlayStatusEnum;
  audit: Audit;
  acts?: ActSummary[];
  icon?: number | null;
  backgroundColor?: string | null;
}

export class PlayEntity extends Entity<PlayProps> {
  private constructor(props: PlayProps, id?: number) {
    super(props, id);
  }

  static new(props: PlayProps, id?: number): PlayEntity {
    return new PlayEntity(props, id);
  }

  get title(): string { return this.props.title; }
  set title(v: string) { this.props.title = v; }

  get author(): string { return this.props.author; }
  set author(v: string) { this.props.author = v; }

  get status(): PlayStatusEnum { return this.props.status; }
  set status(v: PlayStatusEnum) { this.props.status = v; }

  get audit(): Audit { return this.props.audit; }

  get acts(): ActSummary[] | undefined { return this.props.acts; }

  get icon(): number | null | undefined { return this.props.icon; }
  get backgroundColor(): string | null | undefined { return this.props.backgroundColor; }

  static fromModel(model: PlayModel): PlayEntity {
    return PlayEntity.new(
      {
        title: model.title,
        author: model.author,
        status: model.status as PlayStatusEnum,
        audit: Audit.new({
          createdAt: model.createdAt,
          createdBy: model.createdBy,
          lastUpdatedAt: model.lastUpdatedAt,
          lastUpdatedBy: model.lastUpdatedBy,
        }),
        acts: model.acts?.map((a) => ({ id: a.id, number: a.number, name: a.name })),
        icon: model.icon,
        backgroundColor: model.backgroundColor,
      },
      model.id,
    );
  }
}
