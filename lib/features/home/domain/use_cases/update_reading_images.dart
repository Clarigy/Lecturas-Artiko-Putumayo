import 'package:artiko/core/error/exception.dart';
import 'package:artiko/core/use_case.dart';
import 'package:artiko/features/home/data/models/reading_images_model.dart';
import 'package:artiko/features/home/domain/repositories/readings_repository_contract.dart';

class UpdateReadingImages extends UseCase<ReadingImagesModel, Future<void>> {
  final ReadingRepositoryContract _repository;

  UpdateReadingImages(this._repository);

  @override
  Future<void> call(ReadingImagesModel readingImagesModel) {
    try {
      return _repository.update(readingImagesModel);
    } on ServerException catch (e) {
      throw Failure(e.message);
    }
  }
}
