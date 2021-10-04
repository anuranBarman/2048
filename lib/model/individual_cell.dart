import 'package:flutter/material.dart';

/// a
class IndividualCell {
  /// a
  IndividualCell(
      {required this.x,
      required this.y,
      this.value = 0,
      required this.fontSize,
      required this.color});

  /// x
  final int x;

  /// y
  final int y;

  /// value
  int value;

  /// font size
  double fontSize;

  /// Tile Background Color
  Color color;
}
