import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_mold/log/logger.dart';

class Network {
  static Network _instance;

  static Network _getInstance() {
    if (_instance == null) {
      Dio dio = Dio();
      dio.options.connectTimeout = 30 * 1000;
      if (!kReleaseMode) {
        dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
      }
      if (!kIsWeb) {
        (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
          client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
          return client;
        };
      }
      _instance = Network(dio);
    }
    return _instance;
  }

  final Dio _dio;

  Network(this._dio);

  static _NetworkBuilder post(String url, String uri) {
    final _url = url.endsWith("/") ? url : "$url/";
    final _uri = uri.startsWith("/") ? uri.substring(1) : uri;
    return _NetworkBuilder(_url, _uri, "POST");
  }

  static _NetworkBuilder delete(String url, String uri) {
    final _url = url.endsWith("/") ? url : "$url/";
    final _uri = uri.startsWith("/") ? uri.substring(1) : uri;
    return _NetworkBuilder(_url, _uri, "DELETE");
  }

  static _NetworkBuilder get(String url, String uri) {
    final _url = url.endsWith("/") ? url : "$url/";
    final _uri = uri.startsWith("/") ? uri.substring(1) : uri;
    return _NetworkBuilder(_url, _uri, "GET");
  }

  Future<String> _go(_NetworkBuilder builder) async {
    final Response<String> _result = await _response(builder);
    return _result.data;
  }

  Future<Response<T>> _response<T>(_NetworkBuilder builder) async {
    String uniqueValue = builder.unique();
    Log.debug("======================\n$uniqueValue\n======================");

    dynamic data = {};
    if (builder._files.isNotEmpty) {
      final paramBody = builder._body is String ? builder._body : json.encode(builder._body ?? {});
      data = FormData.fromMap({"param": paramBody, "files": builder._files});
    } else if (builder._body != null) {
      data = builder._body;
    }

    _dio.options.connectTimeout = builder._connectionTimeout ?? (30 * 1000);

    return _dio.request("${builder.url}${builder.uri}",
        queryParameters: builder._param,
        options: Options(
          method: builder.method,
          headers: builder._header,
          sendTimeout: builder._connectionTimeout ?? (30 * 1000),
          receiveTimeout: builder._connectionTimeout ?? (30 * 1000),
        ),
        cancelToken: builder._cancelToken,
        onReceiveProgress: builder._onReceiveProgress,
        onSendProgress: builder._onSendProgress,
        data: data);
  }
}

class _NetworkBuilder {
  final String url;
  final String uri;
  final String method;

  int _connectionTimeout;

  final Map<String, String> _param = {};
  final Map<String, String> _header = {};
  final List<MultipartFile> _files = [];

  dynamic _body;

  ProgressCallback _onSendProgress;
  ProgressCallback _onReceiveProgress;
  CancelToken _cancelToken;

  _NetworkBuilder(this.url, this.uri, this.method);

  String unique() {
    if (_files.isEmpty) {
      String value = "$url$uri";

      final params = (_param.keys.toList()..sort((l, r) => l.compareTo(r))).map((k) => "$k-${_param[k]}").join(",");

      final headers = (_header.keys.toList()..sort((l, r) => l.compareTo(r))).map((k) => "$k-${_header[k]}").join(",");

      String bodyValue = _body is String ? _body : json.encode(_body);
      return ([value, params, headers, bodyValue]..removeWhere((e) => e.isEmpty)).join(",").trim();
    } else {
      return DateTime.now().millisecondsSinceEpoch.toString();
    }
  }

  _NetworkBuilder param(String key, String value) {
    ArgumentError.checkNotNull(key, 'key');
    ArgumentError.checkNotNull(value, 'value');
    _param[key] = value;
    return this;
  }

  _NetworkBuilder headerToken(String token) {
    return header("token", token);
  }

  _NetworkBuilder header(String key, String value) {
    ArgumentError.checkNotNull(key, 'key');
    ArgumentError.checkNotNull(value, 'value');
    _header[key] = value;
    return this;
  }

  _NetworkBuilder body(dynamic body) {
    ArgumentError.checkNotNull(body, 'body');
    if (_body != null) {
      print("=================================\n" +
          "$uri BODY CHANGES\n" +
          "$_body TO $body\n" +
          "=================================");
    }

    if (body is Map) {
      final _data = <String, dynamic>{};
      _data.addAll(body);
      _data.removeWhere((key, value) => value == null);
      _body = _data;
    } else if (body is List) {
      _body = body;
    } else if (body is String) {
      _body = body;
    } else {
      _body = body.toJson();
    }
    return this;
  }

  _NetworkBuilder file(MultipartFile file) {
    ArgumentError.checkNotNull(file, 'file');
    header("BiruniUpload", "param");
    _files.add(file);
    return this;
  }

  _NetworkBuilder cancelToken(CancelToken cancelToken) {
    ArgumentError.checkNotNull(cancelToken, 'cancelToken');
    _cancelToken = cancelToken;
    return this;
  }

  _NetworkBuilder receiveProgress(ProgressCallback progress) {
    ArgumentError.checkNotNull(progress, 'progress');
    _onReceiveProgress = progress;
    return this;
  }

  _NetworkBuilder sendProgress(ProgressCallback progress) {
    ArgumentError.checkNotNull(progress, 'progress');
    _onSendProgress = progress;
    return this;
  }

  _NetworkBuilder files(List<MultipartFile> files) {
    ArgumentError.checkNotNull(files, 'files');
    if (_files.isNotEmpty) {
      print("=================================\n" +
          "${_files.length} FILES CHANGES\n" +
          "${_files.length} TO ${files.length}" +
          "=================================");
      _files.clear();
    }
    files.forEach((it) => file(it));
    return this;
  }

  _NetworkBuilder connectionTimeout(int timeout) {
    this._connectionTimeout = timeout;
    return this;
  }

  Future<String> go() async {
    return Network._getInstance()._go(this);
  }

  Future<Response<T>> response<T>() {
    return Network._getInstance()._response(this);
  }
}
