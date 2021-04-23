import 'package:get_it/get_it.dart';

import 'core/cache/providers/providers.dart';
import 'features/login/presentation/providers/login_provider.dart';

GetIt sl = GetIt.instance;

Future<void> setupInjector() async {
  await setUpLoginProviders();
  await injectionDependenciesStorage();
}
