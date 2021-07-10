import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
import 'package:artiko/core/readings/domain/repositories/reading_repository_contract.dart';
import 'package:artiko/features/home/presentation/pages/activities_page/activities_bloc.dart';

import '../../../../../core/error/exception.dart';
import '../../../../../core/use_case.dart';

class GetReadingsUseCase
    extends UseCase<FilterType, Stream<List<ReadingDetailItem>?>> {
  final ReadingRepositoryContract _repository;

  GetReadingsUseCase(this._repository);

  @override
  Stream<List<ReadingDetailItem>?> call(FilterType filterType) {
    try {
      return _repository.getAllReadings(filterType).asyncMap((event) {
        if (event == null || filterType == FilterType.PENDING) return event;

        event.sort((a, b) => DateTime.parse(b.readingRequest.fechaLectura)
            .compareTo(DateTime.parse(a.readingRequest.fechaLectura)));

        return event;
      });
    } on ServerException catch (e) {
      throw Failure(e.message);
    }
  }
}
