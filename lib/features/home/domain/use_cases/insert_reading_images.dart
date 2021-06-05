import 'package:artiko/core/error/exception.dart';
import 'package:artiko/core/use_case.dart';
import 'package:artiko/features/home/data/models/reading_images_model.dart';
import 'package:artiko/features/home/domain/repositories/readings_repository_contract.dart';

class InsertReadingImages extends UseCase<ReadingImagesModel, Future<int>> {
  final ReadingImageRepositoryContract _repository;

  InsertReadingImages(this._repository);

  @override
  Future<int> call(ReadingImagesModel readingImagesModel) {
    try {
      return _repository.insert(readingImagesModel);
    } on ServerException catch (e) {
      throw Failure(e.message);
    }
  }
}
