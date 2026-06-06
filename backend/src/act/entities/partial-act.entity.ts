import { ScriptLine, SoundCue } from './act.entity';

export interface PartialActProps {
  number?: number;
  name?: string;
  script?: ScriptLine[];
  cues?: SoundCue[];
}

export class PartialActEntity {
  private constructor(private readonly props: PartialActProps) {}

  static new(props: PartialActProps): PartialActEntity {
    return new PartialActEntity(props);
  }

  get number() { return this.props.number; }
  get name() { return this.props.name; }
  get script() { return this.props.script; }
  get cues() { return this.props.cues; }
}
