import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:mobility_one/util/auth_util.dart';
import 'package:universal_io/io.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';

import 'package:mobility_one/util/my_localization.dart';
import 'package:mobility_one/util/request_config.dart';
import 'mobility_one_app.dart';

class ApiClient {
  final HttpClient client = HttpClient();
  final Connectivity _connectivity = Connectivity();
  String get server => MobilityOneApp.server;

  Map<String, String> getDefaultHeaders({bool includeAuthorizationHeader = true}) {
    final defaultHeaders = <String, String>{};

    final isLoggedIn = MobilityOneApp.localStorage.isLoggedIn;
    final hasClientToken = MobilityOneApp.localStorage.hasClientToken;
    print('Is logged in: ${isLoggedIn}');
    if ((isLoggedIn || hasClientToken) && includeAuthorizationHeader) {
      final credentials = isLoggedIn ? MobilityOneApp.localStorage.credentials! : MobilityOneApp.localStorage.appCredentials!;
      print('Token ${credentials.accessToken}');
      defaultHeaders.addAll(
        <String, String>{
          'Authorization': 'Bearer ${credentials.accessToken}',
        },
      );
    }

    return defaultHeaders;
  }

  Future<ConnectivityResult> _checkConnectivity() async {
    ConnectivityResult connectivityResult;
    try {
      connectivityResult = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      connectivityResult = ConnectivityResult.none;
    }
    return connectivityResult;
  }

  Future<bool> isConnectionAvailable() async {
    return await _checkConnectivity() != ConnectivityResult.none;
  }

  Future<bool> checkCredentials() async {
    log('Checking credentials...');
    if (MobilityOneApp.localStorage.isLoggedIn) {
      final credentials = MobilityOneApp.localStorage.credentials!;
      if (credentials.isExpired) {
        log('Credentials expired, refreshing...');
        try {
          final newCredentials = await credentials.refresh(identifier: AuthUtil.clientId);
          await MobilityOneApp.localStorage.setCredentials(newCredentials);
        } catch (_) {
          return false;
        }
      }
    }
    return true;
  }

  /// Use this instead of [getAction], [postAction] and [putAction]
  Future<T?> request<T>(Config config, {bool includeAuthorizationHeader = true}) async {
    if (await isConnectionAvailable() != true) {
      return Future<T>.error(MobilityOneError(config: config, errorType: ErrorType.noConnection));
    }
    if (!await checkCredentials()) {
      return Future<T>.error(MobilityOneError(errorType: ErrorType.tokenExpired));
    }

    print(
        '[${config.method}] Sending request: ${config.uri.toString()} with body: ${config.body?.getBody()}');

    final _request = await client
        .openUrl(config.method, config.uri!)
        .then((HttpClientRequest request) =>
            _addHeaders(request, config, includeAuthorizationHeader: includeAuthorizationHeader))
        .then((HttpClientRequest request) => _addCookies(request, config))
        .then((HttpClientRequest request) => _addBody(request, config));

    final _response = await _request.close();

    print(
        '[${config.method}] Received: ${_response.reasonPhrase} [${_response.statusCode}] - ${config.uri.toString()}');

    if (_response.statusCode >= 200 && _response.statusCode < 300) {
      try {
        return config.hasResponse
            ? Future<T>.value(config.responseType!.parse(_response))
            : Future<HttpClientResponse>.value(_response) as FutureOr<T?>;
      } catch (e) {
        return Future<T>.value(null);
      }
    }

    return await (_processError(_response, config));
  }

  HttpClientRequest _addBody(HttpClientRequest request, Config config) {
    if (config.hasBody) {
      request.headers.contentType = config.body!.getContentType();
      request.contentLength = const Utf8Encoder().convert(config.body!.getBody()).length;
      request.write(config.body!.getBody());
    }

    return request;
  }

  HttpClientRequest _addCookies(HttpClientRequest request, Config config) {
    config.cookies.forEach((String key, dynamic value) =>
        value is Cookie ? request.cookies.add(value) : request.cookies.add(Cookie(key, value)));

    return request;
  }

  HttpClientRequest _addHeaders(HttpClientRequest request, Config config,
      {bool includeAuthorizationHeader = true}) {
    // Add default headers
    getDefaultHeaders(includeAuthorizationHeader: includeAuthorizationHeader)
        .forEach((String key, dynamic value) => request.headers.add(key, value));

    // Add config headers
    config.headers!.forEach((String key, dynamic value) => request.headers.add(key, value));

    return request;
  }

  Future<dynamic> _processError(HttpClientResponse response, Config config) async {
    final error = await MobilityOneError.parseError(response, config);
    return Future<dynamic>.error(error);
  }
}

class MobilityOneError extends Equatable {
  MobilityOneError(
      {this.reasonPhrase,
      this.httpStatusCode,
      this.errorJson,
      this.config,
      required this.errorType});

  final Config? config;
  final String? reasonPhrase;
  final int? httpStatusCode;
  final Map<String, dynamic>? errorJson;
  final ErrorType errorType;

  String getErrorString(MyLocalization myLocalization) {
    if (errorType == ErrorType.noConnection) {
      return myLocalization.noConnection;
    } else if (errorType == ErrorType.badGateway || errorType == ErrorType.internalServerError) {
      return myLocalization.serverError;
    } else if (errorType == ErrorType.tokenExpired) {
      return myLocalization.tokenExpiredError;
    } else {
      final _presentableError = StringBuffer();
      try {
        if (errorJson?.containsKey('errors') == true) {
          final List<dynamic>? errors = errorJson!['errors'];

          _presentableError.writeAll(errors!.map<String>((dynamic e) => '${e['message']}'), '\n');
        } else {
          _presentableError.writeln(myLocalization.genericErrorMessage);
        }

        print('Error: ${errorType.toString()}');
      } catch (exception) {
        print('Exception processing error: $exception');

        if (MobilityOneApp.isInDebugMode) {
          _presentableError.writeln('$httpStatusCode - $reasonPhrase');
          _presentableError.writeln(' --- ');
          _presentableError.writeln(errorJson);
        }
      }
      return _presentableError.toString();
    }
  }

  static Future<ErrorType> getErrorType(
      {int? httpStatusCode,
      String? reasonPhrase,
      Map<String, dynamic>? errorJson,
      Config? config}) async {
    print('Processing error : [$httpStatusCode] - $reasonPhrase');
    ErrorType errorType;
    switch (httpStatusCode) {

      /// Bad gateway. Usually means there is server fix/deploy on the way.
      case 401:
        errorType = ErrorType.unauthorized;
        break;
      case 500:
        errorType = ErrorType.internalServerError;
        break;
      case 502:
        errorType = ErrorType.badGateway;
        break;
      case 400:
        errorType = ErrorType.badRequest;
        break;
      case 403:
        errorType = ErrorType.forbidden;
        break;
      case 404:
        errorType = ErrorType.notFound;
        break;
      default:
        errorType = ErrorType.unknown;

        print('UNKNOWN ERROR! $httpStatusCode - [$reasonPhrase]');
        print('URL: ${config!.uri.toString()}');
        print('Headers: ${config.headers.toString()}');
        print('Body: ${config.body?.getBody()}');
        print('Data json: ${errorJson ?? ''}');
        break;
    }
    return errorType;
  }

  static Future<MobilityOneError> parseError(HttpClientResponse response, Config config) async {
    final _responseData = await utf8.decodeStream(response);
    Map<String, dynamic>? errorJson;
    try {
      errorJson = jsonDecode(_responseData);
    } catch (e) {
      print('error decoding response data: $_responseData');
    }
    final errorType = await MobilityOneError.getErrorType(
        config: config,
        errorJson: errorJson,
        httpStatusCode: response.statusCode,
        reasonPhrase: response.reasonPhrase);
    final error = MobilityOneError(
        config: config,
        errorJson: errorJson,
        httpStatusCode: response.statusCode,
        reasonPhrase: response.reasonPhrase,
        errorType: errorType);
    return Future<MobilityOneError>.value(error);
  }

  @override
  List<Object?> get props => [errorType, httpStatusCode, reasonPhrase, errorJson, config];

  @override
  bool get stringify => true;
}

enum ErrorType {
  badGateway,
  badRequest,
  unauthorized,
  tokenExpired,
  unknown,
  noConnection,
  internalServerError,
  forbidden,
  notFound
}
