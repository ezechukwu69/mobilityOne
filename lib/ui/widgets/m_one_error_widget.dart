import 'package:flutter/material.dart';
import 'package:mobility_one/util/my_colors.dart';

class MOneErrorWidget extends StatelessWidget {
  const MOneErrorWidget({
    Key? key,
    this.errorText,
  }) : super(key: key);

  final String? errorText;
  final String genericMessage = 'Something went wrong, please try again';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        errorText != null ? '$errorText' : '$genericMessage',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          color: MyColors.white,
          fontSize: 30,
        ),
      ),
    );
  }
}
