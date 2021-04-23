import 'package:artiko/core/error/exception.dart';
import 'package:artiko/features/login/data/data_sources/local/current_user_dao.dart';
import 'package:artiko/features/login/domain/entities/response/login_response.dart';
import 'package:artiko/features/profile/domain/repositories/profile_repository_contract.dart';

class ProfileRepository implements ProfileRepositoryContract {
  final CurrentUserDao _currentUserDao;

  ProfileRepository(this._currentUserDao);

  @override
  Future<LoginResponse?> getCurrentUser() async {
    try {
      return await _currentUserDao.getLoginResponse();
    } catch (_) {
      throw ServerException(null);
    }
  }
}
