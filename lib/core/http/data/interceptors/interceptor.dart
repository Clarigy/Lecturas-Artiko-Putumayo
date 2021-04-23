import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';

import 'custom_onError.dart';
import 'custom_onRequest.dart';

class AppInterceptors extends Interceptor {
  @override
  void onRequest(
          RequestOptions options, RequestInterceptorHandler handler) =>
       customOnRequest(options);

  @override
  Future<FutureOr> onError(
          DioError dioError, ErrorInterceptorHandler handler) =>
      customOnError(dioError);

  @override
  Future<dynamic> onResponse(
          Response response, ResponseInterceptorHandler handler) async =>
      log(response.toString());
}
