import 'package:flutter/material.dart';
import 'package:mobility_one/ui/widgets/my_circular_progress_indicator.dart';
import 'package:mobility_one/util/my_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Material(
      color: MyColors.backgroundColor,
      child: MyCircularProgressIndicator(),
    );;
  }
}
