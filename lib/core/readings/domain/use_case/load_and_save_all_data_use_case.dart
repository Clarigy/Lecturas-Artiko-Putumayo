import 'package:artiko/core/readings/domain/repositories/reading_repository_contract.dart';
import 'package:artiko/core/use_case.dart';

class LoadAndSaveAllDataUseCase implements UseCase<int, Future<void>> {
  final ReadingRepositoryContract _repositoryContract;

  LoadAndSaveAllDataUseCase(this._repositoryContract);

  @override
  Future<void> call(int lectorSec) async {
    final routes = await _repositoryContract.getRoutes(lectorSec);

    routes.items.forEach((element) async {
      try {
        await _repositoryContract
            .loadAndSaveReadingDetails(element.lecturaRutaSec);
      } catch (_) {}
    });
  }
}
