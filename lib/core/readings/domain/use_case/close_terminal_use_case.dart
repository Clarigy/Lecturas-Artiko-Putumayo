import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
import 'package:artiko/core/readings/domain/entities/reading_request.dart';
import 'package:artiko/core/readings/domain/repositories/reading_repository_contract.dart';
import 'package:artiko/features/home/domain/use_cases/get_reading_images_by_reading_id_future.dart';

import '../../../../../core/error/exception.dart';
import '../../../../../core/use_case.dart';

class CloseTerminalUseCase
    extends UseCase<List<ReadingDetailItem>, Future<void>> {
  final ReadingRepositoryContract _repository;
  final GetReadingImagesByReadingIdUseCaseFuture
      _getReadingImagesByReadingIdUseCaseFuture;

  CloseTerminalUseCase(
      this._repository, this._getReadingImagesByReadingIdUseCaseFuture);

  @override
  Future<void> call(List<ReadingDetailItem> readings) async {
    try {
      final List<ReadingRequest> tempList = [];
      for (final reading in readings) {
        ReadingRequest readingWithFotos = reading.readingRequest.fotos.isEmpty
            ? reading.readingRequest
            : reading.readingRequest
          ..fotos = (await _getReadingImagesByReadingIdUseCaseFuture(
                  reading.id.toString()))!
              .map((e) => e.imageBase64)
              .toList();

        if (reading.anomSec == null) {
          readingWithFotos = ReadingRequest.failed();
        }

        tempList.add(readingWithFotos);
      }

      return await _repository.closeTerminal(tempList);
    } on ServerException catch (e) {
      throw Failure(e.message);
    }
  }
}
