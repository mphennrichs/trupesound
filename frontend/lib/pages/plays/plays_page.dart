import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:trupe_sound/common/navigation_pages_enum.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/models/play.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';
import 'package:trupe_sound/pages/custom/placeholder_card.dart';
import 'package:trupe_sound/pages/custom/custom_title.dart';
import 'package:trupe_sound/pages/custom/play_card.dart';
import 'package:trupe_sound/pages/plays/new_play/plays_provider.dart';
import 'package:trupe_sound/pages/custom/shimmer_card.dart';

class PlaysPage extends ConsumerWidget {
  const PlaysPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final playsAsync = ref.watch(playsProvider);

    Widget content = playsAsync.when(
      data: (plays) => _buildGrid(context, plays: plays, isLoading: false),
      loading: () => _buildGrid(context, isLoading: true),
      error: (error, stackTrace) {
        print('Error loading plays: $error');
        return _buildError(error.toString());
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
              title: l10n.playsTitle,
              description: l10n.playsDescription,
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
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: AppThemes.spacings.doubleValue,
        mainAxisSpacing: AppThemes.spacings.doubleValue,
        childAspectRatio: 4 / 5,
      ),
      itemCount: isLoading || plays == null ? 9 : plays.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return PlaceholderCard(
            onTap: () => context.pushNamed(NavigationPage.newPlay.name),
          );
        }

        if (isLoading || plays == null) {
          return const ShimmerCard();
        }
        final play = plays[index - 1];
        return PlayCard(
          id: play.id,
          title: play.title,
          author: play.author,
          cueCount: play.cueCount,
          lastModified: DateFormat('dd/MM/yyyy').format(play.lastModifyDate),
        );
      },
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Text(
        'Error: $message',
        style: TextStyle(color: AppThemes.colors.textColor),
      ),
    );
  }
}
