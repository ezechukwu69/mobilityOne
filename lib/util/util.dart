import 'dart:math';
import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobility_one/blocs/authentication_cubit/authentication_cubit.dart';
import 'package:mobility_one/ui/dialogs/loading_dialog.dart';
import 'package:mobility_one/ui/dialogs/mobility_one_dialog.dart';
import 'package:mobility_one/ui/widgets/cancel_button.dart';
import 'package:mobility_one/ui/widgets/confirm_button.dart';
import 'package:mobility_one/util/mobility_one_app.dart';
import 'package:mobility_one/util/my_colors.dart';
import 'package:mobility_one/util/my_localization.dart';
import 'package:mobility_one/util/my_text_styles.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sentry/sentry.dart' as sentry;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:mobility_one/util/api_client.dart';
import 'package:universal_io/io.dart';
import '../ui/dialogs/dialog_route.dart' as dialog_route;

class Util {
  static MaterialPageRoute<T> buildRoute<T>(Widget page) {
    return MaterialPageRoute<T>(builder: (BuildContext context) => page);
  }

  static Future<T?> showMyDialog<T>({
    required BuildContext context,
    bool barrierDismissible = true,
    bool barrierColorTransparent = false,
    required Widget child,
  }) {
    return Navigator.of(context, rootNavigator: true).push(
      dialog_route.DialogRoute<T>(
        child: child,
        theme: Theme.of(context),
        barrierDismissible: barrierDismissible,
        barrierColor:
            barrierColorTransparent ? null : Colors.black.withOpacity(0.2),
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
      ),
    );
  }

  static Future<T?> showSuccessDialog<T>(BuildContext context,
      {String? title, required String description}) async {
    final _title = title ?? MyLocalization.of(context)!.genericSuccessMessage;
    return await Util.showMyDialog(
      context: context,
      child: MobilityOneDialog(
        title: _title,
        message: description,
      ),
    );
  }

  static Future<T?> showConfirmDialog<T>(BuildContext context,
      {String? title, String? message, required VoidCallback onConfirm}) async {
    Navigator.popUntil(
        context, (Route<dynamic> route) => route is! dialog_route.DialogRoute);
    return await Util.showMyDialog(
      context: context,
      child: MobilityOneDialog(
        title: title!,
        message: message!,
        additionalWidget: SizedBox(
          child: Row(children: [
            Expanded(
                child: CupertinoButton(
              onPressed: () {
                onConfirm();
                dismissDialog(context);
              },
              child: Text(MyLocalization.of(context)!.confirm),
            )),
            Expanded(
                child: CupertinoButton(
              onPressed: () {
                dismissDialog(context);
              },
              child: Text(MyLocalization.of(context)!.cancel),
            ))
          ]),
        ),
      ),
    );
  }

  static void showLoadingDialog(BuildContext context) {
    Util.showMyDialog<void>(
        barrierDismissible: false,
        context: context,
        child: const LoadingDialog());
  }

  static void dismissDialog(BuildContext context) {
    Navigator.of(context)
        .popUntil((Route<dynamic> route) => route is! dialog_route.DialogRoute);
  }

  static Future<T?> showErrorDialog<T>(BuildContext context,
      {String? title,
      String? description,
      dynamic error,
      StackTrace? stackTrace,
      bool removePreviousDialog = true}) async {
    if (removePreviousDialog) {
      Navigator.popUntil(context,
          (Route<dynamic> route) => route is! dialog_route.DialogRoute);
    }
    final _errorFromJson =
        _getErrorString(context, error: error, stackTrace: stackTrace);
    final _title = title ?? MyLocalization.of(context)!.genericErrorMessage;
    final _error = description ?? _errorFromJson;

    print('Showing error: $_title - $_error');

    return await showMyDialog(
      context: context,
      barrierDismissible: true,
      child: MobilityOneDialog(
        title: _title,
        message: _error,
      ),
    );
  }

  static Future<Null> captureError(dynamic exception, dynamic stackTrace,
      {String? caughtBy}) async {
    if (MobilityOneApp.isInDebugMode) {
      print('In dev mode. Not sending report to Sentry.io.');
      print('$caughtBy - ERROR: $exception');
      print(stackTrace);
      return;
    }
    final sentryId =
        await sentry.Sentry.captureException(exception, stackTrace: stackTrace);
    print('Success! Sentry ID: $sentryId');
  }

  static Future<Map<String, dynamic>> getExtraInfo() async {
    final extraData = await _getBrowserData()
      ..addAll(<String, String>{
        'flavour': MobilityOneApp().appFlavour.toString(),
        'server_url': MobilityOneApp.server
      })
      ..addAll(await getPackageInfo());
    return extraData;
  }

  static Future<Map<String, dynamic>> getPackageInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return <String, dynamic>{
      'app.appName': packageInfo.appName,
      'app.packageName': packageInfo.packageName,
      'app.version': packageInfo.version,
      'app.buildNumber': packageInfo.buildNumber
    };
  }

  static Future<Map<String, dynamic>> _getBrowserData() async {
    final browserData = <String, dynamic>{
      'Locale': Platform.localeName,
      'Host name': Platform.localHostname,
      'Version': Platform.version,
      'OS': '${Platform.operatingSystem} (${Platform.operatingSystemVersion})',
    };

    final deviceInfoPlugin = DeviceInfoPlugin();
    try {
      final webBrowserInfo = await deviceInfoPlugin.webBrowserInfo;
      browserData.addAll(_readWebBuildData(webBrowserInfo));
    } catch (e) {
      print('Error getting browser info: $e');
    }

    return Future<Map<String, dynamic>>.value(browserData);
  }

  static Map<String, dynamic> _readWebBuildData(WebBrowserInfo build) {
    return <String, dynamic>{
      'product': build.product,
    };
  }

  static String _getErrorString(BuildContext context,
      {required dynamic error, StackTrace? stackTrace}) {
    var _errorFromJson = '';
    if (error != null) {
      try {
        if (error is MobilityOneError) {
          _errorFromJson = error.getErrorString(MyLocalization.of(context)!);
        } else if (error is String) {
          _errorFromJson = error;
        } else {
          captureError(error, stackTrace);
        }
      } catch (exception) {
        print(exception);
      }
    }
    if (_errorFromJson.isEmpty) {
      _errorFromJson = MyLocalization.of(context)!.genericErrorMessage;
    }
    return _errorFromJson;
  }

  static Widget getErrorWidget(BuildContext context,
      {required dynamic error,
      StackTrace? stackTrace,
      TextStyle? textStyle,
      Color textColor = Colors.black,
      int maxLines = 10,
      VoidCallback? onRetry}) {
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                  _getErrorString(context,
                      error: error, stackTrace: stackTrace),
                  maxLines: maxLines,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: textStyle ??
                      Theme.of(context).textTheme.headline6!.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: textColor)),
              if (onRetry != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(24.0)),
                    onTap: error is MobilityOneError &&
                            error.errorType == ErrorType.tokenExpired
                        ? () => context
                            .read<AuthenticationCubit>()
                            .redirectToLoginPage()
                        : onRetry,
                    child: Icon(
                      Icons.refresh,
                      size: 44.0,
                      color: Colors.black,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<bool> hasNetworkConnection() async {
    ConnectivityResult connectivityResult;
    try {
      connectivityResult = await Connectivity().checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      connectivityResult = ConnectivityResult.none;
    }
    return connectivityResult != ConnectivityResult.none;
  }

  static const String _charset =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';

  static String createCodeVerifier() {
    return List.generate(
        128, (i) => _charset[Random.secure().nextInt(_charset.length)]).join();
  }

  static const double smallScreenWidth = 800;

  static Future<T?> rightSideBarDialog<T>(
    BuildContext context, {
    required List<Widget> children,
  }) async {
    //
    return showGeneralDialog(
      barrierLabel: 'Barrier',
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 300),
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Align(
          alignment: Alignment.centerRight,
          child: Material(
            child: Container(
              height: double.infinity,
              width: 300,
              decoration: BoxDecoration(
                color: MyColors.backgroundCardColor,
              ),
              child: Container(
                child: Column(children: children),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation1, animation2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(1, 0), end: Offset(0, 0)).animate(animation1),
          child: child,
        );
      },
    );
  }

  static Future<T?> showConfirmDialog2<T>(BuildContext context,
      {String? title, String? message, required VoidCallback onConfirm}) async {
    return showGeneralDialog(
      barrierLabel: 'Barrier',
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      // transitionDuration: Duration(milliseconds: 300),
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return Material(
          color: Colors.transparent,
          child: Align(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .5,
              ),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: MyColors.backgroundCardColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(19.0693),
                ),
                border: Border.all(color: Color(0xFF3A3A4E), width: 1),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null)
                    Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        '$title',
                        style: MyTextStyles.dataTableTitle,
                      ),
                    ),

                  if (message != null)
                    Container(
                      padding: const EdgeInsets.only(top: 10, bottom: 25),
                      child: Text(
                        '$message',
                        style: MyTextStyles.dataTableText,
                      ),
                    ),

                  //
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CancelButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(width: 10),
                      ConfirmButton(
                        onPressed: () {
                          onConfirm();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
