import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
import 'package:artiko/core/readings/domain/repositories/reading_repository_contract.dart';

import '../../../../../core/error/exception.dart';
import '../../../../../core/use_case.dart';

class SincronizarReadingsUseCase
    extends UseCase<List<ReadingDetailItem>, Future<void>> {
  final ReadingRepositoryContract _repository;

  SincronizarReadingsUseCase(this._repository);

  @override
  Future<void> call(List<ReadingDetailItem> readings) async {
    try {
      List<ReadingDetailItem> temp = [];

      for (final element in readings) {
        if (element.readingRequest.id != null &&
            element.readingRequest.detalleLecturaRutaSec != null &&
            !element.readingRequest.alreadySync) {
          element.readingRequest.alreadySync = true;

          if (element.readingRequest.indCritica?.isEmpty ?? true) {
            element.readingRequest.indCritica = 'SNL';
          }

          if (element.indRangoCritica?.isEmpty ?? true) {
            element.indRangoCritica = 'SNL';
          }

          temp.add(element);
        }
      }
      await _repository
          .sincronizarReadings(temp.map((e) => e.readingRequest).toList());

      for (final element in temp) {
        _repository.updateReadings(element);
      }
    } on ServerException catch (e) {
      throw Failure(e.message);
    }
  }
}
