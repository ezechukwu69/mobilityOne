import 'package:flutter/material.dart';

class MyIconButton extends IconButton {
  MyIconButton(
      {required VoidCallback onPressed,
      required Icon icon,
      Color? splashColor,
      Color? hoverColor,
      required String tooltip})
      : super(
            tooltip: tooltip,
            icon: icon,
            onPressed: onPressed,
            splashColor: splashColor ?? Colors.transparent,
            hoverColor: hoverColor ?? Colors.transparent);
}
