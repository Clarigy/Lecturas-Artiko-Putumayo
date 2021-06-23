import 'package:artiko/core/readings/data/repository/observaciones_repository.dart';
import 'package:artiko/core/readings/domain/entities/routes_response.dart';
import 'package:artiko/core/readings/domain/repositories/anomalies_repository_contract.dart';
import 'package:artiko/core/readings/domain/repositories/reading_repository_contract.dart';
import 'package:artiko/core/use_case.dart';

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
    } on Exception catch (_) {
      rethrow;
    }
  }

  Future<void> _loadAndSaveReadingsDetails(RoutesResponse routes) async {
    //TODO DEJAR NORMAL
    routes.items = routes.items.sublist(0, 2);

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
}
