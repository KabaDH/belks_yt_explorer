import 'dart:developer';
import 'package:belks_tube/data/providers/app_config.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_provider.g.dart';

late final Dio _dio;

/// init this provider in main
@Riverpod(keepAlive: true)
Dio dio(DioRef ref) => _dio;

void initDio() {
  final options = BaseOptions(baseUrl: AppConfig.baseUrl);
  final dioInit = Dio(options);
  dioInit.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      await _setHeaders(options);
      return handler.next(options);
    },
    onResponse: (response, handler) async {
      final respString = response.toString();
      log(
          respString.substring(
            0,
            respString.length > 500 ? 500 : respString.length - 1,
          ),
          name: 'HTTP RESPONSE');
      return handler.next(response);
    },
    onError: _onError,
  ));

  final headers = {
    'Accept': 'application/json',
  };

  dioInit.options.headers = headers;

  _dio = dioInit;

  log('Init passed', name: 'Dio');
}

Future _onError(DioError e, handler) async {
  log('Dio._onError: ${e.response} / ${e.response?.statusCode}');
  final respNew = Response(
      requestOptions:
          e.response?.requestOptions ?? RequestOptions(path: 'unknown path'),
      data: <String, dynamic>{
        'status': false,
        'errors': e.toString(),
      });

  return handler.resolve(respNew);
}

Future _setHeaders(RequestOptions options) async {
  // options.queryParameters['key'] = AppConfig.apiKey;
}
