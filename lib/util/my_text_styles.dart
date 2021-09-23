import 'package:flutter/cupertino.dart';
import 'package:mobility_one/util/my_colors.dart';

class MyTextStyles {
  MyTextStyles._();

  static const TextStyle dataTableTitle = TextStyle(
      fontSize: 18, color: MyColors.white, fontWeight: FontWeight.bold);

  static const TextStyle dataTableHeading = TextStyle(
      fontSize: 14,
      color: MyColors.dataTableHeadingTextColor,
      fontWeight: FontWeight.bold);

  static const TextStyle dataTableText = TextStyle(
      fontSize: 14, color: MyColors.white, fontWeight: FontWeight.normal);

  static const TextStyle dataTableViewAll = TextStyle(
      fontSize: 10,
      color: MyColors.dataTableHeadingTextColor,
      fontWeight: FontWeight.bold);
  static TextStyle appBarTitle =
      TextStyle(fontSize: 14, color: MyColors.textTitleColor);
  static TextStyle draggablecardtext = TextStyle(
      fontSize: 14,
      color: MyColors.backgroundColor,
      decoration: TextDecoration.none);

  static const TextStyle h1Style = TextStyle(
    fontSize: 18,
    color: MyColors.white,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle h2Style = TextStyle(
    fontSize: 15,
    color: MyColors.white,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle pStyle = TextStyle(
    // fontSize: 12,
    color: MyColors.white,
  );
}
