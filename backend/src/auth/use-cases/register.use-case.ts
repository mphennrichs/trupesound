import { Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { UserRepository } from '../adapters/repository/user.repository';
import { UserModel } from '../adapters/repository/model/user.model';
import { UserEntity } from '../entities/user.entity';
import { EmailAlreadyRegisteredException } from '../exceptions/email-already-registered.exception';
import { UsernameAlreadyRegisteredException } from '../exceptions/username-already-registered.exception';
import { AuthResult } from './auth-result';

const SALT_ROUNDS = 10;

@Injectable()
export class RegisterUseCase {
  constructor(
    private readonly userRepository: UserRepository,
    private readonly jwtService: JwtService,
  ) {}

  async execute(user: UserEntity): Promise<AuthResult> {
    const existingByEmail = await this.userRepository.findByEmail(user.email);
    if (existingByEmail) throw new EmailAlreadyRegisteredException();

    const existingByUsername = await this.userRepository.findByUsername(user.username);
    if (existingByUsername) throw new UsernameAlreadyRegisteredException();

    const hashedPassword = await bcrypt.hash(user.password, SALT_ROUNDS);
    const toSave = UserEntity.new({
      name: user.name,
      username: user.username,
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
