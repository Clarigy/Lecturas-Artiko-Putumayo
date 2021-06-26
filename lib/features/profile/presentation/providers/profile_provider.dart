import 'package:artiko/core/cache/domain/repositories/cache_storage_repository.dart';
import 'package:artiko/dependency_injector.dart';
import 'package:artiko/features/profile/data/repositories/profile_repository.dart';
import 'package:artiko/features/profile/domain/use_cases/get_current_user_use_case.dart';
import 'package:artiko/features/profile/presentation/manager/profile_bloc.dart';

Future<void> setUpProfileProviders() async {
  sl.registerLazySingleton(
      () => ProfileRepository(sl<CacheStorageInterface>()));

  sl.registerLazySingleton(
      () => GetCurrentUserUseCase(sl<ProfileRepository>()));

  sl.registerLazySingleton(() => ProfileBloc(sl<GetCurrentUserUseCase>()));
}
