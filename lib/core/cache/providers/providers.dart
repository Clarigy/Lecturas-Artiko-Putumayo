import 'package:artiko/core/cache/domain/repositories/cache_storage_repository.dart';
import 'package:get_it/get_it.dart';

import '../data/cache_storage_impl.dart';

final sl = GetIt.instance;

Future<void> injectionDependenciesStorage() async {
  sl.registerLazySingleton<CacheStorageInterface>(
    () => CacheStorageImpl(),
  );
}
