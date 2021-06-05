import 'package:artiko/core/readings/domain/use_case/load_and_save_all_data_use_case.dart';
import 'package:artiko/dependency_injector.dart';
import 'package:artiko/features/home/presentation/pages/init/loading_bloc.dart';
import 'package:artiko/features/profile/domain/use_cases/get_current_user_use_case.dart';

Future<void> setUpLoadingProviders() async {
  sl.registerLazySingleton(() => LoadingBloc(
      sl<LoadAndSaveAllDataUseCase>(), sl<GetCurrentUserUseCase>()));
}
