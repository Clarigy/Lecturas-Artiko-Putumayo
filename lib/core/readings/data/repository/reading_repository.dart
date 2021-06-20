import 'package:artiko/core/error/exception.dart';
import 'package:artiko/core/readings/data/data_sources/readings_dao.dart';
import 'package:artiko/core/readings/data/data_sources/readings_remote_data_source.dart';
import 'package:artiko/core/readings/data/data_sources/routes_dao.dart';
import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
import 'package:artiko/core/readings/domain/entities/reading_request.dart';
import 'package:artiko/core/readings/domain/entities/routes_response.dart';
import 'package:artiko/core/readings/domain/repositories/reading_repository_contract.dart';

class ReadingRepository implements ReadingRepositoryContract {
  final ReadingsRemoteDataSource _remoteDataSource;
  final ReadingsDao _readingsDao;
  final RoutesDao _routesDao;

  ReadingRepository(this._remoteDataSource, this._readingsDao, this._routesDao);

  @override
  Future<RoutesResponse> getRoutes(int lectorSec) async {
    try {
      final routes = await _remoteDataSource.getRoutes(lectorSec);
      await saveRoutes(routes.items);
      return routes;
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
      return _readingsDao.getReadings();
    } catch (_) {
      throw ServerException();
    }
  }

  @override
  Future<List<int>> saveReadings(List<ReadingDetailItem> readings) async {
    try {
      return await _readingsDao.insertAll(readings);
    } catch (_) {
      throw ServerException();
    }
  }

  @override
  Future<List<RoutesItem>?> getAllRoutes() async {
    try {
      return _routesDao.getRoutes();
    } catch (_) {
      throw ServerException();
    }
  }

  @override
  Future<void> saveRoutes(List<RoutesItem> routes) async {
    try {
      await _routesDao.insertAll(routes);
    } catch (_) {
      throw ServerException();
    }
  }

  @override
  Future<void> sincronizarReadings(List<ReadingRequest> readings) async {
    try {
      return await _remoteDataSource.sincronizarReadings(readings);
    } catch (_) {
      throw ServerException();
    }
  }

  @override
  Future<void> closeTerminal(List<ReadingRequest> readings) async {
    try {
      return await _remoteDataSource.closeTerminal(readings);
    } catch (_) {
      throw ServerException();
    }
  }
}
