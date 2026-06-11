import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/l10n/app_localizations.dart';

class PlayCard extends StatelessWidget {
  final int id;
  final String title;
  final String author;
  final int cueCount;
  final String lastModified;
  final IconData? icon;
  final Color? backgroundColor;
  final String onTapDestination;

  const PlayCard({
    super.key,
    required this.id,
    required this.title,
    required this.author,
    required this.cueCount,
    required this.lastModified,
    this.icon,
    this.backgroundColor,
    required this.onTapDestination,
  });

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(color: backgroundColor),
      child: Center(child: Icon(icon, color: Colors.white, size: 48)),
    );
  }

  Text _buildTitle() {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: AppThemes.texts.h1FontSize,
        fontWeight: FontWeight.bold,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Text _buildAuthor() {
    return Text(
      author,
      style: TextStyle(
        color: Colors.white70,
        fontSize: AppThemes.texts.h2FontSize,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildInfoBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(),
        _buildAuthor(),
        Divider(color: Colors.white24, thickness: 1),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = AppThemes.cards.calculateWidth(screenWidth);
    final cardHeight = AppThemes.cards.calculateHeight(cardWidth);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.pushNamed(
          onTapDestination,
          pathParameters: {'playId': id.toString()},
        ),
        child: Container(
          width: cardWidth,
          height: cardHeight,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppThemes.colors.cardColor,
            borderRadius: AppThemes.borders.defaultBorderRadius,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 4, child: _buildBanner()),
              AppThemes.spacings.singleSpace,
              Expanded(
                flex: 6,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: AppThemes.spacings.singleValue,
                    right: AppThemes.spacings.singleValue,
                    bottom: AppThemes.spacings.singleValue,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoBox(),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          child: _buildSecondaryInfo(l10n),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryInfo(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildMetadataColumn(l10n.soundCues, l10n.cue(cueCount)),
        ),
        Expanded(
          child: _buildMetadataColumn(
            l10n.lastModified,
            lastModified,
            crossAxisAlignment: CrossAxisAlignment.end,
          ),
        ),
      ],
    );
  }

  Widget _buildMetadataColumn(
    String label,
    String value, {
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white54,
            fontSize: AppThemes.texts.smallFontSize,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: AppThemes.texts.normalFontSize,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
