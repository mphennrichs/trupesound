export interface FilterActProps {
  playId?: number;
}

export class FilterActEntity {
  private constructor(private readonly props: FilterActProps) {}

  static new(props: FilterActProps): FilterActEntity {
    return new FilterActEntity(props);
  }

  get playId() { return this.props.playId; }
}
