import {
  Body,
  ClassSerializerInterceptor,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  Post,
  Put,
  Query,
  UseInterceptors,
} from '@nestjs/common';
import { ApiBody, ApiResponse, ApiTags } from '@nestjs/swagger';
import { InvalidIDException } from '../../../../common/exceptions/invalid-id.exception';
import { CreateActUseCase } from '../../../use-cases/create-act.use-case';
import { DeleteActUseCase } from '../../../use-cases/delete-act.use-case';
import { FilterActUseCase } from '../../../use-cases/filter-act.use-case';
import { FindActByIdUseCase } from '../../../use-cases/find-act-by-id.use-case';
import { UpdateActUseCase } from '../../../use-cases/update-act.use-case';
import { ActRequestDto } from './dto/request/act-request.dto';
import { FilterActRequestDto } from './dto/request/filter-act-request.dto';
import { PartialActRequestDto } from './dto/request/partial-act-request.dto';
import { ActResponseDto, FilterActResponseDto } from './dto/response/act-response.dto';

@ApiTags('acts')
@Controller('v1/acts')
@UseInterceptors(ClassSerializerInterceptor)
export class ActController {
  constructor(
    private readonly createAct: CreateActUseCase,
    private readonly findActById: FindActByIdUseCase,
    private readonly filterAct: FilterActUseCase,
    private readonly updateAct: UpdateActUseCase,
    private readonly deleteAct: DeleteActUseCase,
  ) {}

  @Post()
  @ApiBody({ type: ActRequestDto })
  @ApiResponse({ status: 201, type: ActResponseDto })
  async create(@Body() body: ActRequestDto): Promise<ActResponseDto> {
    const saved = await this.createAct.execute(body.toDomain());
    return ActResponseDto.fromDomain(saved);
  }

  @Get()
  @ApiResponse({ status: 200, type: FilterActResponseDto })
  async filter(@Query() query: FilterActRequestDto): Promise<FilterActResponseDto> {
    const result = await this.filterAct.execute(query.toDomain());
    return { total: result.total, data: result.data.map(ActResponseDto.fromDomain) };
  }

  @Get('/:id')
  @ApiResponse({ status: 200, type: ActResponseDto })
  async findById(@Param('id') paramId: string): Promise<ActResponseDto> {
    const id = Number(paramId);
    if (isNaN(id)) throw new InvalidIDException();
    const entity = await this.findActById.execute(id);
    return ActResponseDto.fromDomain(entity);
  }

  @Put('/:id')
  @ApiBody({ type: PartialActRequestDto })
  @ApiResponse({ status: 200, type: ActResponseDto })
  async update(
    @Param('id') paramId: string,
    @Body() body: PartialActRequestDto,
  ): Promise<ActResponseDto> {
    const id = Number(paramId);
    if (isNaN(id)) throw new InvalidIDException();
    const entity = await this.updateAct.execute(id, body.toDomain());
    return ActResponseDto.fromDomain(entity);
  }

  @Delete('/:id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiResponse({ status: 204 })
  async delete(@Param('id') paramId: string): Promise<void> {
    const id = Number(paramId);
    if (isNaN(id)) throw new InvalidIDException();
    await this.deleteAct.execute(id);
  }
}
