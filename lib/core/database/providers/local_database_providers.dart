import 'package:artiko/dependency_injector.dart';
import 'package:artiko/features/login/data/data_sources/local/current_user_dao.dart';
import 'package:floor/floor.dart';

import '../local_database.dart';

Future<void> injectionDatabase() async {
  final db =
      await $FloorAppDatabase.databaseBuilder('artiko_lectuas.db').build();

  sl.registerLazySingleton<FloorDatabase>(() => db);

  sl.registerLazySingleton<CurrentUserDao>(() => db.currentUserDao);
}
