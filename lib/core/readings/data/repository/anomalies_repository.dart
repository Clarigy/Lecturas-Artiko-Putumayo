import 'package:artiko/core/error/exception.dart';
import 'package:artiko/core/readings/data/data_sources/anomalies_dao.dart';
import 'package:artiko/core/readings/data/data_sources/anomalies_remote_data_source.dart';
import 'package:artiko/core/readings/domain/entities/anomalies_response.dart';
import 'package:artiko/core/readings/domain/repositories/anomalies_repository_contract.dart';

class AnomaliesRepository implements AnomaliesRepositoryContract {
  final AnomaliesRemoteDataSource _remoteDataSource;
  final AnomaliesDao _anomaliesDao;

  AnomaliesRepository(this._remoteDataSource, this._anomaliesDao);

  @override
  Future<AnomaliesResponse> getAnomalies() async {
    try {
      final anomalies = await _remoteDataSource.getAnomalies();
      await saveAnomalies(anomalies.items);
      return anomalies;
    } catch (_) {
      throw ServerException();
    }
  }

  Future<void> saveAnomalies(List<AnomalyItem> anomalies) async {
    try {
      await _anomaliesDao.insertAll(anomalies);
    } catch (_) {
      throw ServerException();
    }
  }
}
