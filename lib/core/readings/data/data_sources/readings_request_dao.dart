import 'package:artiko/core/readings/domain/entities/reading_request.dart';
import 'package:floor/floor.dart';

@dao
abstract class ReadingsRequestDao {
  @Query('SELECT * FROM readings_request  where detailId = :detailId LIMIT 1')
  Future<ReadingRequest?> getReadingsRequestById(String detailId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insert(ReadingRequest readingRequest);
}
