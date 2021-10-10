import 'package:flutter/material.dart';

/// a
class IndividualCell {
  /// a
  IndividualCell(
      {this.x = 0,
      this.y = 0,
      this.value = 0,
      this.fontSize = 15,
      this.tileColor = Colors.black,
      this.fontColor = Colors.white});

  /// x
  final int x;

  /// y
  final int y;

  /// value
  int value;

  /// font size
  double fontSize;

  /// Tile Background Color
  Color tileColor;

  /// Tile Font Color
  Color fontColor;
}
