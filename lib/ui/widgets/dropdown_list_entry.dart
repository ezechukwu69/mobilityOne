import 'package:flutter/material.dart';
import 'package:mobility_one/util/my_colors.dart';

class DropdownListEntry extends StatelessWidget {
  final Widget child;
  final bool isSelected;
  final VoidCallback onPressed;
  const DropdownListEntry({required this.child, this.isSelected = false,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          color: isSelected ? MyColors.mobilityOneLightGreenColor : Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: child,
          ),
        ),
      ),
    );
  }
}
