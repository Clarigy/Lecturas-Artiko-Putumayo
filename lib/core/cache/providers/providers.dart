import 'package:artiko/core/cache/domain/repositories/cache_storage_repository.dart';
import 'package:artiko/dependency_injector.dart';

import '../data/cache_storage_impl.dart';

Future<void> injectionDependenciesStorage() async {
  sl.registerLazySingleton<CacheStorageInterface>(
    () => CacheStorageImpl(),
  );
}
