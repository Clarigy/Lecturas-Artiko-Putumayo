import 'package:artiko/core/error/exception.dart';
import 'package:artiko/core/use_case.dart';
import 'package:artiko/features/home/data/models/reading_images_model.dart';
import 'package:artiko/features/home/domain/repositories/readings_repository_contract.dart';

class GetReadingImagesByReadingIdUseCaseFuture
    extends UseCase<String, Future<List<ReadingImagesModel>?>> {
  final ReadingImageRepositoryContract _repository;

  GetReadingImagesByReadingIdUseCaseFuture(this._repository);

  @override
  Future<List<ReadingImagesModel>?> call(String readingId) {
    try {
      return _repository.getReadingImagesByReadingIdFuture(readingId);
    } on ServerException catch (e) {
      throw Failure(e.message);
    }
  }
}
