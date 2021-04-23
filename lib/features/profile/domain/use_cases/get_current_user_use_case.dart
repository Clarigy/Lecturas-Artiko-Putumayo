import 'package:artiko/core/use_case.dart';
import 'package:artiko/features/login/domain/entities/response/login_response.dart';
import 'package:artiko/features/profile/domain/repositories/profile_repository_contract.dart';

class GetCurrentUserUseCase implements UseCase<LoginResponse?> {
  final ProfileRepositoryContract _profileRepositoryContract;

  GetCurrentUserUseCase(this._profileRepositoryContract);

  @override
  Future<LoginResponse?> call(params) =>
      _profileRepositoryContract.getCurrentUser();
}
