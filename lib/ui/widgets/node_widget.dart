import 'package:flutter/material.dart';
import 'package:mobility_one/models/node_item.dart';
import 'package:mobility_one/util/my_colors.dart';

class NodeWidget extends StatelessWidget {
  const NodeWidget({required this.nodeItem, this.textColor, this.fontSize, Key? key}) : super(key: key);

  final NodeItem nodeItem;
  final Color? textColor;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Text(
        nodeItem.name,
        style: TextStyle(
          fontSize: fontSize ?? 16,
          color: textColor ?? MyColors.dataTableHeadingTextColor,
        ),
      ),
    );
  }
}