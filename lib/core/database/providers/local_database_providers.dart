import 'package:artiko/core/readings/data/data_sources/anomalies_dao.dart';
import 'package:artiko/core/readings/data/data_sources/observaciones_dao.dart';
import 'package:artiko/core/readings/data/data_sources/readings_dao.dart';
import 'package:artiko/core/readings/data/data_sources/readings_request_dao.dart';
import 'package:artiko/core/readings/data/data_sources/routes_dao.dart';
import 'package:artiko/dependency_injector.dart';
import 'package:artiko/features/home/data/data_sources/local/reading_images_dao.dart';
import 'package:artiko/features/login/data/data_sources/local/current_user_dao.dart';
import 'package:floor/floor.dart';

import '../local_database.dart';

Future<void> injectionDatabase() async {
  final db =
  await $FloorAppDatabase.databaseBuilder('artiko_lectuas.db').build();

  sl.registerLazySingleton<FloorDatabase>(() => db);

  sl.registerLazySingleton<CurrentUserDao>(() => db.currentUserDao);

  sl.registerLazySingleton<ReadingImagesDao>(() => db.readingImagesDao);

  sl.registerLazySingleton<ReadingsDao>(() => db.readingDao);

  sl.registerLazySingleton<RoutesDao>(() => db.routesDao);

  sl.registerLazySingleton<AnomaliesDao>(() => db.anomaliesDao);

  sl.registerLazySingleton<ReadingsRequestDao>(() => db.readingsRequestDao);

  sl.registerLazySingleton<ObservacionesDao>(() => db.observacionesDao);
}
