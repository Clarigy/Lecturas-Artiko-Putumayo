import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
import 'package:artiko/core/readings/domain/repositories/reading_repository_contract.dart';

import '../../../../../core/error/exception.dart';
import '../../../../../core/use_case.dart';

class GetReadingsUseCase extends UseCase {
  final ReadingRepositoryContract _repository;

  GetReadingsUseCase(this._repository);

  @override
  Stream<List<ReadingDetailItem>?> call(_) {
    try {
      return _repository.getAllReadings();
    } on ServerException catch (e) {
      throw Failure(e.message);
    }
  }
}
