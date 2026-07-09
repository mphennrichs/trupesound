import { UserEntity } from '../entities/user.entity';

export interface AuthResult {
  accessToken: string;
  user: UserEntity;
}
