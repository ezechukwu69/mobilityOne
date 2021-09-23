import 'package:flutter/material.dart';
import 'package:mobility_one/util/my_colors.dart';
import 'package:mobility_one/util/my_text_styles.dart';

//Use this with SizedBox with fixed width
class MyPreviewDataTable extends StatelessWidget {
  const MyPreviewDataTable({
    required this.columns,
    required this.rows,
    required this.title,
    this.topRightWidget,
    this.bottomRightWidget,
  });
  final String title;
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final Widget? topRightWidget;
  final Widget? bottomRightWidget;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            color: MyColors.dataTableBackgroundColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 21, left: 41),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(title, style: MyTextStyles.dataTableTitle),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: topRightWidget ?? const SizedBox(),
                      )
                    ],
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.minWidth),
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 32, bottom: 26),
                      child: DataTable(
                        showBottomBorder: true,
                        columns: columns,
                        rows: rows,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 36,right: 32),
                      child: bottomRightWidget ?? const SizedBox(),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
