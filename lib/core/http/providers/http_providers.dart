import 'package:artiko/core/cache/domain/repositories/cache_storage_repository.dart';
import 'package:artiko/core/http/data/config/remote_api.dart';
import 'package:artiko/core/http/data/http_proxy_impl.dart';
import 'package:artiko/dependency_injector.dart';

Future<void> setUpHttpProviders() async {
  sl.registerFactory(() =>
      HttpProxyImpl(ConfigRemoteApi.baseUrl, sl<CacheStorageInterface>()));
}
