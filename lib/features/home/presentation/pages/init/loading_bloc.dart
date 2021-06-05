import 'package:artiko/core/readings/domain/use_case/load_and_save_all_data_use_case.dart';
import 'package:artiko/features/login/domain/entities/response/login_response.dart';
import 'package:artiko/features/profile/domain/use_cases/get_current_user_use_case.dart';

class LoadingBloc {
  final LoadAndSaveAllDataUseCase _loadAndSaveAllDataUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  LoadingBloc(this._loadAndSaveAllDataUseCase, this._getCurrentUserUseCase);

  Future<void> loadAndSaveAllData(int lectorSec) async {
    try {
      _loadAndSaveAllDataUseCase.call(lectorSec);
    } catch (e) {
      rethrow;
    }
  }

  Future<LoginResponse?> getCurrentUserFromDb() async {
    try {
      return await _getCurrentUserUseCase(null);
    } catch (error) {
      rethrow;
    }
  }
}
