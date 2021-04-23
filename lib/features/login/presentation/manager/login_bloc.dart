import 'package:artiko/features/login/domain/entities/request/login_request.dart';
import 'package:artiko/features/login/domain/entities/response/login_response.dart';
import 'package:artiko/features/login/domain/use_cases/login_use_case.dart';
import 'package:flutter/material.dart';

enum LoginState {
  loading,
  initial,
}

class LoginBloc extends ChangeNotifier {
  LoginBloc(
    this.loginUseCase,
  );

  final LoginUseCase loginUseCase;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final userIdentificationTextController = TextEditingController();
  final userPasswordTextController = TextEditingController();

  bool isPasswordVisible = false;

  var loginState = LoginState.initial;

  Future<LoginResponse> doLogin(String email, String password) async {
    loginState = LoginState.loading;
    notifyListeners();

    try {
      final _request = LoginRequest(email, password);
      return await loginUseCase(_request);
    } catch (error) {
      rethrow;
    } finally {
      loginState = LoginState.initial;
      notifyListeners();
    }
  }
}
