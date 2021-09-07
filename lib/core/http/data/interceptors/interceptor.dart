import 'dart:async';
import 'dart:developer';

import 'package:artiko/core/http/domain/repositories/authentication_repository.dart';
import 'package:dio/dio.dart';

import 'custom_onError.dart';
import 'custom_onRequest.dart';

class AppInterceptors extends Interceptor {
  final AuthenticationInterface authentication;

  AppInterceptors(this.authentication);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final reqOptions = await customOnRequest(options, authentication);
    return handler.next(reqOptions);
  }

  @override
  Future onError(DioError dioError, ErrorInterceptorHandler handler) async {
    final customError = await customOnError(dioError);
    return handler.next(customError);
  }

  @override
  Future<dynamic> onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    log(response.toString());
    return handler.next(response);
  }
}
