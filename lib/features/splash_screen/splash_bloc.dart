import 'package:artiko/features/profile/domain/use_cases/get_current_user_use_case.dart';
import 'package:flutter/material.dart';

class SplashBloc extends ChangeNotifier {
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  SplashBloc(this._getCurrentUserUseCase);

  Future<bool> existSession() async {
    try {
      final currentUser = await _getCurrentUserUseCase(null);

      return currentUser != null;
    } on Exception {
      rethrow;
    }
  }
}
