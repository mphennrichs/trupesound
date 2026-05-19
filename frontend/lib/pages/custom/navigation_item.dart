import 'package:flutter/material.dart';
import 'package:trupe_sound/common/navigation_pages_enum.dart';

class NavigationItem {
  final NavigationPage id;
  final String Function(BuildContext context) getLabel;
  final Icon icon; // Ícone não selecionado (outlined)
  final Icon selectedIcon; // Ícone selecionado (filled)

  const NavigationItem(this.id, this.getLabel, this.icon, this.selectedIcon);
}
