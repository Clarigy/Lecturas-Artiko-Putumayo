import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
import 'package:artiko/features/home/domain/use_cases/get_readings_use_case.dart';
import 'package:flutter/material.dart';

class ActivitiesBloc extends ChangeNotifier {
  ActivitiesBloc(this._getReadingsUseCase);

  final GetReadingsUseCase _getReadingsUseCase;

  Stream<List<ReadingDetailItem>?> getReadings() {
    try {
      return _getReadingsUseCase(null);
    } catch (error) {
      rethrow;
    }
  }
}
