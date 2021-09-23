import 'package:mobility_one/util/mobility_one_app.dart';

class AuthUtil {
  AuthUtil._internal();
  factory AuthUtil() {
    return _authUtil;
  }
  static final AuthUtil _authUtil = AuthUtil._internal();

  static final sso = MobilityOneApp.sso;
  static final authorizationEndpoint = MobilityOneApp.authorizationEndpoint;
  static final tokenEndpoint = MobilityOneApp.tokenEndpoint;
  static final clientId = MobilityOneApp.clientId;
  static final redirectUrl = MobilityOneApp.redirectUrl;
  static final logoutRedirectUrl = MobilityOneApp.logoutRedirectUrl;
  static final Iterable<String> scopes = MobilityOneApp.scopes;
}
