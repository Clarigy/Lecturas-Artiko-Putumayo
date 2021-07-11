import 'package:artiko/core/error/exception.dart';
import 'package:artiko/core/readings/data/data_sources/readings_dao.dart';
import 'package:artiko/core/readings/data/data_sources/readings_remote_data_source.dart';
import 'package:artiko/core/readings/data/data_sources/readings_request_dao.dart';
import 'package:artiko/core/readings/data/data_sources/routes_dao.dart';
import 'package:artiko/core/readings/domain/entities/actualizar_estado_request.dart';
import 'package:artiko/core/readings/domain/entities/anomalia.dart';
import 'package:artiko/core/readings/domain/entities/new_meter_request.dart';
import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
import 'package:artiko/core/readings/domain/entities/reading_request.dart';
import 'package:artiko/core/readings/domain/entities/routes_response.dart';
import 'package:artiko/core/readings/domain/repositories/reading_repository_contract.dart';
import 'package:artiko/core/readings/domain/use_case/get_anomalies_use_case.dart';
import 'package:artiko/features/home/presentation/pages/activities_page/activities_bloc.dart';

import '../../../../dependency_injector.dart';

class ReadingRepository implements ReadingRepositoryContract {
  final ReadingsRemoteDataSource _remoteDataSource;
  final ReadingsDao _readingsDao;
  final RoutesDao _routesDao;
  final ReadingsRequestDao _readingsRequestDao;

  ReadingRepository(this._remoteDataSource, this._readingsDao, this._routesDao,
      this._readingsRequestDao);

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
  Stream<List<ReadingDetailItem>?> getAllReadings(FilterType filterType) {
    try {
      return _readingsDao.getReadings().asyncMap((event) async {
        if (event == null) return event;

        final List<ReadingDetailItem> tempList = [];

        for (var value in event) {
          if (value.idRequest != null && value.idRequest != -1) {
            final request = (await _readingsRequestDao
                .getReadingsRequestById(value.idRequest.toString()));

            if (request != null) {
              value.readingRequest = request;
            }
          }

          final route = await sl<RoutesDao>()
              .getRouteByLecturaRutaSec(value.lecturaRutaSec);

          if (route != null) value.routesItem = route;

          tempList.add(value);
        }

        final anomalias = await sl<GetAnomaliesUseCase>()(null);

        final x = tempList.where((element) {
          switch (filterType) {
            case FilterType.PENDING:
              return element.readingRequest.lectura == null &&
                  element.readingRequest.anomaliaSec == null;
            case FilterType.FAILED:
              if (element.readingRequest.anomaliaSec == null) return false;

              return anomalias.any((anomalia) => anomalia.claseAnomalia.any(
                  (claseAnomalia) =>
                      claseAnomalia.anomSec == element.anomSec &&
                      claseAnomalia.fallida));
            case FilterType.EXCECUTED:
              final List<ClaseAnomalia> clasesAnomalia = [];
              for (final anomalia in anomalias) {
                clasesAnomalia.addAll(anomalia.claseAnomalia);
              }

              if (element.readingRequest.anomaliaSec == null) return false;

              final current = clasesAnomalia.firstWhere((clase) =>
                  clase.nombre == element.readingRequest.claseAnomalia ||
                  element.readingRequest.claseAnomalia ==
                      ClaseAnomalia.ninguna().nombre);

              return !current.fallida;
          }
        });
        return x.toList();
      });
    } catch (_) {
      throw ServerException();
    }
  }

  @override
  Future<List<ReadingDetailItem>> getAllReadingsFuture(
      FilterType? filterType) async {
    try {
      final readings = await _readingsDao.getFutureReadings();

      if (readings == null) return [];

      final List<ReadingDetailItem> tempReadings = [];

      for (final reading in readings) {
        if (reading.idRequest != null && reading.idRequest != -1) {
          final request = (await _readingsRequestDao
              .getReadingsRequestById(reading.idRequest.toString()));

          if (request != null) {
            reading.readingRequest = request;
          }
        }

        final route = await sl<RoutesDao>()
            .getRouteByLecturaRutaSec(reading.lecturaRutaSec);

        if (route != null) reading.routesItem = route;

        tempReadings.add(reading);
      }

      final anomalias = await sl<GetAnomaliesUseCase>()(null);

      if (filterType == null) return tempReadings;

      final x = tempReadings.where((element) {
        switch (filterType) {
          case FilterType.PENDING:
            return element.readingRequest.lectura == null &&
                element.readingRequest.anomaliaSec == null;
          case FilterType.FAILED:
            if (element.readingRequest.anomaliaSec == null) return false;

            return anomalias.any((anomalia) => anomalia.claseAnomalia.any(
                (claseAnomalia) =>
                    claseAnomalia.anomSec == element.anomSec &&
                    claseAnomalia.fallida));
          case FilterType.EXCECUTED:
            final List<ClaseAnomalia> clasesAnomalia = [];
            for (final anomalia in anomalias) {
              clasesAnomalia.addAll(anomalia.claseAnomalia);
            }

            if (element.readingRequest.anomaliaSec == null) return false;

            final current = clasesAnomalia.firstWhere((clase) =>
                clase.nombre == element.readingRequest.claseAnomalia ||
                element.readingRequest.claseAnomalia ==
                    ClaseAnomalia.ninguna().nombre);

            return !current.fallida;
        }
      });

      return x.toList();
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
      await _remoteDataSource.sincronizarReadings(readings);
    } catch (_) {
      throw ServerException();
    }
  }

  @override
  Future<void> updateNewMeter(List<NewMeterRequestItem> readings) async {
    try {
      return await _remoteDataSource.updateNewMeter(readings);
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

  @override
  Future<ReadingDetailItem> updateReadings(ReadingDetailItem reading) async {
    try {
      reading.readingRequest.detailId = reading.id;
      final id = await _readingsRequestDao.insert(reading.readingRequest);
      reading.idRequest = id;
      await _readingsDao.update(reading);
      return reading;
    } catch (_) {
      throw ServerException();
    }
  }

  Future<void> actualizarEstado(
      ActualizarEstadoRequest actualizarEstadoRequest) async {
    try {
      await _remoteDataSource.actualizarEstado(actualizarEstadoRequest);
    } catch (_) {
      throw ServerException();
    }
  }
}
