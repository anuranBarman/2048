import 'package:flutter/material.dart';
import 'package:two_zero_four_eight/themes/color.dart';

/// Individual Tile
class Tile extends StatefulWidget {
  /// Constructor
  const Tile(
      {Key? key,
      required this.number,
      required this.width,
      required this.height,
      required this.color,
      this.fontSize})
      : super(key: key);

  /// Total number of Tiles
  final String number;

  /// Width and height of the tile
  final double width, height;

  /// Background color of the tile
  final int color;

  /// Size
  final double? fontSize;

  @override
  State<StatefulWidget> createState() {
    return _TileState();
  }
}

class _TileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
          color: Color(widget.color),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Center(
        child: Text(
          widget.number,
          style: TextStyle(
              fontSize: widget.fontSize,
              fontWeight: FontWeight.bold,
              color: Color(ColorConstants.fontColorTwoFour)),
        ),
      ),
    );
  }
}
