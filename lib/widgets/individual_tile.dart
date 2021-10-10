import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:two_zero_four_eight/model/individual_cell.dart';
import 'package:two_zero_four_eight/themes/color.dart';

/// IndividualTile
class IndividualTile extends StatelessWidget {
  /// Constructor
  const IndividualTile({required Key key, required this.cell})
      : super(key: key);

  /// Value to be displyed in the tile
  final IndividualCell cell;

  @override
  Widget build(BuildContext context) {
    late String _value;
    if (cell.value == 0) {
      _value = '';
    } else {
      _value = cell.value.toString();
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.0.w),
      child: Container(
        margin: EdgeInsets.all(0.5.w),
        color: cell.tileColor,
        child: Center(
          child: Text(
            _value,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: cell.fontSize,
                color: Color(ColorConstants.fontColorTwoFour)),
          ),
        ),
      ),
    );
  }
}
