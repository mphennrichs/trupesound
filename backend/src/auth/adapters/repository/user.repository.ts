import { UserModel } from './model/user.model';

export abstract class UserRepository {
  abstract save(user: UserModel): Promise<UserModel>;
  abstract findByEmail(email: string): Promise<UserModel | null>;
  abstract findByUsername(username: string): Promise<UserModel | null>;
  abstract findById(id: number): Promise<UserModel | null>;
}
