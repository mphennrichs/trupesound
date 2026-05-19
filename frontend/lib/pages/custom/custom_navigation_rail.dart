import 'package:flutter/material.dart';
import 'package:trupe_sound/common/app_themes.dart';
import 'package:trupe_sound/pages/custom/navigation_item.dart';

class CustomNavigationRail extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final List<NavigationItem> topDestinations;

  const CustomNavigationRail({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.topDestinations,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220, // Ideal width to 'extended' mode
      child: Container(
        decoration: BoxDecoration(color: AppThemes.colors.backgroundColor),
        child: Column(
          children: <Widget>[
            ..._buildDestinationWidgets(context, topDestinations),

            AppThemes.spacings.singleSpace, // Padding final
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDestinationWidgets(
    BuildContext context,
    List<NavigationItem> items,
  ) {
    return items.asMap().entries.map((entry) {
      final NavigationItem item = entry.value;

      final bool isSelected = selectedIndex == entry.key;
      final Color color = isSelected
          ? AppThemes.colors.primaryColor
          : AppThemes.colors.textColor;

      // Define the icon for the selected row
      final Icon iconToDisplay = isSelected ? item.selectedIcon : item.icon;

      return InkWell(
        onTap: () => onDestinationSelected(entry.key),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: AppThemes.spacings.singleValue,
            horizontal: AppThemes.spacings.doubleValue,
          ),
          color: isSelected ? color.withValues(alpha: 0.2) : Colors.transparent,
          child: Row(
            children: [
              iconToDisplay,
              AppThemes.spacings.singleSpace,
              Text(
                item.getLabel(context),
                style: TextStyle(
                  color: color,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}
