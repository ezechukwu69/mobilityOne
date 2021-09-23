import 'package:flutter/material.dart';
import 'package:mobility_one/util/my_localization.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(MyLocalization.of(context)!.notFound),
    );
  }
}
