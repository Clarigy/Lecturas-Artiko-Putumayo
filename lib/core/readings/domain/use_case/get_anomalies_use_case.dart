import 'package:artiko/core/readings/domain/entities/anomalia.dart';
import 'package:artiko/core/readings/domain/repositories/anomalies_repository_contract.dart';
import 'package:artiko/core/use_case.dart';

class GetAnomaliesUseCase implements UseCase<void, Future<List<Anomalia>>> {
  final AnomaliesRepositoryContract _anomaliesRepositoryContract;

  GetAnomaliesUseCase(this._anomaliesRepositoryContract);

  @override
  Future<List<Anomalia>> call(_) async {
    try {
      return await _anomaliesRepositoryContract.getAnomalies();
    } on Exception catch (_) {
      rethrow;
    }
  }
}
