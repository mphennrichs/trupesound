import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/common/navigation_pages_enum.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/custom/custom_title.dart';
import 'package:trupe_sound/pages/custom/play_card.dart';
import 'package:trupe_sound/pages/custom/shimmer_card.dart';
import 'package:trupe_sound/pages/plays/models/play.dart';
import 'package:trupe_sound/pages/plays/provider/plays_provider.dart';

class SoundscapePage extends ConsumerWidget {
  const SoundscapePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final playsAsync = ref.watch(playsProvider);

    Widget content = playsAsync.when(
      data: (plays) => _buildGrid(context, plays: plays, isLoading: false),
      loading: () => _buildGrid(context, isLoading: true),
      error: (error, stackTrace) {
        return _buildError(context, error.toString());
      },
    );

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppThemes.colors.backgroundColor,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: AppThemes.spacings.doubleValue,
          horizontal: AppThemes.spacings.doubleValue,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomTitle(
              title: l10n.soundscape,
              description: l10n.soundscapeDescription,
            ),
            AppThemes.spacings.singleSpace,
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(
    BuildContext context, {
    List<Play>? plays,
    required bool isLoading,
  }) {
    if (!isLoading && (plays == null || plays.isEmpty)) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppThemes.spacings.doubleSpace,
            Text(
              AppLocalizations.of(context)!.noPlays,
              style: TextStyle(
                color: AppThemes.colors.textColor,
                fontSize: AppThemes.texts.h1FontSize,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: AppThemes.spacings.singleValue,
        mainAxisSpacing: AppThemes.spacings.singleValue,
        childAspectRatio: AppThemes.cards.aspectRatio,
      ),
      itemCount: isLoading ? 3 : plays!.length,
      itemBuilder: (context, index) {
        if (isLoading) {
          return const ShimmerCard();
        }

        final play = plays![index];
        return PlayCard(
          id: play.id,
          title: play.title,
          author: play.author,
          cueCount: play.cueCount,
          lastModified: DateFormat('dd/MM/yyyy').format(play.lastModifyDate),
          icon: play.icon,
          backgroundColor: play.backgroundColor,
          onTapDestination: NavigationPage.playSoundscape.name,
        );
      },
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Text(
        'Error: $message',
        style: TextStyle(color: AppThemes.colors.textColor),
      ),
    );
  }
}
