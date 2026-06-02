import 'dart:math';
import 'package:flutter/material.dart';

class PlayVisualUtils {
  static final Random _random = Random();

  static const List<Color> defaultColors = [
    Colors.pinkAccent,
    Colors.red,
    Colors.green,
    Colors.deepOrange,
    Colors.purple,
    Colors.teal,
    Colors.indigo,
    Colors.amber,
    Colors.cyan,
    Colors.black,
  ];

  static const List<IconData> defaultIcons = [
    Icons.star,
    Icons.visibility,
    Icons.anchor,
    Icons.science,
    Icons.storm,
    Icons.water,
    Icons.spa,
    Icons.festival,
    Icons.grass,
    Icons.bolt,
    Icons.sunny,
    Icons.hive,
    Icons.block,
  ];

  static Color getRandomColor() =>
      defaultColors[_random.nextInt(defaultColors.length)];
  static IconData getRandomIcon() =>
      defaultIcons[_random.nextInt(defaultIcons.length)];
}
