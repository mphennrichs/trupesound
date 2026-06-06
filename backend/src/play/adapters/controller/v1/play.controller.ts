import {
  Body,
  ClassSerializerInterceptor,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  Patch,
  Post,
  Put,
  Query,
  UseInterceptors,
} from '@nestjs/common';
import { ApiBody, ApiResponse, ApiTags } from '@nestjs/swagger';
import { InvalidIDException } from '../../../../common/exceptions/invalid-id.exception';
import { CreatePlayUseCase } from '../../../use-cases/create-play.use-case';
import { DeletePlayUseCase } from '../../../use-cases/delete-play.use-case';
import { FilterPlayUseCase } from '../../../use-cases/filter-play.use-case';
import { FindPlayByIdUseCase } from '../../../use-cases/find-play-by-id.use-case';
import { UpdatePlayUseCase } from '../../../use-cases/update-play.use-case';
import { FilterPlayRequestDto } from './dto/request/filter-play-request.dto';
import { PartialPlayRequestDto } from './dto/request/partial-play-request.dto';
import { PlayRequestDto } from './dto/request/play-request.dto';
import { FilterPlayResponseDto, PlayResponseDto } from './dto/response/play-response.dto';

@ApiTags('plays')
@Controller('v1/plays')
@UseInterceptors(ClassSerializerInterceptor)
export class PlayController {
  constructor(
    private readonly createPlay: CreatePlayUseCase,
    private readonly findPlayById: FindPlayByIdUseCase,
    private readonly filterPlay: FilterPlayUseCase,
    private readonly updatePlay: UpdatePlayUseCase,
    private readonly deletePlay: DeletePlayUseCase,
  ) {}

  @Post()
  @ApiBody({ type: PlayRequestDto })
  @ApiResponse({ status: 201, type: PlayResponseDto })
  async create(@Body() body: PlayRequestDto): Promise<PlayResponseDto> {
    const saved = await this.createPlay.execute(body.toDomain());
    return PlayResponseDto.fromDomain(saved);
  }

  @Get()
  @ApiResponse({ status: 200, type: FilterPlayResponseDto })
  async filter(@Query() query: FilterPlayRequestDto): Promise<FilterPlayResponseDto> {
    const result = await this.filterPlay.execute(query.toDomain());
    return { total: result.total, data: result.data.map(PlayResponseDto.fromDomain) };
  }

  @Get('/:id')
  @ApiResponse({ status: 200, type: PlayResponseDto })
  async findById(@Param('id') paramId: string): Promise<PlayResponseDto> {
    const id = Number(paramId);
    if (isNaN(id)) throw new InvalidIDException();
    const entity = await this.findPlayById.execute(id);
    return PlayResponseDto.fromDomain(entity);
  }

  @Put('/:id')
  @ApiBody({ type: PartialPlayRequestDto })
  @ApiResponse({ status: 200, type: PlayResponseDto })
  async update(
    @Param('id') paramId: string,
    @Body() body: PartialPlayRequestDto,
  ): Promise<PlayResponseDto> {
    const id = Number(paramId);
    if (isNaN(id)) throw new InvalidIDException();
    const entity = await this.updatePlay.execute(id, body.toDomain());
    return PlayResponseDto.fromDomain(entity);
  }

  @Delete('/:id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiResponse({ status: 204 })
  async delete(@Param('id') paramId: string): Promise<void> {
    const id = Number(paramId);
    if (isNaN(id)) throw new InvalidIDException();
    await this.deletePlay.execute(id);
  }
}
