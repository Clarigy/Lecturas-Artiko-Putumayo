import 'package:artiko/core/cache/domain/repositories/cache_storage_repository.dart';
import 'package:dio/dio.dart';

import '../domain/repositories/http_proxy_repository.dart';
import 'auth/authentication_impl.dart';
import 'interceptors/interceptor.dart';

class HttpProxyImpl extends HttpProxyInterface {
  var _http;
  final String baseUrl;
  final CacheStorageInterface _storage;

  HttpProxyImpl(this.baseUrl, this._storage) {
    _http = Dio()
      ..interceptors.add(AppInterceptors(AuthenticationImpl(_storage)))
      ..options.connectTimeout = 30000
      ..options.receiveTimeout = 30000
      ..options.sendTimeout = 3000
      ..options.baseUrl = baseUrl;
  }

  @override
  Dio instance() => _http;
}
