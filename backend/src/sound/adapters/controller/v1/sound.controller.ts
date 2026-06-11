import { Controller, Delete, Get, HttpCode, HttpStatus, Param, ParseIntPipe, Patch, Post, Put, Req, Res, Body } from '@nestjs/common';
import { ApiBody, ApiResponse, ApiTags } from '@nestjs/swagger';
import { Request, Response } from 'express';
import { ArchiveSoundUseCase } from '../../../use-cases/archive-sound.use-case';
import { CreateSoundUseCase } from '../../../use-cases/create-sound.use-case';
import { ListSoundsUseCase } from '../../../use-cases/list-sounds.use-case';
import { UpdateSoundUseCase } from '../../../use-cases/update-sound.use-case';
import { UploadLocalSoundUseCase } from '../../../use-cases/upload-local-sound.use-case';
import { ServeLocalSoundUseCase } from '../../../use-cases/serve-local-sound.use-case';
import { SyncLocalSoundsUseCase } from '../../../use-cases/sync-local-sounds.use-case';
import { GeneratePlayUrlUseCase } from '../../../use-cases/generate-play-url.use-case';
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
    private readonly uploadLocalSound: UploadLocalSoundUseCase,
    private readonly serveLocalSound: ServeLocalSoundUseCase,
    private readonly syncLocalSounds: SyncLocalSoundsUseCase,
    private readonly generatePlayUrl: GeneratePlayUrlUseCase,
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

  @Post('sync')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiResponse({ status: 204 })
  async syncLocal(): Promise<void> {
    await this.syncLocalSounds.execute();
  }

  @Put('upload/:fileName')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiResponse({ status: 204 })
  @ApiResponse({ status: 409, description: 'Local storage not configured' })
  async uploadLocal(@Param('fileName') fileName: string, @Req() req: Request): Promise<void> {
    await this.uploadLocalSound.execute(fileName, req);
  }

  @Get('file/:fileName')
  @ApiResponse({ status: 200 })
  @ApiResponse({ status: 404 })
  async serveLocal(@Param('fileName') fileName: string, @Res() res: Response): Promise<void> {
    const { stream, mimeType, size } = await this.serveLocalSound.execute(fileName);
    res.setHeader('Content-Type', mimeType);
    res.setHeader('Content-Length', size);
    res.setHeader('Accept-Ranges', 'bytes');
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Cross-Origin-Resource-Policy', 'cross-origin');
    stream.pipe(res);
  }

  @Get(':id/play-url')
  @ApiResponse({ status: 200, schema: { properties: { url: { type: 'string' } } } })
  async playUrl(@Param('id', ParseIntPipe) id: number): Promise<{ url: string }> {
    const sounds = await this.listSounds.execute();
    const sound = sounds.find((s) => s.id === id);
    if (!sound) return { url: '' };
    const url = await this.generatePlayUrl.execute(sound.url);
    return { url };
  }
}
