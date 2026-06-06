export interface SoundProps {
  id: number;
  name: string;
  category: string;
  durationMs: number;
  url: string;
  archived: boolean;
  createdAt: Date;
}

export class Sound {
  private props: SoundProps;

  constructor(props: SoundProps) {
    this.props = props;
  }

  get id() { return this.props.id; }
  get name() { return this.props.name; }
  get category() { return this.props.category; }
  get durationMs() { return this.props.durationMs; }
  get url() { return this.props.url; }
  get archived() { return this.props.archived; }
  get createdAt() { return this.props.createdAt; }
}
