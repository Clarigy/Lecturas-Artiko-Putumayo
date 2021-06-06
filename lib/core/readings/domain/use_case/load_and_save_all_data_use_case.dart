import 'package:artiko/core/readings/domain/entities/routes_response.dart';
import 'package:artiko/core/readings/domain/repositories/reading_repository_contract.dart';
import 'package:artiko/core/use_case.dart';

class LoadAndSaveAllDataUseCase implements UseCase<int, Future<void>> {
  final ReadingRepositoryContract _repositoryContract;

  LoadAndSaveAllDataUseCase(this._repositoryContract);

  @override
  Future<void> call(int lectorSec) async {
    var routes = await _repositoryContract.getRoutes(lectorSec);

    await _loadAndSaveReadingsDetails(routes);
  }

  Future<void> _loadAndSaveReadingsDetails(RoutesResponse routes) async {
    //TODO DEJAR NORMAL
    routes.items = routes.items.sublist(0, 2);

    for (final x in routes.items) {
      try {
        if (x.tipoMedicion == 'OPERACION CAMPO') {
          await _repositoryContract.loadAndSaveReadingDetails(x.lecturaRutaSec);
        }
      } catch (_) {}
    }
  }
}
