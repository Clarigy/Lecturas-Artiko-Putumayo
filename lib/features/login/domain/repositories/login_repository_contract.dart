import 'package:artiko/features/login/domain/entities/request/login_request.dart';
import 'package:artiko/features/login/domain/entities/response/login_response.dart';

abstract class LoginRepositoryContract {
  Future<LoginResponse> doLogin(LoginRequest loginRequest);
}
