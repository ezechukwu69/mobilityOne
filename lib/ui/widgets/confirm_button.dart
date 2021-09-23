import 'package:flutter/material.dart';
import 'package:mobility_one/util/my_colors.dart';
import 'package:mobility_one/util/my_text_styles.dart';

class ConfirmButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool canClick;
  final String title;
  final bool expanded;
  final double? height;
  const ConfirmButton({required this.onPressed, this.canClick = true, this.title='Confirm', this.expanded = false, this.height});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: canClick ? SystemMouseCursors.click : MouseCursor.defer,
      child: GestureDetector(
        onTap: canClick ? onPressed : null,
        child: Container(
          width: expanded ? null : 141,
          height: height != null ? height : null,
          decoration: BoxDecoration(
            color: canClick
                ? MyColors.mobilityOneLightGreenColor
                : MyColors.mobilityOneLightGreenColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Text(
                title,
                style: MyTextStyles.dataTableViewAll.copyWith(
                    fontSize: 16, color: MyColors.dataTableBackgroundColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
