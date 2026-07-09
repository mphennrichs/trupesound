import { Audit } from '../../common/entities/audit';
import { Entity } from '../../common/entities/entity';
import { UserModel } from '../adapters/repository/model/user.model';

export interface UserProps {
  name: string;
  email: string;
  password: string;
  audit: Audit;
}

export class UserEntity extends Entity<UserProps> {
  private constructor(props: UserProps, id?: number) {
    super(props, id);
  }

  static new(props: UserProps, id?: number): UserEntity {
    return new UserEntity(props, id);
  }

  get name(): string {
    return this.props.name;
  }

  get email(): string {
    return this.props.email;
  }

  get password(): string {
    return this.props.password;
  }

  get audit(): Audit {
    return this.props.audit;
  }

  static fromModel(model: UserModel): UserEntity {
    return UserEntity.new(
      {
        name: model.name,
        email: model.email,
        password: model.password,
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
