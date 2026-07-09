import { Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { UserRepository } from '../adapters/repository/user.repository';
import { UserEntity } from '../entities/user.entity';
import { InvalidCredentialsException } from '../exceptions/invalid-credentials.exception';
import { AuthResult } from './auth-result';

@Injectable()
export class LoginUseCase {
  constructor(
    private readonly userRepository: UserRepository,
    private readonly jwtService: JwtService,
  ) {}

  async execute(identifier: string, password: string): Promise<AuthResult> {
    const model = identifier.includes('@')
      ? await this.userRepository.findByEmail(identifier)
      : await this.userRepository.findByUsername(identifier);
    if (!model) throw new InvalidCredentialsException();

    const isValid = await bcrypt.compare(password, model.password);
    if (!isValid) throw new InvalidCredentialsException();

    const user = UserEntity.fromModel(model);
    const accessToken = await this.jwtService.signAsync({
      sub: user.id,
      email: user.email,
    });

    return { accessToken, user };
  }
}
