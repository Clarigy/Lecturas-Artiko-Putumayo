import 'dart:developer';

import 'package:artiko/core/http/domain/exceptions/auth_exception.dart';
import 'package:artiko/core/http/domain/repositories/authentication_repository.dart';
import 'package:artiko/core/http/domain/responses/token_auth_response.dart';
import 'package:dio/dio.dart';

Future<RequestOptions> customOnRequest(
    RequestOptions options, AuthenticationInterface authentication) async {
  _printInfoRequest(options);

  TokenAuthResponse? _token;

  try {
    final _tokenStorage = await authentication.tokenStorage;

    if (_tokenStorage != null) {
      //valid token expired
      if (authentication.tokenExpired(_tokenStorage)) {
        log('token expirado');
        try {
          _token = await authentication.tokenAuthCreate();
        } on AuthException {
          _token = await authentication.tokenAuthCreate();
        } finally {
          // ignore: throw_in_finally
          if (_token == null) throw AuthException('Error al asignar el token');

          await authentication.setTokenStorage(_token);
        }
      } else {
        _token = _tokenStorage;
      }
    } else {
      _token = await authentication.tokenAuthCreate();
      await authentication.setTokenStorage(_token);
      log('token Create');
    }

    return _setHeaders(options, _token, authentication);
  } catch (e) {
    rethrow;
  }
}

Future<RequestOptions> _setHeaders(RequestOptions options,
    TokenAuthResponse token, AuthenticationInterface authentication) async {
  final _headers = await _getCustomHeaders(token, authentication);
  options.headers.addAll(_headers);
  return options;
}

Future<Map<String, dynamic>> _getCustomHeaders(
    TokenAuthResponse token, AuthenticationInterface authentication) async {
  return {'authorization': '${token.tokenType} ${token.accessToken}'};
}

void _printInfoRequest(RequestOptions options) {
  log('method: ${options.method}  headers: ${options.headers}');
  log('baseURL: ${options.baseUrl} path: ${options.path}');
  log('queryParameters: ${options.queryParameters}');
  log('data : ${options.data.toString()}');
}
