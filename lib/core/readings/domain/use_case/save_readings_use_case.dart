import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
import 'package:artiko/core/readings/domain/repositories/reading_repository_contract.dart';

import '../../../../../core/error/exception.dart';
import '../../../../../core/use_case.dart';

class SaveReadingsUseCase
    extends UseCase<List<ReadingDetailItem>, Future<List<int>>> {
  final ReadingRepositoryContract _repository;

  SaveReadingsUseCase(this._repository);

  @override
  Future<List<int>> call(List<ReadingDetailItem> readings) async {
    try {
      return await _repository.saveReadings(readings);
    } on ServerException catch (e) {
      throw Failure(e.message);
    }
  }
}
