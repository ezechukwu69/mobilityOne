import 'package:flutter/widgets.dart';
import 'package:mobility_one/util/util.dart';
import 'package:sentry/sentry.dart';

import 'api_calls.dart';
import 'local_storage.dart';

enum Flavour { production, development, stage }

class MobilityOneApp {
  MobilityOneApp._internal();

  factory MobilityOneApp() {
    return _mobilityOneApp;
  }

  static final MobilityOneApp _mobilityOneApp = MobilityOneApp._internal();
  static late Flavour _flavour;
  static late ApiCalls api;
  static late LocalStorage localStorage;

  static Future<void> configure(Flavour flavour) async {
    WidgetsFlutterBinding.ensureInitialized();

    print('Configuring app with: ${flavour.toString()}');
    _flavour = flavour;

    localStorage = LocalStorage();
    api = ApiCalls(localStorage: LocalStorage());

    await Sentry.init((options) {
      options.dsn = sentryDns;
    });
    Sentry.configureScope((scope) async {
      scope.setContexts('extra', await Util.getExtraInfo());
    });
  }

  Flavour? get appFlavour => _flavour;

  static Iterable<String> get scopes {
    switch (_flavour) {
      case Flavour.stage:
        return ['openid', 'profile', 'offline_access'];
      case Flavour.production:
        return ['openid', 'profile', 'offline_access'];
      default:
        return ['openid', 'profile', 'offline_access'];
    }
  }

  static Uri get logoutRedirectUrl {
    switch (_flavour) {
      case Flavour.stage:
        return Uri.parse('http://localhost:8080');
      case Flavour.production:
        return Uri.parse('https://app.mobilityone.io');
      default:
        return Uri.parse('http://localhost:8080');
    }
  }

  static Uri get redirectUrl {
    switch (_flavour) {
      case Flavour.stage:
        return Uri.parse('http://localhost:8080');
      case Flavour.production:
        return Uri.parse('https://app.mobilityone.io');
      default:
        return Uri.parse('http://localhost:8080');
    }
  }

  static String get clientId {
    switch (_flavour) {
      case Flavour.stage:
        return 'flutter1';
      case Flavour.production:
        return 'flutter2';
      default:
        return 'flutter1';
    }
  }

  static Uri get authorizationEndpoint {
    switch (_flavour) {
      case Flavour.stage:
        return Uri.parse('$sso/connect/authorize');
      case Flavour.production:
        return Uri.parse('$sso/connect/authorize');
      default:
        return Uri.parse('$sso/connect/authorize');
    }
  }

  static Uri get tokenEndpoint {
    switch (_flavour) {
      case Flavour.stage:
        return Uri.parse('$sso/connect/token');
      case Flavour.production:
        return Uri.parse('$sso/connect/token');
      default:
        return Uri.parse('$sso/connect/token');
    }
  }

  static Uri get sso {
    switch (_flavour) {
      case Flavour.stage:
        return Uri.parse('https://app.mobilityone.io:4700');
      case Flavour.production:
        return Uri.parse('https://app.mobilityone.io:4700');
      default:
        return Uri.parse('https://app.mobilityone.io:4700');
    }
  }

  static String get server {
    switch (_flavour) {
      case Flavour.stage:
        return 'https://app.mobilityone.io:4300';
      case Flavour.production:
        return 'https://app.mobilityone.io:4300';
      default:
        return 'https://app.mobilityone.io:4300';
    }
  }

  static String get server2 {
    switch (_flavour) {
      case Flavour.stage:
        return '';
      case Flavour.production:
        return 'https://app.mobilityone.io:6400';
      default:
        return 'https://app.mobilityone.io:6400';
    }
  }

  static String sentryDns =
      'https://2dcac204af9e4333ab2dcef8689f3a24@sentry.hot-soup.com/51';

  static bool get isInDebugMode {
    var inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }
}
