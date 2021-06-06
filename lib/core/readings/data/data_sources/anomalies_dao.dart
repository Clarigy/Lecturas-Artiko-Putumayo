import 'package:artiko/core/readings/domain/entities/anomalies_response.dart';
import 'package:floor/floor.dart';

@dao
abstract class AnomaliesDao {
  @Query('SELECT * FROM anomalies')
  Future<List<AnomalyItem>?> getAnomalies();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertAll(List<AnomalyItem> anomalies);
}
