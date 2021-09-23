import 'package:flutter/material.dart';
import 'package:mobility_one/util/my_colors.dart';

class MySimpleCircularProgressIndicator extends StatelessWidget {
  const MySimpleCircularProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: MyColors.accentColor,
      ),
    );
  }
}
