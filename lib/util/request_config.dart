import 'dart:async' show Future, Stream;
import 'dart:convert' show jsonEncode, jsonDecode, utf8;
import 'package:universal_io/io.dart' show HttpClientResponse, ContentType;

import 'package:equatable/equatable.dart';
import 'package:html/dom.dart' show Document;
import 'package:html/parser.dart' as parser show parse;

enum RequestMethod { get, post, put, delete, patch }

class RequestBody {
  static _JsonRequest json(Map<String, dynamic> data) => _JsonRequest(data);
  static _FormDataRequest formData(Map<String, dynamic> data) =>
      _FormDataRequest(data);
}

class ResponseBody {
  static _JsonResponse json() => _JsonResponse();
  static _DocumentResponse document() => _DocumentResponse();
}

class Config extends Equatable {
  const Config({
    RequestMethod? method,
    this.uri,
    this.body,
    this.responseType,
    this.headers = const <String, dynamic>{},
    this.cookies = const <String, dynamic>{},
  }) : _method = method;

  final RequestMethod? _method;
  final Uri? uri;
  final _RequestBodyType? body;
  final _ResponseBodyType? responseType;
  final Map<String, dynamic>? headers;
  final Map<String, dynamic> cookies;

  void addHeader(String name, Object value) => headers!['$name'] = value;

  void addCookie(String name, Object value) => cookies['$name'] = value;

  String get method => _getMethod();
  bool get hasResponse => responseType != null;
  bool get hasBody => body != null;
  bool get hasHeader => headers?.isNotEmpty == true;

  String _getMethod() {
    switch (_method) {
      case RequestMethod.post:
        return 'POST';
      case RequestMethod.put:
        return 'PUT';
      case RequestMethod.get:
        return 'GET';
      case RequestMethod.delete:
        return 'DELETE';
      case RequestMethod.patch:
        return 'PATCH';
      default:
        return 'UNKNOWN';
    }
  }

  @override
  List<Object?> get props => [_method, uri, body, responseType, headers, cookies];
}

abstract class _RequestBodyType {
  ContentType getContentType();
  String getBody();
}

class _JsonRequest extends _RequestBodyType {
  final Map<String, dynamic> json;

  _JsonRequest(this.json);

  @override
  ContentType getContentType() =>
      ContentType('application', 'json', charset: 'utf-8');

  @override
  String getBody() => jsonEncode(json);
}

class _FormDataRequest extends _RequestBodyType {
  final Map<String, dynamic> formData;

  _FormDataRequest(this.formData);

  @override
  ContentType getContentType() =>
      ContentType('application', 'x-www-form-urlencoded', charset: 'utf-8');

  @override
  String getBody() =>
      formData.keys.map((dynamic key) => '$key=${formData[key]}').join('&');
}

abstract class _ResponseBodyType {
  String getAcceptHeader() => 'Accept';
  String getAcceptValue();
  dynamic parse(HttpClientResponse response);
}

class _JsonResponse extends _ResponseBodyType {
  @override
  String getAcceptValue() => 'application/json';

  @override
  Future<dynamic> parse(HttpClientResponse response) async =>
      jsonDecode(await utf8.decodeStream(response));
}

class _DocumentResponse extends _ResponseBodyType {
  @override
  String getAcceptValue() => 'text/html';

  @override
  Future<Document> parse(HttpClientResponse response) async =>
      parser.parse(await response
          .asyncExpand((List<int> bytes) => Stream<int>.fromIterable(bytes))
          .toList());
}
