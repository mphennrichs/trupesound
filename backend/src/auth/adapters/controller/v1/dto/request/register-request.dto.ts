import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsNotEmpty, IsString, MinLength } from 'class-validator';
import { Audit } from '../../../../../../common/entities/audit';
import { UserEntity } from '../../../../../entities/user.entity';

export class RegisterRequestDto {
  @ApiProperty()
  @IsString()
  @IsNotEmpty()
  name: string;

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
