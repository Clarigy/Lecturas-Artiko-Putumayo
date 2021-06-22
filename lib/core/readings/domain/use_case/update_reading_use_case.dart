import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
import 'package:artiko/core/readings/domain/repositories/reading_repository_contract.dart';
import 'package:artiko/core/use_case.dart';

class UpdateReadingUseCase implements UseCase<ReadingDetailItem, Future<void>> {
  final ReadingRepositoryContract _readingsRepositoryContract;

  UpdateReadingUseCase(this._readingsRepositoryContract);

  @override
  Future<void> call(ReadingDetailItem reading) async {
    try {
      reading.readingRequest.idFotos = '';
      reading.readingRequest.fotos.forEach((element) {
        reading.readingRequest.idFotos += '$element/';
      });

      return await _readingsRepositoryContract.updateReadings(reading);
    } on Exception catch (_) {
      rethrow;
    }
  }
}
