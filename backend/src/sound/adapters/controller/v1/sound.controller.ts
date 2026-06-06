import { Body, Controller, Delete, Get, HttpCode, HttpStatus, Param, ParseIntPipe, Patch, Post } from '@nestjs/common';
import { ApiBody, ApiResponse, ApiTags } from '@nestjs/swagger';
import { ArchiveSoundUseCase } from '../../../use-cases/archive-sound.use-case';
import { CreateSoundUseCase } from '../../../use-cases/create-sound.use-case';
import { ListSoundsUseCase } from '../../../use-cases/list-sounds.use-case';
import { UpdateSoundUseCase } from '../../../use-cases/update-sound.use-case';
import { Sound } from '../../../entities/sound.entity';
import { CreateSoundRequestDto } from './dto/request/create-sound-request.dto';
import { UpdateSoundRequestDto } from './dto/request/update-sound-request.dto';
import { SoundResponseDto } from './dto/response/sound-response.dto';

@ApiTags('sounds')
@Controller('v1/sounds')
export class SoundController {
  constructor(
    private readonly listSounds: ListSoundsUseCase,
    private readonly createSound: CreateSoundUseCase,
    private readonly updateSound: UpdateSoundUseCase,
    private readonly archiveSound: ArchiveSoundUseCase,
  ) {}

  private toDto(sound: Sound): SoundResponseDto {
    return {
      id: sound.id,
      name: sound.name,
      category: sound.category,
      durationMs: sound.durationMs,
      url: sound.url,
      archived: sound.archived,
      createdAt: sound.createdAt,
    };
  }

  @Get()
  @ApiResponse({ status: 200, type: [SoundResponseDto] })
  async list(): Promise<SoundResponseDto[]> {
    const sounds = await this.listSounds.execute();
    return sounds.map(this.toDto);
  }

  @Post()
  @ApiBody({ type: CreateSoundRequestDto })
  @ApiResponse({ status: 201, type: SoundResponseDto })
  async create(@Body() body: CreateSoundRequestDto): Promise<SoundResponseDto> {
    const sound = await this.createSound.execute({
      name: body.name,
      category: body.category,
      url: body.url,
      durationMs: body.durationMs ?? 0,
    });
    return this.toDto(sound);
  }

  @Patch(':id')
  @ApiBody({ type: UpdateSoundRequestDto })
  @ApiResponse({ status: 200, type: SoundResponseDto })
  async update(
    @Param('id', ParseIntPipe) id: number,
    @Body() body: UpdateSoundRequestDto,
  ): Promise<SoundResponseDto> {
    const sound = await this.updateSound.execute(id, {
      name: body.name,
      category: body.category,
    });
    return this.toDto(sound);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiResponse({ status: 204 })
  async archive(@Param('id', ParseIntPipe) id: number): Promise<void> {
    await this.archiveSound.execute(id);
  }
}
