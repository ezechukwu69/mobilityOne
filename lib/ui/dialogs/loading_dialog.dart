import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobility_one/ui/widgets/my_circular_progress_indicator.dart';

class LoadingDialog extends StatelessWidget {
  const LoadingDialog(
      {Key? key,
      this.scale,
      this.blur = 2.0,
      this.aboveChild,
      this.belowChild,
      this.backgroundColor})
      : super(key: key);

  final double? scale;
  final double blur;
  final Color? backgroundColor;

  final Widget? aboveChild;
  final Widget? belowChild;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.black.withOpacity(0.6),
      resizeToAvoidBottomInset: false,
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Stack(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _showChild(aboveChild),
                Container(
                  alignment: Alignment.center,
                  child: MyCircularProgressIndicator(),
                ),
                _showChild(belowChild)
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _showChild(Widget? child) {
    if (child == null) {
      return Container();
    }
    return child;
  }
}
