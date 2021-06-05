import 'package:artiko/core/error/exception.dart';
import 'package:artiko/core/readings/data/data_sources/readings_dao.dart';
import 'package:artiko/core/readings/data/data_sources/readings_remote_data_source.dart';
import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
import 'package:artiko/core/readings/domain/entities/routes_response.dart';
import 'package:artiko/core/readings/domain/repositories/reading_repository_contract.dart';

class ReadingRepository implements ReadingRepositoryContract {
  final ReadingsRemoteDataSource _remoteDataSource;
  final ReadingsDao _dao;

  ReadingRepository(this._remoteDataSource, this._dao);

  @override
  Future<RoutesResponse> getRoutes(int lectorSec) async {
    try {
      return await _remoteDataSource.getRoutes(lectorSec);
    } catch (_) {
      throw ServerException();
    }
  }

  @override
  Future<void> loadAndSaveReadingDetails(int lecturaRutaSec) async {
    try {
      final readings =
          await _remoteDataSource.getReadingDetails(lecturaRutaSec);
      await saveReadings(readings.items);
    } catch (_) {
      throw ServerException();
    }
  }

  @override
  Stream<List<ReadingDetailItem>?> getAllReadings() {
    try {
      return _dao.getReadings();
    } catch (_) {
      throw ServerException();
    }
  }

  @override
  Future<void> saveReadings(List<ReadingDetailItem> readings) {
    try {
      return _dao.insertAll(readings);
    } catch (_) {
      throw ServerException();
    }
  }
}
