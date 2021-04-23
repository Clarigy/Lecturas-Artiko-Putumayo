import 'package:artiko/core/http/domain/repositories/http_proxy_repository.dart';
import 'package:artiko/features/login/data/data_sources/local/current_user_dao.dart';
import 'package:artiko/features/login/domain/entities/request/login_request.dart';
import 'package:artiko/features/login/domain/entities/response/login_response.dart';
import 'package:artiko/features/login/domain/repositories/login_repository_contract.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/exception.dart';

class LoginRepository implements LoginRepositoryContract {
  final HttpProxyInterface _httpImpl;
  final String _service;
  final CurrentUserDao currentUserDao;

  LoginRepository(this._httpImpl, this._service, this.currentUserDao);

  @override
  Future<LoginResponse> doLogin(LoginRequest loginRequest) async {
    final _http = _httpImpl.instance();

    try {
      final _response = await _http.get(
        '$_service/${loginRequest.email}/${loginRequest.password}',
      );
      final response = LoginResponse.fromJson(_response.data);
      _saveCurrentUser(response);
      return response;
    } on DioError catch (e) {
      throw ServerException(e.message);
    } on Exception catch (_) {
      throw ServerException(
          'Ocurrió un error inesperado, por favor intente más tarde');
    }
  }

  Future<void> _saveCurrentUser(LoginResponse response) async {
    return await currentUserDao.insert(response);
  }
}
