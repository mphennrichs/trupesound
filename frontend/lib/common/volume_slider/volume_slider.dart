import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/common/volume_slider/provider/volume_provider.dart';

class VolumeSlider extends ConsumerWidget {
  const VolumeSlider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final volume = ref.watch(volumeProvider);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.volume_down,
          size: AppThemes.texts.normalFontSize,
          color: Colors.white,
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 2.0,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
            overlayShape: SliderComponentShape.noOverlay,
          ),
          child: SizedBox(
            width: AppThemes.texts.normalFontSize * 10,
            child: Slider(
              value: volume,
              onChanged: (value) {
                ref.read(volumeProvider.notifier).updateVolume(value);
              },
            ),
          ),
        ),
        Icon(
          Icons.volume_up,
          size: AppThemes.texts.normalFontSize,
          color: AppThemes.colors.textColor,
        ),
      ],
    );
  }
}
