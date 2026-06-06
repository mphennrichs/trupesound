import { ActEntity } from './act.entity';

interface FilterActResultProps {
  total: number;
  data: ActEntity[];
}

export class FilterActResultEntity {
  private constructor(private readonly props: FilterActResultProps) {}

  static new(props: FilterActResultProps): FilterActResultEntity {
    return new FilterActResultEntity(props);
  }

  get total() { return this.props.total; }
  get data() { return this.props.data; }
}
