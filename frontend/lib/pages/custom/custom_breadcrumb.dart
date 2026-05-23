import 'package:flutter/material.dart';
import 'package:trupe_sound/common/app_themes.dart';

class BreadcrumbItem {
  final String label;
  final VoidCallback? onTap;

  const BreadcrumbItem({required this.label, this.onTap});
}

class CustomBreadcrumb extends StatelessWidget {
  final List<BreadcrumbItem> items;

  const CustomBreadcrumb({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: items.asMap().entries.map((entry) {
        final int index = entry.key;
        final BreadcrumbItem item = entry.value;
        final bool isLast = index == items.length - 1;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: item.onTap,
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                  vertical: 2.0,
                ),
                child: Text(
                  item.label,
                  style: TextStyle(
                    color: AppThemes.colors.textColor,
                    fontSize: AppThemes.texts.smallFontSize,
                    fontWeight: isLast ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
            if (!isLast)
              Icon(
                Icons.chevron_right,
                size: 16,
                color: AppThemes.colors.textColor,
              ),
          ],
        );
      }).toList(),
    );
  }
}
