import 'package:artiko/core/readings/domain/entities/routes_response.dart';
import 'package:floor/floor.dart';

@dao
abstract class RoutesDao {
  @Query('SELECT * FROM routes')
  Future<List<RoutesItem>?> getRoutes();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertAll(List<RoutesItem> routes);
}
