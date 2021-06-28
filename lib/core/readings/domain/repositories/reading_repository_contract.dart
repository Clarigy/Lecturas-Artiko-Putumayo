import 'package:artiko/core/readings/domain/entities/new_meter_request.dart';
import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
import 'package:artiko/core/readings/domain/entities/reading_request.dart';
import 'package:artiko/core/readings/domain/entities/routes_response.dart';
import 'package:artiko/features/home/presentation/pages/activities_page/activities_bloc.dart';

abstract class ReadingRepositoryContract {
  Future<RoutesResponse> getRoutes(int lectorSec);

  Future<void> loadAndSaveReadingDetails(int lecturaRutaSec);

  Future<List<int>> saveReadings(List<ReadingDetailItem> readings);

  Stream<List<ReadingDetailItem>?> getAllReadings(FilterType filterType);

  Future<List<ReadingDetailItem>> getAllReadingsFuture(FilterType filterType);

  Future<List<RoutesItem>?> getAllRoutes();

  Future<void> saveRoutes(List<RoutesItem> routes);

  Future<void> sincronizarReadings(List<ReadingRequest> readings);

  Future<void> updateNewMeter(List<NewMeterRequestItem> readings);

  Future<void> closeTerminal(List<ReadingRequest> readings);

  Future<ReadingDetailItem> updateReadings(ReadingDetailItem reading);
}
