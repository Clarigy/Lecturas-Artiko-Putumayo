import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
import 'package:floor/floor.dart';

@dao
abstract class ReadingsDao {
  @Query('SELECT * FROM readings')
  Stream<List<ReadingDetailItem>?> getReadings();

  @Query('SELECT * FROM readings')
  Future<List<ReadingDetailItem>?> getFutureReadings();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertOne(ReadingDetailItem readings);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertAll(List<ReadingDetailItem> readings);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> update(ReadingDetailItem readings);
}
