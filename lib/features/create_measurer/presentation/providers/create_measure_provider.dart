import 'package:artiko/core/cache/domain/repositories/cache_storage_repository.dart';
import 'package:artiko/core/readings/domain/use_case/save_readings_use_case.dart';
import 'package:artiko/dependency_injector.dart';
import 'package:artiko/features/create_measurer/presentation/manager/create_measure_bloc.dart';

Future<void> setUpCreateMeasureProviders() async {
  sl.registerFactory(() => CreateMeasureBloc(
      sl<SaveReadingsUseCase>(), sl<CacheStorageInterface>()));
}
