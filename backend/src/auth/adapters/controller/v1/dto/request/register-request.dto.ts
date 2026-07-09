import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty, IsString, Matches, MinLength } from 'class-validator';
import { Audit } from '../../../../../../common/entities/audit';
import { UserEntity } from '../../../../../entities/user.entity';

export class RegisterRequestDto {
  @ApiProperty()
  @IsString()
  @IsNotEmpty()
  name: string;

  @ApiProperty()
  @IsString()
  @Matches(/^[a-zA-Z0-9._]{3,30}$/, {
    message: 'username must be 3-30 characters: letters, numbers, dots and underscores only',
  })
  username: string;

  @ApiProperty()
  @IsEmail()
  email: string;

  @ApiProperty()
  @IsString()
  @MinLength(6)
  password: string;

  toDomain(): UserEntity {
    return UserEntity.new({
      name: this.name,
      username: this.username,
      email: this.email,
      password: this.password,
      audit: Audit.new({
        createdAt: new Date(),
        createdBy: null,
        lastUpdatedAt: null,
        lastUpdatedBy: null,
      }),
    });
  }
}
