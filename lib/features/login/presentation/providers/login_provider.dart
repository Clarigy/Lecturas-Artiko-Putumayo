import 'package:artiko/core/cache/domain/repositories/cache_storage_repository.dart';
import 'package:artiko/core/http/data/config/remote_api.dart';
import 'package:artiko/core/http/data/http_proxy_impl.dart';
import 'package:artiko/dependency_injector.dart';
import 'package:artiko/features/login/data/data_sources/local/current_user_dao.dart';
import 'package:artiko/features/login/data/repositories/login_repository.dart';
import 'package:artiko/features/login/domain/use_cases/login_use_case.dart';
import 'package:artiko/features/login/presentation/manager/login_bloc.dart';

Future<void> setUpLoginProviders() async {
  sl.registerFactory(() => LoginRepository(
      HttpProxyImpl(ConfigRemoteApi.baseUrl),
      '/usuario',
      sl<CurrentUserDao>()));

  sl.registerFactory(
      () => LoginUseCase(sl<LoginRepository>(), sl<CacheStorageInterface>()));

  sl.registerFactory(() => LoginBloc(sl<LoginUseCase>()));
}
