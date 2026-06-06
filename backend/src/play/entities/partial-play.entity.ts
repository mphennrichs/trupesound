import { PlayStatusEnum } from './play.entity';

export interface PartialPlayProps {
  title?: string;
  author?: string;
  status?: PlayStatusEnum;
  icon?: number | null;
  backgroundColor?: string | null;
}

export class PartialPlayEntity {
  private constructor(private readonly props: PartialPlayProps) {}

  static new(props: PartialPlayProps): PartialPlayEntity {
    return new PartialPlayEntity(props);
  }

  get title() { return this.props.title; }
  get author() { return this.props.author; }
  get status() { return this.props.status; }
  get icon() { return this.props.icon; }
  get backgroundColor() { return this.props.backgroundColor; }
}
