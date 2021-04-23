import 'dart:developer';

import 'package:dio/dio.dart';

void customOnRequest(RequestOptions options) {
  _printInfoRequest(options);
}

void _printInfoRequest(RequestOptions options) {
  log('method: ${options.method}  headers: ${options.headers}');
  log('baseURL: ${options.baseUrl} path: ${options.path}');
  log('queryParameters: ${options.queryParameters}');
  log('data : ${options.data.toString()}');
}
