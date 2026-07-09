import { Body, Controller, HttpCode, HttpStatus, Post } from '@nestjs/common';
import { ApiBody, ApiResponse, ApiTags } from '@nestjs/swagger';
import { Public } from '../../../decorators/public.decorator';
import { LoginUseCase } from '../../../use-cases/login.use-case';
import { RegisterUseCase } from '../../../use-cases/register.use-case';
import { LoginRequestDto } from './dto/request/login-request.dto';
import { RegisterRequestDto } from './dto/request/register-request.dto';
import { AuthResponseDto } from './dto/response/auth-response.dto';

@ApiTags('auth')
@Controller('v1/auth')
export class AuthController {
  constructor(
    private readonly registerUseCase: RegisterUseCase,
    private readonly loginUseCase: LoginUseCase,
  ) {}

  @Public()
  @Post('register')
  @ApiBody({ type: RegisterRequestDto })
  @ApiResponse({ status: 201, type: AuthResponseDto })
  async register(@Body() body: RegisterRequestDto): Promise<AuthResponseDto> {
    const result = await this.registerUseCase.execute(body.toDomain());
    return AuthResponseDto.fromDomain(result);
  }

  @Public()
  @Post('login')
  @HttpCode(HttpStatus.OK)
  @ApiBody({ type: LoginRequestDto })
  @ApiResponse({ status: 200, type: AuthResponseDto })
  async login(@Body() body: LoginRequestDto): Promise<AuthResponseDto> {
    const result = await this.loginUseCase.execute(body.email, body.password);
    return AuthResponseDto.fromDomain(result);
  }
}
