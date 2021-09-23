import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobility_one/util/my_colors.dart';
import 'package:mobility_one/util/my_images.dart';
import 'package:mobility_one/util/my_localization.dart';

class DataTableAddItemWidget extends StatelessWidget {
  final VoidCallback onPressed;
  const DataTableAddItemWidget({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Tooltip(
          message: MyLocalization.of(context)!.createPerson,
          child: Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: MyColors.mobilityOneBlackColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: SvgPicture.asset(
                MyImages.dataTableAddItemPlusIcon,
                width: 16,
                height: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
