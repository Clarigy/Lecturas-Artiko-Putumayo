import 'package:artiko/features/profile/presentation/providers/profile_provider.dart';
import 'package:get_it/get_it.dart';

import 'core/cache/providers/providers.dart';
import 'core/database/providers/local_database_providers.dart';
import 'features/home/presentation/pages/providers/home_provider.dart';
import 'features/login/presentation/providers/login_provider.dart';

GetIt sl = GetIt.instance;

Future<void> setupInjector() async {
  await setUpLoginProviders();
  await setUpProfileProviders();
  await injectionDependenciesStorage();
  await injectionDatabase();
  await setUpHomeProviders();
}
