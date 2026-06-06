import { PlayEntity } from './play.entity';

interface FilterPlayResultProps {
  total: number;
  data: PlayEntity[];
}

export class FilterPlayResultEntity {
  private constructor(private readonly props: FilterPlayResultProps) {}

  static new(props: FilterPlayResultProps): FilterPlayResultEntity {
    return new FilterPlayResultEntity(props);
  }

  get total() { return this.props.total; }
  get data() { return this.props.data; }
}
