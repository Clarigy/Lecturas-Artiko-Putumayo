import 'package:artiko/features/home/data/models/reading_images_model.dart';

abstract class ReadingImageRepositoryContract {
  Stream<List<ReadingImagesModel>?> getReadingImagesByReadingId(int readingId);

  Future<int> insert(ReadingImagesModel readingImagesModel);

  Future<void> update(ReadingImagesModel readingImagesModel);

  Future<void> deleteReadingImagesModel(ReadingImagesModel readingImagesModel);
}
