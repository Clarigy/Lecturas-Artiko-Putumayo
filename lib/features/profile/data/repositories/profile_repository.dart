import 'package:artiko/core/cache/domain/repositories/cache_storage_repository.dart';
import 'package:artiko/core/cache/keys/cache_keys.dart';
import 'package:artiko/core/error/exception.dart';
import 'package:artiko/features/login/domain/entities/response/login_response.dart';
import 'package:artiko/features/profile/domain/repositories/profile_repository_contract.dart';

class ProfileRepository implements ProfileRepositoryContract {
  final CacheStorageInterface _cacheStorageInterface;

  ProfileRepository(this._cacheStorageInterface);

  @override
  Future<LoginResponse?> getCurrentUser() async {
    try {
      final String? response =
          await _cacheStorageInterface.fetch(CacheKeys.USER);
      if (response == null) {
        return null;
      }
      return loginResponseFromJson(response);
    } catch (_) {
      throw ServerException(null);
    }
  }
}
