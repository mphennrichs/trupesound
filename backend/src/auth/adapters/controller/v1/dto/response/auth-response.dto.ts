import { ApiProperty } from '@nestjs/swagger';
import { AuthResult } from '../../../../../use-cases/auth-result';
import { UserResponseDto } from './user-response.dto';

export class AuthResponseDto {
  @ApiProperty() accessToken: string;
  @ApiProperty({ type: UserResponseDto }) user: UserResponseDto;

  static fromDomain(result: AuthResult): AuthResponseDto {
    return {
      accessToken: result.accessToken,
      user: UserResponseDto.fromDomain(result.user),
    };
  }
}
