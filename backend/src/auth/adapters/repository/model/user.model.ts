import { UserEntity } from '../../../entities/user.entity';

export class UserModel {
  id: number;
  name: string;
  username: string;
  email: string;
  password: string;
  createdAt: Date;
  createdBy: number | null;
  lastUpdatedAt: Date | null;
  lastUpdatedBy: number | null;

  static fromDomain(entity: UserEntity): UserModel {
    return {
      id: entity.id,
      name: entity.name,
      username: entity.username,
      email: entity.email,
      password: entity.password,
      createdAt: entity.audit.createdAt,
      createdBy: entity.audit.createdBy,
      lastUpdatedAt: entity.audit.lastUpdatedAt,
      lastUpdatedBy: entity.audit.lastUpdatedBy,
    };
  }
}
