import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
import 'package:floor/floor.dart';

@dao
abstract class ReadingsDao {
  @Query('SELECT * FROM readings')
  Stream<List<ReadingDetailItem>?> getReadings();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertOne(ReadingDetailItem readings);

  @insert
  Future<List<int>> insertAll(List<ReadingDetailItem> readings);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> update(ReadingDetailItem readings);
}
