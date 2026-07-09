import { Injectable } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { PrismaService } from '../../../common/application/service/prisma-client.service';
import { UserRepository } from './user.repository';
import { UserModel } from './model/user.model';

@Injectable()
export class UserPrismaRepository implements UserRepository {
  constructor(private readonly prisma: PrismaService) {}

  async save(user: UserModel): Promise<UserModel> {
    const { id, ...data } = user;
    const saved = await this.prisma.user.create({
      data: data as Prisma.UserCreateInput,
    });
    return saved as unknown as UserModel;
  }

  async findByEmail(email: string): Promise<UserModel | null> {
    const user = await this.prisma.user.findUnique({ where: { email } });
    return user as unknown as UserModel | null;
  }

  async findByUsername(username: string): Promise<UserModel | null> {
    const user = await this.prisma.user.findUnique({ where: { username } });
    return user as unknown as UserModel | null;
  }

  async findById(id: number): Promise<UserModel | null> {
    const user = await this.prisma.user.findUnique({ where: { id } });
    return user as unknown as UserModel | null;
  }
}
