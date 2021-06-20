import 'package:artiko/core/cache/domain/repositories/cache_storage_repository.dart';
import 'package:artiko/core/readings/data/repository/reading_repository.dart';
import 'package:artiko/core/readings/domain/use_case/get_anomalies_use_case.dart';
import 'package:artiko/dependency_injector.dart';
import 'package:artiko/features/home/data/data_sources/local/reading_images_dao.dart';
import 'package:artiko/features/home/data/repositories/readings_image_repository.dart';
import 'package:artiko/features/home/domain/use_cases/delete_reading_images.dart';
import 'package:artiko/features/home/domain/use_cases/get_reading_images_by_reading_id.dart';
import 'package:artiko/features/home/domain/use_cases/get_reading_images_by_reading_id_future.dart';
import 'package:artiko/features/home/domain/use_cases/get_readings_use_case.dart';
import 'package:artiko/features/home/domain/use_cases/insert_reading_images.dart';
import 'package:artiko/features/home/domain/use_cases/update_reading_images.dart';
import 'package:artiko/features/home/presentation/pages/activities_page/activities_bloc.dart';
import 'package:artiko/features/home/presentation/pages/reading_detail_page/reading_detail_bloc.dart';

Future<void> setUpHomeProviders() async {
  sl.registerLazySingleton(() => GetReadingsUseCase(sl<ReadingRepository>()));

  sl.registerLazySingleton(() => ActivitiesBloc(sl<GetReadingsUseCase>()));

  sl.registerLazySingleton(() => ReadingsImageRepository(
      sl<ReadingImagesDao>(), sl<CacheStorageInterface>()));

  sl.registerLazySingleton(
      () => GetReadingImagesByReadingIdUseCase(sl<ReadingsImageRepository>()));

  sl.registerLazySingleton(() =>
      GetReadingImagesByReadingIdUseCaseFuture(sl<ReadingsImageRepository>()));

  sl.registerLazySingleton(
      () => InsertReadingImages(sl<ReadingsImageRepository>()));

  sl.registerLazySingleton(
      () => UpdateReadingImages(sl<ReadingsImageRepository>()));

  sl.registerLazySingleton(
      () => DeleteReadingImages(sl<ReadingsImageRepository>()));

  sl.registerLazySingleton(() => ReadingDetailBloc(
        sl<GetReadingImagesByReadingIdUseCase>(),
        sl<InsertReadingImages>(),
        sl<UpdateReadingImages>(),
        sl<DeleteReadingImages>(),
        sl<GetAnomaliesUseCase>(),
      ));
}
