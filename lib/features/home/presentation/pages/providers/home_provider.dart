import 'package:artiko/dependency_injector.dart';
import 'package:artiko/features/home/data/data_sources/local/reading_images_dao.dart';
import 'package:artiko/features/home/data/repositories/reading_repository.dart';
import 'package:artiko/features/home/domain/use_cases/delete_reading_images.dart';
import 'package:artiko/features/home/domain/use_cases/get_reading_images_by_reading_id.dart';
import 'package:artiko/features/home/domain/use_cases/insert_reading_images.dart';
import 'package:artiko/features/home/domain/use_cases/update_reading_images.dart';
import 'package:artiko/features/home/presentation/pages/reading_detail_page/reading_detail_bloc.dart';

Future<void> setUpHomeProviders() async {
  sl.registerLazySingleton(() => ReadingRepository(sl<ReadingImagesDao>()));

  sl.registerLazySingleton(
      () => GetReadingImagesByReadingIdUseCase(sl<ReadingRepository>()));

  sl.registerLazySingleton(() => InsertReadingImages(sl<ReadingRepository>()));

  sl.registerLazySingleton(() => UpdateReadingImages(sl<ReadingRepository>()));

  sl.registerLazySingleton(() => DeleteReadingImages(sl<ReadingRepository>()));

  sl.registerLazySingleton(() => ReadingDetailBloc(
      sl<GetReadingImagesByReadingIdUseCase>(),
      sl<InsertReadingImages>(),
      sl<UpdateReadingImages>(),
      sl<DeleteReadingImages>()));
}
