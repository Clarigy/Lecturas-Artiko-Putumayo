import 'package:artiko/core/error/exception.dart';
import 'package:artiko/core/readings/data/data_sources/observaciones_dao.dart';
import 'package:artiko/core/readings/data/data_sources/observaciones_remote_data_source.dart';
import 'package:artiko/core/readings/domain/entities/observaciones_response.dart';

class ObservacionesRepository {
  final ObservacionesRemoteDataSource _remoteDataSource;
  final ObservacionesDao _observacionesDao;

  ObservacionesRepository(this._remoteDataSource, this._observacionesDao);

  Future<void> loadAndSaveObservaciones() async {
    try {
      await _remoteDataSource.loadAndSaveObservaciones();
    } catch (_) {
      throw ServerException();
    }
  }

  Future<List<ObservacionItem>?> getObservaciones() async {
    try {
      return await _observacionesDao.getObservaciones();
    } catch (_) {
      throw ServerException();
    }
  }
}
