import 'package:artiko/core/readings/domain/entities/anomalies_response.dart';

abstract class AnomaliesRepositoryContract {
  Future<AnomaliesResponse> getAnomalies();
}
