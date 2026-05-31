import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/plays/models/play.dart';
import 'package:trupe_sound/pages/plays/provider/plays_provider.dart';
import 'package:trupe_sound/pages/soundscape/act_tabs.dart';

class SoundscapePlayPage extends ConsumerWidget {
  final int playId;

  const SoundscapePlayPage({super.key, required this.playId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final playsAsync = ref.watch(playsProvider);

    return Scaffold(
      backgroundColor: AppThemes.colors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppThemes.colors.backgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
          tooltip: l10n.back,
        ),
        title: playsAsync.maybeWhen(
          data: (plays) {
            final play = plays.firstWhere((p) => p.id == playId);
            return Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: play.title),
                  TextSpan(
                    text: ' \u2022 ',
                    style: TextStyle(
                      color: AppThemes.colors.hintTextColor,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  TextSpan(
                    text: play.author,
                    style: TextStyle(
                      color: AppThemes.colors.textColor,
                      fontSize: AppThemes.texts.normalFontSize,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
              style: TextStyle(
                color: Colors.white,
                fontSize: AppThemes.texts.h1FontSize,
                fontWeight: FontWeight.bold,
              ),
            );
          },
          orElse: () => null,
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppThemes.colors.borderColor, height: 1.0),
        ),
      ),
      body: playsAsync.when(
        data: (plays) {
          final play = plays.firstWhere((p) => p.id == playId);
          return _buildLayout(context, play);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text(
            'Error: $err',
            style: TextStyle(color: AppThemes.colors.textColor),
          ),
        ),
      ),
    );
  }

  Widget _buildLayout(BuildContext context, Play play) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        // Column 1: Acts and Script
        Expanded(flex: 2, child: ActTabs(play: play)),
        // Column 2: Sound Cues
        Expanded(
          flex: 1,
          child: Center(
            child: Text(
              l10n.soundCues,
              style: TextStyle(
                color: AppThemes.colors.textColor,
                fontSize: AppThemes.texts.h1FontSize,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
