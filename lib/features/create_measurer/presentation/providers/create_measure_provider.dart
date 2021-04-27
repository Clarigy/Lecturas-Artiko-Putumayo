import 'package:artiko/dependency_injector.dart';
import 'package:artiko/features/create_measurer/presentation/manager/create_measure_bloc.dart';

Future<void> setUpCreateMeasureProviders() async {
  sl.registerFactory(() => CreateMeasureBloc());
}
