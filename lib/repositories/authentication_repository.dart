import 'package:mobility_one/util/api_calls.dart';
import 'package:mobility_one/util/local_storage.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

class AuthenticationRepository {
  final LocalStorage localStorage;
  final ApiCalls api;
  AuthenticationRepository({required this.localStorage, required this.api});

  Future<void> setCredentials(oauth2.Credentials credentials) async {
    return await localStorage.setCredentials(credentials);
  }

  Future<void> setAppCredentials(oauth2.Credentials credentials) async {
    return await localStorage.setAppCredentials(credentials);
  }

  Future<oauth2.Credentials?> getCredentials() async {
    return await localStorage.getCredentials();
  }

  Future<void> userInfoEndpoint() async {
    return await api.userInfoEndpoint();
  }

  Future<void> setGrantCodeVerifier({required String codeVerifier}) async {
    return await localStorage.setGrantCodeVerifier(codeVerifier);
  }

  Future<String?> getGrantCodeVerifier() async {
    return await localStorage.getGrantCodeVerifier();
  }

  Future<void> deleteGrantCodeVerifier() async {
    return await localStorage.deleteGrantCodeVerifier();
  }

  Future<void> deleteCredentials() async {
    return await localStorage.deleteCredentials();
  }
}
