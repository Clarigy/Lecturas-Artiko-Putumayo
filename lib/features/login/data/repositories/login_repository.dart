import 'package:artiko/core/http/domain/repositories/http_proxy_repository.dart';
import 'package:artiko/features/login/domain/entities/request/login_request.dart';
import 'package:artiko/features/login/domain/entities/response/login_response.dart';
import 'package:artiko/features/login/domain/repositories/login_repository_contract.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/exception.dart';

class LoginRepository implements LoginRepositoryContract {
  final HttpProxyInterface _httpImpl;
  final String _service;

  LoginRepository(this._httpImpl, this._service);

  @override
  Future<LoginResponse> doLogin(LoginRequest loginRequest) async {
    final _http = _httpImpl.instance();

    try {
      final _response = await _http.get(
        '$_service/${loginRequest.email}/${loginRequest.password}',
      );
      return LoginResponse.fromJson(_response.data);
    } on DioError catch (e) {
      throw ServerException(e.message);
    } on Exception catch (e) {
      throw ServerException(
          'Ocurrió un error inesperado, por favor intente más tarde');
    }
  }
}
