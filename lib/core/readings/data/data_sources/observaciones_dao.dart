import 'package:artiko/core/readings/domain/entities/observaciones_response.dart';
import 'package:floor/floor.dart';

@dao
abstract class ObservacionesDao {
  @Query('SELECT * FROM observaciones')
  Future<List<ObservacionItem>?> getObservaciones();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertAll(List<ObservacionItem> anomalies);
}
