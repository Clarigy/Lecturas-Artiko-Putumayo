import 'package:artiko/core/error/exception.dart';
import 'package:artiko/features/home/data/data_sources/local/reading_images_dao.dart';
import 'package:artiko/features/home/data/models/reading_images_model.dart';
import 'package:artiko/features/home/domain/repositories/readings_repository_contract.dart';

class ReadingRepository implements ReadingRepositoryContract {
  final ReadingImagesDao _readingImagesDao;

  ReadingRepository(this._readingImagesDao);

  @override
  Stream<List<ReadingImagesModel>?> getReadingImagesByReadingId(int readingId) {
    try {
      return _readingImagesDao.getReadingImagesByReadingId(readingId);
    } catch (_) {
      throw ServerException();
    }
  }

  @override
  Future<int> insert(ReadingImagesModel readingImagesModel) {
    try {
      return _readingImagesDao.insert(readingImagesModel);
    } catch (_) {
      throw ServerException();
    }
  }

  @override
  Future<void> update(ReadingImagesModel readingImagesModel) {
    try {
      return _readingImagesDao.update(readingImagesModel);
    } catch (_) {
      throw ServerException();
    }
  }

  @override
  Future<void> deleteReadingImagesModel(ReadingImagesModel readingImagesModel) {
    try {
      return _readingImagesDao.deleteReadingImagesModel(readingImagesModel);
    } catch (_) {
      throw ServerException();
    }
  }
}
