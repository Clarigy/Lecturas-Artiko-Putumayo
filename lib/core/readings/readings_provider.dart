import 'package:artiko/core/http/data/http_proxy_impl.dart';
import 'package:artiko/core/readings/data/data_sources/anomalies_remote_data_source.dart';
import 'package:artiko/core/readings/data/data_sources/readings_dao.dart';
import 'package:artiko/core/readings/data/data_sources/readings_remote_data_source.dart';
import 'package:artiko/core/readings/data/repository/anomalies_repository.dart';
import 'package:artiko/core/readings/data/repository/reading_repository.dart';
import 'package:artiko/core/readings/domain/use_case/get_anomalies_use_case.dart';
import 'package:artiko/core/readings/domain/use_case/load_and_save_all_data_use_case.dart';
import 'package:artiko/dependency_injector.dart';

import 'data/data_sources/anomalies_dao.dart';
import 'data/data_sources/routes_dao.dart';

Future<void> setUpReadingsProviders() async {
  // Anomalies
  sl.registerLazySingleton<AnomaliesRemoteDataSource>(
      () => AnomaliesRemoteDataSource(sl<HttpProxyImpl>(), '/leer_anomalias'));

  sl.registerLazySingleton<AnomaliesRepository>(() =>
      AnomaliesRepository(sl<AnomaliesRemoteDataSource>(), sl<AnomaliesDao>()));

  //Readings
  sl.registerLazySingleton<ReadingsRemoteDataSource>(() =>
      ReadingsRemoteDataSource(sl<HttpProxyImpl>(),
          readingDetailService: '/leer_detalle_lecturas',
          routesService: '/leer_rutas'));

  sl.registerLazySingleton<ReadingRepository>(() => ReadingRepository(
      sl<ReadingsRemoteDataSource>(), sl<ReadingsDao>(), sl<RoutesDao>()));

  sl.registerLazySingleton<LoadAndSaveAllDataUseCase>(() =>
      LoadAndSaveAllDataUseCase(
          sl<ReadingRepository>(), sl<AnomaliesRepository>()));

  sl.registerLazySingleton<GetAnomaliesUseCase>(
      () => GetAnomaliesUseCase(sl<AnomaliesRepository>()));
}
