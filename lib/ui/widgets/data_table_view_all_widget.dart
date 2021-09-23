import 'package:flutter/cupertino.dart';
import 'package:mobility_one/util/my_colors.dart';
import 'package:mobility_one/util/my_localization.dart';
import 'package:mobility_one/util/my_text_styles.dart';

class DataTableViewAllWidget extends StatelessWidget {
  final VoidCallback onPressed;
  const DataTableViewAllWidget({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                MyLocalization.of(context)!.viewAll.toUpperCase(),
                style: MyTextStyles.dataTableViewAll,
              ),
              const SizedBox(height: 3,),
              Container(
                height: 1,
                width: 84,
                color: MyColors.mobilityOneLightGreenColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
