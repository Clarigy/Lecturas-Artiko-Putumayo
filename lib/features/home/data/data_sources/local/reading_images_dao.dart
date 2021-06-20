import 'package:artiko/features/home/data/models/reading_images_model.dart';
import 'package:floor/floor.dart';

@dao
abstract class ReadingImagesDao {
  @Query('SELECT * FROM reading_images where readingId = :readingId')
  Stream<List<ReadingImagesModel>?> getReadingImagesByReadingId(
      String readingId);

  @Query('SELECT * FROM reading_images where readingId = :readingId')
  Future<List<ReadingImagesModel>?> getReadingImagesByReadingIdFuture(
      String readingId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insert(ReadingImagesModel readingImagesModel);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> update(ReadingImagesModel readingImagesModel);

  @delete
  Future<void> deleteReadingImagesModel(ReadingImagesModel readingImagesModel);
}
