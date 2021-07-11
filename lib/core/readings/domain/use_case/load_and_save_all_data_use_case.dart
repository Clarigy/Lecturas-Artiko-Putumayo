import 'package:artiko/core/cache/domain/repositories/cache_storage_repository.dart';
import 'package:artiko/core/readings/data/data_sources/readings_dao.dart';
import 'package:artiko/core/readings/data/repository/observaciones_repository.dart';
import 'package:artiko/core/readings/domain/entities/actualizar_estado_request.dart';
import 'package:artiko/core/readings/domain/entities/routes_response.dart';
import 'package:artiko/core/readings/domain/repositories/anomalies_repository_contract.dart';
import 'package:artiko/core/readings/domain/repositories/reading_repository_contract.dart';
import 'package:artiko/core/use_case.dart';
import 'package:artiko/dependency_injector.dart';
import 'package:floor/floor.dart';

class LoadAndSaveAllDataUseCase implements UseCase<int, Future<void>> {
  final ReadingRepositoryContract _readingRepositoryContract;
  final AnomaliesRepositoryContract _anomaliesRepositoryContract;
  final ObservacionesRepository _observacionesRepository;

  LoadAndSaveAllDataUseCase(this._readingRepositoryContract,
      this._anomaliesRepositoryContract, this._observacionesRepository);

  @override
  Future<void> call(int lectorSec) async {
    try {
      var routes = await _readingRepositoryContract.getRoutes(lectorSec);
      await _loadAndSaveReadingsDetails(routes);
      await _observacionesRepository.loadAndSaveObservaciones();
      await _loadAndSaveAnomalies();
      await actualizarEstado();
    } on Exception catch (_) {
      await _clearData();
      rethrow;
    }
  }

  Future<void> _clearData() async {
    final db = sl<FloorDatabase>();
    await db.database.delete('anomalies');
    await db.database.delete('routes');
    await db.database.delete('readings');
    await db.database.delete('reading_images');

    await sl<CacheStorageInterface>().clear();
  }

  Future<void> _loadAndSaveReadingsDetails(RoutesResponse routes) async {
    for (final route in routes.items) {
      try {
        if (route.tipoMedicion == 'OPERACION CAMPO') {
          await _readingRepositoryContract
              .loadAndSaveReadingDetails(route.lecturaRutaSec);
        }
      } catch (_) {}
    }
  }

  Future<void> _loadAndSaveAnomalies() async {
    await _anomaliesRepositoryContract.loadAndSaveAnomalies();
  }

  Future<void> actualizarEstado() async {
    final readings = await sl<ReadingsDao>().getFutureReadings();

    final ids = readings
        ?.where((element) => element.detalleLecturaRutaSec != null)
        .map((e) => e.detalleLecturaRutaSec!)
        .toList();

    final actualizarEstadoRequest = ActualizarEstadoRequest(items: ids ?? []);

    await _readingRepositoryContract.actualizarEstado(actualizarEstadoRequest);
  }
}
