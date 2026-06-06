import { ValueObject } from './value-object';

export interface AuditProps {
  createdAt: Date;
  createdBy: number | null;
  lastUpdatedAt?: Date | null;
  lastUpdatedBy?: number | null;
}

export class Audit extends ValueObject<AuditProps> {
  private constructor(props: AuditProps) {
    super(props);
  }

  static new(props: AuditProps): Audit {
    return new Audit(props);
  }

  get createdAt(): Date {
    return this.props.createdAt;
  }

  get createdBy(): number | null {
    return this.props.createdBy;
  }

  get lastUpdatedAt(): Date | null {
    return this.props.lastUpdatedAt;
  }

  get lastUpdatedBy(): number | null {
    return this.props.lastUpdatedBy;
  }
}
