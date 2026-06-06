import { Audit } from '../../common/entities/audit';
import { Entity } from '../../common/entities/entity';
import { ActModel } from '../adapters/repository/model/act.model';

export interface ScriptLine {
  lineNumber: number;
  text: string;
}

export interface ActProps {
  playId: number;
  number: number;
  name: string;
  script: ScriptLine[];
  audit: Audit;
}

export class ActEntity extends Entity<ActProps> {
  private constructor(props: ActProps, id?: number) {
    super(props, id);
  }

  static new(props: ActProps, id?: number): ActEntity {
    return new ActEntity(props, id);
  }

  get playId(): number { return this.props.playId; }

  get number(): number { return this.props.number; }
  set number(v: number) { this.props.number = v; }

  get name(): string { return this.props.name; }
  set name(v: string) { this.props.name = v; }

  get script(): ScriptLine[] { return this.props.script; }
  set script(v: ScriptLine[]) { this.props.script = v; }

  get audit(): Audit { return this.props.audit; }

  static fromModel(model: ActModel): ActEntity {
    return ActEntity.new(
      {
        playId: model.playId,
        number: model.number,
        name: model.name,
        script: (model.script as unknown as ScriptLine[]) ?? [],
        audit: Audit.new({
          createdAt: model.createdAt,
          createdBy: model.createdBy,
          lastUpdatedAt: model.lastUpdatedAt,
          lastUpdatedBy: model.lastUpdatedBy,
        }),
      },
      model.id,
    );
  }
}
