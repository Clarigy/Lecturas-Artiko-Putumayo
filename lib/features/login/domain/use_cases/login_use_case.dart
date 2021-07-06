import 'package:artiko/core/cache/domain/repositories/cache_storage_repository.dart';
import 'package:artiko/core/cache/keys/cache_keys.dart';
import 'package:artiko/features/login/domain/entities/request/login_request.dart';
import 'package:artiko/features/login/domain/entities/response/login_response.dart';
import 'package:artiko/features/login/domain/repositories/login_repository_contract.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/use_case.dart';

class LoginUseCase extends UseCase<LoginRequest, Future<LoginResponse>> {
  final LoginRepositoryContract _repository;
  final CacheStorageInterface _storage;

  LoginUseCase(this._repository, this._storage);

  @override
  Future<LoginResponse> call(request) async {
    try {
      final String? currentUser = await _storage.fetch(CacheKeys.USER);

      if (currentUser != null) {
        final loginResponse = loginResponseFromJson(currentUser);
        if (loginResponse.correoLector != request.email)
          throw Failure(
              'No puedes iniciar sesión con otro usuario porque el anterior tiene una ruta asignada. Para iniciar sesión con otro usuario presiona Cerrar terminal');
      }

      final result = await _repository.doLogin(request);
      await _saveInCache(result);
      return result;
    } on ServerException catch (e) {
      throw Failure(e.message);
    }
  }

  Future<void> _saveInCache(LoginResponse result) async {
    await _storage.save(
        key: CacheKeys.ID_USER, value: result.idUsuario.toString());
  }
}
