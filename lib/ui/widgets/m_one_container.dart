import 'package:flutter/material.dart';
import 'package:mobility_one/util/my_colors.dart';

class MOneContainer extends StatelessWidget {
  const MOneContainer({Key? key, required this.children}) : super(key: key);

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: MyColors.backgroundCardColor,
        borderRadius: BorderRadius.all(
          Radius.circular(19.0693),
        ),
        border: Border.all(color: Color(0xFF3A3A4E), width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
