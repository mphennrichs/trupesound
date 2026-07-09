import { ApiProperty } from '@nestjs/swagger';
import { UserEntity } from '../../../../../entities/user.entity';

export class UserResponseDto {
  @ApiProperty() id: number;
  @ApiProperty() name: string;
  @ApiProperty() email: string;

  static fromDomain(entity: UserEntity): UserResponseDto {
    return {
      id: entity.id,
      name: entity.name,
      email: entity.email,
    };
  }
}
