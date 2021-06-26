import 'package:artiko/core/cache/domain/repositories/cache_storage_repository.dart';
import 'package:artiko/core/http/data/http_proxy_impl.dart';
import 'package:artiko/dependency_injector.dart';
import 'package:artiko/features/login/data/repositories/login_repository.dart';
import 'package:artiko/features/login/domain/use_cases/login_use_case.dart';
import 'package:artiko/features/login/presentation/manager/login_bloc.dart';

Future<void> setUpLoginProviders() async {
  sl.registerFactory(() => LoginRepository(
      sl<HttpProxyImpl>(), '/usuario', sl<CacheStorageInterface>()));

  sl.registerFactory(
      () => LoginUseCase(sl<LoginRepository>(), sl<CacheStorageInterface>()));

  sl.registerFactory(() => LoginBloc(sl<LoginUseCase>()));
}
