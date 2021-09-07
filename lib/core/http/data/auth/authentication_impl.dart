import 'dart:convert';

import 'package:artiko/core/cache/domain/repositories/cache_storage_repository.dart';
import 'package:artiko/core/http/data/config/remote_api.dart';
import 'package:artiko/core/http/domain/exceptions/auth_exception.dart';
import 'package:artiko/core/http/domain/repositories/authentication_repository.dart';
import 'package:artiko/core/http/domain/responses/token_auth_response.dart';
import 'package:dio/dio.dart';

class AuthenticationImpl extends AuthenticationInterface {
  final CacheStorageInterface _storage;

  AuthenticationImpl(this._storage);

  Future<TokenAuthResponse> tokenAuthCreate() async {
    try {
      final _http = Dio(BaseOptions(
        baseUrl: ConfigRemoteApi.tokenBaseUrl,
        connectTimeout: 30000,
        sendTimeout: 3000,
        receiveTimeout: 3000,
        // receiveDataWhenStatusError: true,
      ));
      var _basicAuth = 'Basic ' +
          base64Encode(
              utf8.encode('893L1PCS3hHLh-kmkFpi3Q..:zhqaRU2KRSdWsU-3ML2uUg..'));

      var _headers = <String, dynamic>{
        'content-type': 'application/json',
        'accept': 'application/json',
        'authorization': _basicAuth,
        'Access-Control-Allow-Origin': '*'
      };

      var _params = <String, dynamic>{
        'grant_type': ConfigParamsToken.grantTypeCreate,
      };

      final _response = await _http.post(
        '',
        queryParameters: _params,
        options: Options(headers: _headers),
      );

      return TokenAuthResponse.fromJson({
        ..._response.data,
        ...{'created': DateTime.now().toString()}
      });
    } catch (_) {
      throw AuthException('Error no se pudo crear el Token Auth');
    }
  }

  bool tokenExpired(TokenAuthResponse token) {
    if (token.created.isEmpty) return true;

    final _dateTokenCreated = DateTime.parse(token.created);
    final _secondsOutSide = 5;
    final _dateTokenExpired = _dateTokenCreated
        .add(Duration(seconds: (token.expiresIn - _secondsOutSide)));
    return DateTime.now().isAfter(_dateTokenExpired);
  }

  Future<TokenAuthResponse?> get tokenStorage async {
    final _stringTokenAuth = await _storage.fetch('tokenAuth');
    if (_stringTokenAuth != null) {
      final Map<String, dynamic> _jsonToken = json.decode(_stringTokenAuth);
      var _token = TokenAuthResponse.fromJson(_jsonToken);
      return _token;
    }
    return null;
  }

  Future<void> setTokenStorage(TokenAuthResponse token) async {
    await _storage.delete('tokenAuth');
    await _storage.save(key: 'tokenAuth', value: json.encode(token.toJson()));
  }

  Future<String> get idUser async => await _storage.fetch('idUser');

  Future<String> get ip async => await _storage.fetch('ip');
}
