import 'package:artiko/core/readings/domain/entities/anomalia.dart';
import 'package:artiko/core/readings/domain/entities/anomalies_response.dart';

abstract class AnomaliesRepositoryContract {
  Future<AnomaliesResponse> loadAndSaveAnomalies();

  Future<List<Anomalia>> getAnomalies();
}