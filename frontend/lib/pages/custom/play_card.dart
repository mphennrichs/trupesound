import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trupe_sound/common/app_themes.dart';

class PlayCard extends StatelessWidget {
  final int id;
  final String title;
  final String author;
  final int cueCount;
  final String lastModified;
  final IconData? icon;
  final Color? backgroundColor;

  const PlayCard({
    super.key,
    required this.id,
    required this.title,
    required this.author,
    required this.cueCount,
    required this.lastModified,
    this.icon,
    this.backgroundColor,
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

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.push('/plays/$id'),
        child: Container(
          width: AppThemes.cards.width,
          height: AppThemes.cards.height,
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
              SizedBox(
                height: AppThemes.cards.height * 0.4,
                child: _buildBanner(),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(AppThemes.spacings.singleValue),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTitle(),
                      _buildAuthor(),
                      Divider(color: Colors.white24, thickness: 1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildMetadataColumn("SOUND CUES", "$cueCount Cues"),
                          _buildMetadataColumn(
                            "MODIFIED",
                            lastModified,
                            crossAxisAlignment: CrossAxisAlignment.end,
                          ),
                        ],
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
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }
}
