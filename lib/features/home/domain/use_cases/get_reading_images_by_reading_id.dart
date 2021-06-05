import 'package:artiko/core/error/exception.dart';
import 'package:artiko/core/use_case.dart';
import 'package:artiko/features/home/data/models/reading_images_model.dart';
import 'package:artiko/features/home/domain/repositories/readings_repository_contract.dart';

class GetReadingImagesByReadingIdUseCase
    extends UseCase<int, Stream<List<ReadingImagesModel>?>> {
  final ReadingImageRepositoryContract _repository;

  GetReadingImagesByReadingIdUseCase(this._repository);

  @override
  Stream<List<ReadingImagesModel>?> call(int readingId) {
    try {
      return _repository.getReadingImagesByReadingId(readingId);
    } on ServerException catch (e) {
      throw Failure(e.message);
    }
  }
}
