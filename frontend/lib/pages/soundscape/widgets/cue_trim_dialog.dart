import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/common/volume_slider/provider/volume_provider.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/plays/provider/plays_provider.dart';
import 'package:trupe_sound/pages/sound_library/models/sound_cue_model.dart';
import 'package:trupe_sound/pages/sound_library/models/sound_model.dart';

class CueTrimDialog extends ConsumerStatefulWidget {
  final SoundCueModel cue;
  final SoundModel sound;
  final int playId;
  final int actNumber;

  const CueTrimDialog({
    super.key,
    required this.cue,
    required this.sound,
    required this.playId,
    required this.actNumber,
  });

  static void show(
    BuildContext context, {
    required SoundCueModel cue,
    required SoundModel sound,
    required int playId,
    required int actNumber,
  }) {
    showDialog(
      context: context,
      builder: (_) => CueTrimDialog(
        cue: cue,
        sound: sound,
        playId: playId,
        actNumber: actNumber,
      ),
    );
  }

  @override
  ConsumerState<CueTrimDialog> createState() => _CueTrimDialogState();
}

class _CueTrimDialogState extends ConsumerState<CueTrimDialog> {
  late double _startMs;
  late double _endMs;
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  bool _isSaving = false;

  double get _totalMs => widget.sound.duration.inMilliseconds.toDouble().clamp(1, double.infinity);

  @override
  void initState() {
    super.initState();
    _startMs = (widget.cue.startMs ?? 0).toDouble();
    _endMs = (widget.cue.endMs ?? widget.sound.duration.inMilliseconds).toDouble();

    _player.onPlayerStateChanged.listen((ps) {
      if (mounted) setState(() => _isPlaying = ps == PlayerState.playing);
    });
    _player.onPlayerComplete.listen((_) {
      if (mounted) setState(() => _isPlaying = false);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePreview() async {
    if (_isPlaying) {
      await _player.stop();
      return;
    }

    final volume = ref.read(volumeProvider);
    await _player.setVolume(volume);
    final source = widget.sound.url.startsWith('http')
        ? UrlSource(widget.sound.url)
        : DeviceFileSource(widget.sound.url);
    await _player.play(source);
    await _player.seek(Duration(milliseconds: _startMs.round()));

    final trimDuration = Duration(milliseconds: (_endMs - _startMs).round());
    Future.delayed(trimDuration, () async {
      if (mounted && _isPlaying) await _player.stop();
    });
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    await _player.stop();

    final fullDuration = widget.sound.duration.inMilliseconds;
    final startMs = _startMs.round() <= 0 ? null : _startMs.round();
    final endMs = _endMs.round() >= fullDuration ? null : _endMs.round();

    await ref.read(playsProvider.notifier).updateCueTrim(
          playId: widget.playId,
          actNumber: widget.actNumber,
          cueId: widget.cue.id,
          startMs: startMs,
          endMs: endMs,
        );

    if (mounted) Navigator.of(context).pop();
  }

  String _formatMs(double ms) {
    final d = Duration(milliseconds: ms.round());
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final tenth = ((ms.round() % 1000) ~/ 100);
    return '$m:$s.$tenth';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cueDuration = _endMs - _startMs;

    return Dialog(
      backgroundColor: AppThemes.colors.cardColor,
      shape: RoundedRectangleBorder(borderRadius: AppThemes.borders.defaultBorderRadius),
      child: Container(
        width: 560,
        padding: EdgeInsets.all(AppThemes.spacings.doubleValue),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.tune, color: AppThemes.colors.primaryColor, size: 24),
                AppThemes.spacings.singleSpace,
                Expanded(
                  child: Text(
                    widget.sound.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppThemes.texts.h1FontSize,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: _isSaving ? null : () async {
                    await _player.stop();
                    if (mounted) Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.close, color: Colors.white70),
                ),
              ],
            ),
            AppThemes.spacings.singleSpace,

            // Trim bar
            _TrimBar(
              totalMs: _totalMs,
              startMs: _startMs,
              endMs: _endMs,
              onChanged: (start, end) => setState(() {
                _startMs = start;
                _endMs = end;
              }),
            ),
            const SizedBox(height: 12),

            // Time labels
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _TimeChip(label: l10n.trimStart, value: _formatMs(_startMs), color: AppThemes.colors.primaryColor),
                Column(
                  children: [
                    Text(
                      _formatMs(cueDuration),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppThemes.texts.normalFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      l10n.cueDuration,
                      style: TextStyle(
                        color: AppThemes.colors.hintTextColor,
                        fontSize: AppThemes.texts.smallFontSize,
                      ),
                    ),
                  ],
                ),
                _TimeChip(label: l10n.trimEnd, value: _formatMs(_endMs), color: Colors.orangeAccent),
              ],
            ),
            AppThemes.spacings.singleSpace,

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Preview play/stop
                IconButton(
                  icon: Icon(
                    _isPlaying ? Icons.stop_circle_outlined : Icons.play_circle_outline,
                    color: AppThemes.colors.primaryColor,
                    size: 32,
                  ),
                  onPressed: _togglePreview,
                  tooltip: _isPlaying ? l10n.panicStop('') : 'Preview',
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: _isSaving ? null : () async {
                        await _player.stop();
                        if (mounted) Navigator.of(context).pop();
                      },
                      child: Text(l10n.cancel, style: const TextStyle(color: Colors.white70)),
                    ),
                    AppThemes.spacings.singleSpace,
                    ElevatedButton(
                      style: AppThemes.buttons.primaryButtonStyle,
                      onPressed: _isSaving ? null : _save,
                      child: _isSaving
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Text(l10n.save, style: const TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _TimeChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.bold, fontFeatures: const [FontFeature.tabularFigures()]),
        ),
        Text(
          label,
          style: TextStyle(color: AppThemes.colors.hintTextColor, fontSize: AppThemes.texts.smallFontSize),
        ),
      ],
    );
  }
}

class _TrimBar extends StatefulWidget {
  final double totalMs;
  final double startMs;
  final double endMs;
  final void Function(double start, double end) onChanged;

  const _TrimBar({
    required this.totalMs,
    required this.startMs,
    required this.endMs,
    required this.onChanged,
  });

  @override
  State<_TrimBar> createState() => _TrimBarState();
}

class _TrimBarState extends State<_TrimBar> {
  static const double _handleWidth = 14.0;
  static const double _barHeight = 56.0;
  static const double _minGapMs = 500;

  double _barWidth = 0;

  double _msToX(double ms) => (ms / widget.totalMs) * (_barWidth - _handleWidth * 2) + _handleWidth;
  double _xToMs(double x) => ((x - _handleWidth) / (_barWidth - _handleWidth * 2) * widget.totalMs).clamp(0, widget.totalMs);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _barWidth = constraints.maxWidth;
        final startX = _msToX(widget.startMs);
        final endX = _msToX(widget.endMs);

        return SizedBox(
          height: _barHeight,
          child: Stack(
            children: [
              // Background track
              Positioned.fill(
                child: CustomPaint(
                  painter: _TrimBarPainter(
                    startX: startX,
                    endX: endX,
                    handleWidth: _handleWidth,
                    primaryColor: AppThemes.colors.primaryColor,
                    borderColor: AppThemes.colors.borderColor,
                    backgroundColor: AppThemes.colors.backgroundColor,
                  ),
                ),
              ),
              // Start handle
              Positioned(
                left: startX - _handleWidth / 2,
                top: 0,
                bottom: 0,
                width: _handleWidth + 12,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onHorizontalDragUpdate: (d) {
                    final newX = (startX + d.delta.dx).clamp(_handleWidth, endX - _handleWidth - _msToX(_minGapMs) + _handleWidth);
                    final newMs = _xToMs(newX).clamp(0.0, widget.endMs - _minGapMs);
                    widget.onChanged(newMs.toDouble(), widget.endMs);
                  },
                ),
              ),
              // End handle
              Positioned(
                left: endX - _handleWidth / 2 - 6,
                top: 0,
                bottom: 0,
                width: _handleWidth + 12,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onHorizontalDragUpdate: (d) {
                    final newX = (endX + d.delta.dx).clamp(startX + _handleWidth + _msToX(_minGapMs) - _handleWidth, _barWidth - _handleWidth);
                    final newMs = _xToMs(newX).clamp(widget.startMs + _minGapMs, widget.totalMs);
                    widget.onChanged(widget.startMs, newMs);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TrimBarPainter extends CustomPainter {
  final double startX;
  final double endX;
  final double handleWidth;
  final Color primaryColor;
  final Color borderColor;
  final Color backgroundColor;

  const _TrimBarPainter({
    required this.startX,
    required this.endX,
    required this.handleWidth,
    required this.primaryColor,
    required this.borderColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final radius = const Radius.circular(6);
    final rrect = RRect.fromLTRBR(0, size.height * 0.35, size.width, size.height * 0.65, radius);

    // Full track background
    canvas.drawRRect(rrect, Paint()..color = backgroundColor);

    // Selected region
    final selectedRect = RRect.fromLTRBR(startX, size.height * 0.35, endX, size.height * 0.65, radius);
    canvas.drawRRect(selectedRect, Paint()..color = primaryColor.withValues(alpha: 0.35));

    // Track border
    canvas.drawRRect(rrect, Paint()..color = borderColor..style = PaintingStyle.stroke..strokeWidth = 1);

    // Start handle
    _drawHandle(canvas, size, startX, primaryColor);

    // End handle
    _drawHandle(canvas, size, endX, Colors.orangeAccent);
  }

  void _drawHandle(Canvas canvas, Size size, double x, Color color) {
    final handleRect = RRect.fromLTRBR(
      x - handleWidth / 2, 4, x + handleWidth / 2, size.height - 4,
      const Radius.circular(4),
    );
    canvas.drawRRect(handleRect, Paint()..color = color);

    // Grip lines
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    for (final offset in [-3.0, 0.0, 3.0]) {
      canvas.drawLine(
        Offset(x + offset, size.height * 0.3),
        Offset(x + offset, size.height * 0.7),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(_TrimBarPainter old) =>
      old.startX != startX || old.endX != endX;
}
