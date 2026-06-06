export interface FilterPlayProps {
  title?: string;
  author?: string;
}

export class FilterPlayEntity {
  private constructor(private readonly props: FilterPlayProps) {}

  static new(props: FilterPlayProps): FilterPlayEntity {
    return new FilterPlayEntity(props);
  }

  get title() { return this.props.title; }
  get author() { return this.props.author; }
}
