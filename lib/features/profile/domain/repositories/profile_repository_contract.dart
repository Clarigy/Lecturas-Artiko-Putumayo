import 'package:artiko/features/login/domain/entities/response/login_response.dart';

abstract class ProfileRepositoryContract {
  Future<LoginResponse?> getCurrentUser();
}
