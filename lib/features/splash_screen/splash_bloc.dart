import 'package:artiko/core/cache/domain/repositories/cache_storage_repository.dart';
import 'package:artiko/core/cache/keys/cache_keys.dart';
import 'package:artiko/features/profile/domain/use_cases/get_current_user_use_case.dart';
import 'package:flutter/material.dart';

import '../../dependency_injector.dart';

class SplashBloc extends ChangeNotifier {
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  SplashBloc(this._getCurrentUserUseCase);

  Future<bool> existSession() async {
    try {
      final currentUser = await _getCurrentUserUseCase(null);

      final String? userId =
          await sl<CacheStorageInterface>().fetch(CacheKeys.ID_USER);

      return userId != null && userId.isNotEmpty && currentUser == null;
    } on Exception {
      rethrow;
    }
  }
}
