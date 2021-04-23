import 'package:dio/dio.dart';

import '../domain/repositories/http_proxy_repository.dart';
import 'interceptors/interceptor.dart';

class HttpProxyImpl extends HttpProxyInterface {
  var _http;
  final String baseUrl;

  HttpProxyImpl(this.baseUrl) {
    _http = Dio()
      // ..interceptors.add(AppInterceptors())
      ..options.connectTimeout = 30000
      ..options.receiveTimeout = 30000
      ..options.sendTimeout = 3000
      ..options.baseUrl = baseUrl;
  }

  @override
  Dio instance() => _http;
}
