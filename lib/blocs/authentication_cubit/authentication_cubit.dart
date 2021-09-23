import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mobility_one/repositories/accounts_repository.dart';
import 'package:mobility_one/repositories/authentication_repository.dart';
import 'package:mobility_one/util/api_client.dart';
import 'package:mobility_one/util/auth_util.dart';
import 'package:mobility_one/util/util.dart';
import 'package:oauth2/oauth2.dart' as oauth2;

// import 'dart:html' as html;

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit(
      {required this.authenticationRepository,
      required this.accountsRepository})
      : super(AuthenticationInitial());
  final AuthenticationRepository authenticationRepository;
  final AccountsRepository accountsRepository;

  void onAppStart({required Uri currentUrl}) async {
    final credentials = await authenticationRepository.getCredentials();
    if (credentials != null && credentials.isExpired == false) {
      emit(AuthenticationAuthenticated(credentials: credentials));
    } else if (credentials != null && credentials.isExpired == true) {
      try {
        final newCredentials =
            await credentials.refresh(identifier: AuthUtil.clientId);
        await authenticationRepository.setCredentials(newCredentials);
        emit(AuthenticationAuthenticated(credentials: newCredentials));
      } catch (error) {
        await authenticationRepository.deleteCredentials();
        await authenticationRepository.deleteGrantCodeVerifier();
        log('Error refreshing credentials $error');
        emit(AuthenticationUnauthenticated());
      }
    } else {
      final grant = await getGrant();
      final queryParameters = currentUrl.queryParameters;
      if (queryParameters.containsKey('code')) {
        try {
          final client =
              await grant.handleAuthorizationResponse(queryParameters);
          await authenticationRepository.setCredentials(client.credentials);
          emit(AuthenticationAuthenticated(credentials: client.credentials));
          client.close();
        } catch (error) {
          await authenticationRepository.deleteCredentials();
          await authenticationRepository.deleteGrantCodeVerifier();
          log('Error checking the token $error');
          emit(AuthenticationUnauthenticated());
        }
      } else {
        // html.window.location.assign(authorizationUrl);
      }
    }
  }

  Future<oauth2.AuthorizationCodeGrant> getGrant() async {
    final savedCodeVerifier =
        await authenticationRepository.getGrantCodeVerifier();
    if (savedCodeVerifier != null) {
      final savedGrant = oauth2.AuthorizationCodeGrant(AuthUtil.clientId,
          AuthUtil.authorizationEndpoint, AuthUtil.tokenEndpoint,
          codeVerifier: savedCodeVerifier);
      await authenticationRepository.deleteGrantCodeVerifier();
      return savedGrant;
    }

    final newCodeVerifier = Util.createCodeVerifier();
    final newGrant = oauth2.AuthorizationCodeGrant(AuthUtil.clientId,
        AuthUtil.authorizationEndpoint, AuthUtil.tokenEndpoint,
        codeVerifier: newCodeVerifier);

    await authenticationRepository.setGrantCodeVerifier(
        codeVerifier: newCodeVerifier);
    return newGrant;
  }

  Future<void> redirectToLoginPage() async {
    final grant = await getGrant();
    final authorizationUrl = grant
        .getAuthorizationUrl(AuthUtil.redirectUrl, scopes: AuthUtil.scopes)
        .toString();
    // html.window.location.assign(authorizationUrl);
  }

  Future<void> makeLogin(
      {required String email, required String password}) async {
    try {
      emit(AuthenticationAuthenticating());
      final authorizationUrl = AuthUtil.tokenEndpoint;
      var client = await oauth2.resourceOwnerPasswordGrant(
          authorizationUrl, email, password,
          identifier: 'trusted-login', secret: 'trusted-secret');

      await authenticationRepository.setCredentials(client.credentials);
      final userName = await accountsRepository.getCurrentAccount();
      await accountsRepository.setUserName(userName);

      emit(AuthenticationAuthenticated(credentials: client.credentials));
      client.close();
    } catch (err) {
      print('err $err');
      emit(AuthenticationFailed());
    }
  }

  Future<void> signup(
      {required String email,
      required String password,
      required String name,
      required String companyName,
      required String accountName}) async {
    try {
      emit(AuthenticationSigningUp());
      final authorizationUrl = AuthUtil.tokenEndpoint;
      var client = await oauth2.clientCredentialsGrant(
          authorizationUrl, 'trusted-login', 'trusted-secret',
          scopes: ['IdentityServerApi', 'create-users']);
      await authenticationRepository.setAppCredentials(client.credentials);

      await accountsRepository.signUp(requestBody: {
        'Email': email,
        'FullName': name,
        'AccountName': accountName,
        'CompanyName': companyName,
        'Password': password
      });
      emit(AuthenticationSigningUpCompleted());
      await makeLogin(email: email, password: password);
    } catch (err) {
      print('Error');
      print((err as MobilityOneError));
      emit(AuthenticationSignUpFailed());
    }
  }

  Future<void> logout() async {
    final credentials = await authenticationRepository.getCredentials();
    if (credentials != null) {
      await authenticationRepository.deleteCredentials();
      await authenticationRepository.deleteGrantCodeVerifier();
    }
    emit(AuthenticationUnauthenticated());
  }
}
