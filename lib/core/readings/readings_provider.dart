import 'package:artiko/core/cache/domain/repositories/cache_storage_repository.dart';
import 'package:artiko/core/http/data/http_proxy_impl.dart';
import 'package:artiko/core/readings/data/data_sources/anomalies_remote_data_source.dart';
import 'package:artiko/core/readings/data/data_sources/observaciones_dao.dart';
import 'package:artiko/core/readings/data/data_sources/observaciones_remote_data_source.dart';
import 'package:artiko/core/readings/data/data_sources/readings_dao.dart';
import 'package:artiko/core/readings/data/data_sources/readings_remote_data_source.dart';
import 'package:artiko/core/readings/data/data_sources/readings_request_dao.dart';
import 'package:artiko/core/readings/data/repository/anomalies_repository.dart';
import 'package:artiko/core/readings/data/repository/reading_repository.dart';
import 'package:artiko/core/readings/domain/use_case/close_terminal_use_case.dart';
import 'package:artiko/core/readings/domain/use_case/get_anomalies_use_case.dart';
import 'package:artiko/core/readings/domain/use_case/load_and_save_all_data_use_case.dart';
import 'package:artiko/core/readings/domain/use_case/sincronizar_readings_use_case.dart';
import 'package:artiko/dependency_injector.dart';
import 'package:artiko/features/home/domain/use_cases/get_reading_images_by_reading_id_future.dart';

import 'data/data_sources/anomalies_dao.dart';
import 'data/data_sources/routes_dao.dart';
import 'data/repository/observaciones_repository.dart';
import 'domain/use_case/save_readings_use_case.dart';
import 'domain/use_case/update_new_meter_use_case.dart';
import 'domain/use_case/update_reading_use_case.dart';

Future<void> setUpReadingsProviders() async {
  // Anomalies
  sl.registerLazySingleton<AnomaliesRemoteDataSource>(
      () => AnomaliesRemoteDataSource(sl<HttpProxyImpl>(), '/leer_anomalias'));

  sl.registerLazySingleton<AnomaliesRepository>(() =>
      AnomaliesRepository(sl<AnomaliesRemoteDataSource>(), sl<AnomaliesDao>()));

  //Observaciones
  sl.registerLazySingleton<ObservacionesRemoteDataSource>(() =>
      ObservacionesRemoteDataSource(
          sl<HttpProxyImpl>(), '/observacion_lectura'));

  sl.registerLazySingleton<ObservacionesRepository>(
      () => ObservacionesRepository(
            sl<ObservacionesRemoteDataSource>(),
            sl<ObservacionesDao>(),
          ));

  //Readings
  sl.registerLazySingleton<ReadingsRemoteDataSource>(() =>
      ReadingsRemoteDataSource(sl<HttpProxyImpl>(),
          readingDetailService: '/leer_detalle_lecturas',
          routesService: '/leer_rutas'));

  sl.registerLazySingleton<ReadingRepository>(() => ReadingRepository(
      sl<ReadingsRemoteDataSource>(),
      sl<ReadingsDao>(),
      sl<RoutesDao>(),
          sl<ReadingsRequestDao>()));

  sl.registerLazySingleton<LoadAndSaveAllDataUseCase>(() =>
      LoadAndSaveAllDataUseCase(sl<ReadingRepository>(),
          sl<AnomaliesRepository>(), sl<ObservacionesRepository>()));

  sl.registerLazySingleton<SaveReadingsUseCase>(
      () => SaveReadingsUseCase(sl<ReadingRepository>()));

  sl.registerLazySingleton<UpdateReadingUseCase>(
      () => UpdateReadingUseCase(sl<ReadingRepository>()));

  sl.registerLazySingleton<SincronizarReadingsUseCase>(
      () => SincronizarReadingsUseCase(sl<ReadingRepository>()));

  sl.registerLazySingleton<CloseTerminalUseCase>(() => CloseTerminalUseCase(
      sl<ReadingRepository>(),
      sl<GetReadingImagesByReadingIdUseCaseFuture>(),
      sl<UpdateNewMeterUseCase>()));

  sl.registerLazySingleton<UpdateNewMeterUseCase>(() => UpdateNewMeterUseCase(
        sl<ReadingRepository>(),
        sl<CacheStorageInterface>(),
      ));

  sl.registerLazySingleton<GetAnomaliesUseCase>(
      () => GetAnomaliesUseCase(sl<AnomaliesRepository>()));
}
