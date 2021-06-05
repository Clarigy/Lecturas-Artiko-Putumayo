import 'package:artiko/core/http/data/http_proxy_impl.dart';
import 'package:artiko/core/readings/data/data_sources/readings_dao.dart';
import 'package:artiko/core/readings/data/data_sources/readings_remote_data_source.dart';
import 'package:artiko/core/readings/data/repository/reading_repository.dart';
import 'package:artiko/core/readings/domain/use_case/load_and_save_all_data_use_case.dart';
import 'package:artiko/dependency_injector.dart';

Future<void> setUpReadingsProviders() async {
  sl.registerLazySingleton<ReadingsRemoteDataSource>(() =>
      ReadingsRemoteDataSource(sl<HttpProxyImpl>(),
          readingDetailService: '/leer_detalle_lecturas',
          routesService: '/leer_rutas'));

  sl.registerLazySingleton<ReadingRepository>(() =>
      ReadingRepository(sl<ReadingsRemoteDataSource>(), sl<ReadingsDao>()));

  sl.registerLazySingleton<LoadAndSaveAllDataUseCase>(
      () => LoadAndSaveAllDataUseCase(sl<ReadingRepository>()));
}
