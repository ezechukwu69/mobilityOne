import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobility_one/app.dart';
import 'package:mobility_one/util/mobility_one_app.dart';
import 'package:mobility_one/util/util.dart';
import 'package:pedantic/pedantic.dart';

dynamic main() async {
  final currentUrl = Uri.base;
  unawaited(MobilityOneApp.configure(Flavour.production));

  FlutterError.onError = (FlutterErrorDetails details) {
    Util.captureError(details.exception, details.stack, caughtBy: 'FlutterError.onError');
  };

  runZonedGuarded(
    () => runApp(MyApp(currentUrl: currentUrl)),
    (dynamic error, StackTrace stackTrace) async {
      await Util.captureError(error, stackTrace, caughtBy: 'runZoned');
    },
  );
}
