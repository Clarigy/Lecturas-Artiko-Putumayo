import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
import 'package:artiko/core/readings/domain/entities/reading_request.dart';
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
      final List<ReadingRequest> readingsRequest = readings
          .where((element) => element.readingRequest.id != null)
          .map((e) => e.readingRequest)
          .toList();

      return await _repository.sincronizarReadings(readingsRequest);
    } on ServerException catch (e) {
      throw Failure(e.message);
    }
  }
}
