import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
import 'package:artiko/core/readings/domain/entities/routes_response.dart';

abstract class ReadingRepositoryContract {
  Future<RoutesResponse> getRoutes(int lectorSec);

  Future<void> loadAndSaveReadingDetails(int lecturaRutaSec);

  Future<void> saveReadings(List<ReadingDetailItem> readings);

  Stream<List<ReadingDetailItem>?> getAllReadings();

  Future<List<RoutesItem>?> getAllRoutes();

  Future<void> saveRoutes(List<RoutesItem> routes);
}
