import { Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { UserRepository } from '../adapters/repository/user.repository';
import { UserModel } from '../adapters/repository/model/user.model';
import { UserEntity } from '../entities/user.entity';
import { EmailAlreadyRegisteredException } from '../exceptions/email-already-registered.exception';
import { AuthResult } from './auth-result';

const SALT_ROUNDS = 10;

@Injectable()
export class RegisterUseCase {
  constructor(
    private readonly userRepository: UserRepository,
    private readonly jwtService: JwtService,
  ) {}

  async execute(user: UserEntity): Promise<AuthResult> {
    const existing = await this.userRepository.findByEmail(user.email);
    if (existing) throw new EmailAlreadyRegisteredException();

    const hashedPassword = await bcrypt.hash(user.password, SALT_ROUNDS);
    const toSave = UserEntity.new({
      name: user.name,
      email: user.email,
      password: hashedPassword,
      audit: user.audit,
    });

    const saved = await this.userRepository.save(UserModel.fromDomain(toSave));
    const savedEntity = UserEntity.fromModel(saved);

    const accessToken = await this.jwtService.signAsync({
      sub: savedEntity.id,
      email: savedEntity.email,
    });

    return { accessToken, user: savedEntity };
  }
}
