import 'package:artiko/core/cache/domain/repositories/cache_storage_repository.dart';
import 'package:artiko/core/cache/keys/cache_keys.dart';
import 'package:artiko/core/http/domain/repositories/http_proxy_repository.dart';
import 'package:artiko/features/login/domain/entities/request/login_request.dart';
import 'package:artiko/features/login/domain/entities/response/login_response.dart';
import 'package:artiko/features/login/domain/repositories/login_repository_contract.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/exception.dart';

class LoginRepository implements LoginRepositoryContract {
  final HttpProxyInterface _httpImpl;
  final String _service;
  final CacheStorageInterface _cacheStorageInterface;

  LoginRepository(this._httpImpl, this._service, this._cacheStorageInterface);

  @override
  Future<LoginResponse> doLogin(LoginRequest loginRequest) async {
    final _http = _httpImpl.instance();

    try {
      final _response = await _http.get(
        '$_service/?usuario=${loginRequest.email}&password=${loginRequest.password}',
      );

      final response = LoginResponse.fromJson(_response.data["items"][0]);

      await _saveCurrentUser(response);
      await _getAndSaveUserPhoto(response);
      return response;
    } on DioError catch (e) {
      throw ServerException(e.message);
    } on Exception catch (_) {
      throw ServerException(
          'Ocurrió un error inesperado, por favor intente más tarde');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _saveCurrentUser(LoginResponse response) async {
    return await _cacheStorageInterface.save(
        key: CacheKeys.USER, value: loginResponseToJson(response));
  }

  Future<void> _getAndSaveUserPhoto(LoginResponse loginResponse) async {
    final _http = _httpImpl.instance();

    final _response = await _http.get(
      '${loginResponse.href}/foto',
    );

    print(_response);
    return await _cacheStorageInterface.save(
        key: CacheKeys.USER_PHOTO,
        value: _response.data
            .toString()
            .replaceAll('\n', '')
            .replaceAll('\r', ''));
  }
}
