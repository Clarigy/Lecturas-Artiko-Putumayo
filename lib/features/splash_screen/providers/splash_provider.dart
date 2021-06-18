import 'package:artiko/dependency_injector.dart';
import 'package:artiko/features/profile/domain/use_cases/get_current_user_use_case.dart';
import 'package:artiko/features/splash_screen/splash_bloc.dart';

Future<void> setUpSplashProviders() async {
  sl.registerFactory(() => SplashBloc(sl<GetCurrentUserUseCase>()));
}
