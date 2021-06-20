import 'package:artiko/core/cache/domain/repositories/cache_storage_repository.dart';
import 'package:artiko/core/error/exception.dart';
import 'package:artiko/features/home/data/data_sources/local/reading_images_dao.dart';
import 'package:artiko/features/home/data/models/reading_images_model.dart';
import 'package:artiko/features/home/domain/repositories/readings_repository_contract.dart';

class ReadingsImageRepository implements ReadingImageRepositoryContract {
  final ReadingImagesDao _readingImagesDao;
  final CacheStorageInterface _cacheStorageInterface;

  ReadingsImageRepository(this._readingImagesDao, this._cacheStorageInterface);

  @override
  Stream<List<ReadingImagesModel>?> getReadingImagesByReadingId(
      String readingId) async* {
    try {
      yield* _readingImagesDao
          .getReadingImagesByReadingId(readingId)
          .asyncMap((event) async {
        if (event == null) return event;

        final List<ReadingImagesModel> tempList = [];

        for (final element in event) {
          element.imageBase64 =
              await _cacheStorageInterface.fetch(element.getSpecialId()) ?? '';
          tempList.add(element);
        }

        return tempList;
      });
    } catch (_) {
      throw ServerException();
    }
  }

  @override
  Future<List<ReadingImagesModel>?> getReadingImagesByReadingIdFuture(
      String readingId) async {
    try {
      final images =
          await _readingImagesDao.getReadingImagesByReadingIdFuture(readingId);
      if (images == null) return [];

      final List<ReadingImagesModel> tempList = [];

      for (final image in images) {
        image.imageBase64 =
            await _cacheStorageInterface.fetch(image.getSpecialId()) ?? '';
        tempList.add(image);
      }

      return tempList;
    } catch (_) {
      throw ServerException();
    }
  }

  @override
  Future<int> insert(ReadingImagesModel readingImagesModel) async {
    try {
      _cacheStorageInterface.save(
          key: readingImagesModel.getSpecialId(),
          value: readingImagesModel.imageBase64);
      return _readingImagesDao.insert(readingImagesModel);
    } catch (_) {
      throw ServerException();
    }
  }

  @override
  Future<void> update(ReadingImagesModel readingImagesModel) {
    try {
      _cacheStorageInterface.save(
          key: readingImagesModel.getSpecialId(),
          value: readingImagesModel.imageBase64);
      return _readingImagesDao.update(readingImagesModel);
    } catch (_) {
      throw ServerException();
    }
  }

  @override
  Future<void> deleteReadingImagesModel(ReadingImagesModel readingImagesModel) {
    try {
      _cacheStorageInterface.delete(readingImagesModel.getSpecialId());
      return _readingImagesDao.deleteReadingImagesModel(readingImagesModel);
    } catch (_) {
      throw ServerException();
    }
  }
}
