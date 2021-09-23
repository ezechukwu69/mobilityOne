import 'package:flutter/material.dart';
import 'package:mobility_one/util/my_colors.dart';
import 'package:mobility_one/util/my_text_styles.dart';

class CancelButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  const CancelButton({
    required this.onPressed,
    this.title = 'Cancel',
    this.margin = const EdgeInsets.all(0),
  });

  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 141,
          margin: margin,
          decoration: BoxDecoration(
            color: MyColors.mobilityOneBlackColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Text(
                title,
                style: MyTextStyles.dataTableViewAll.copyWith(
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
