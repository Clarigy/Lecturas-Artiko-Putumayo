import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
import 'package:artiko/features/home/domain/use_cases/get_readings_use_case.dart';
import 'package:flutter/material.dart';

class ActivitiesBloc extends ChangeNotifier {
  ActivitiesBloc(this._getReadingsUseCase);

  final GetReadingsUseCase _getReadingsUseCase;
  bool needRefreshList = false;

  List<ReadingDetailItem>? readings;

  final TextEditingController filterTextController = TextEditingController();

  Stream<List<ReadingDetailItem>?> getReadings() {
    try {
      if (readings == null || readings!.isEmpty || needRefreshList) {
        needRefreshList = false;
        return _getReadingsUseCase(null);
      }

      return readings != null && filterTextController.text.isNotEmpty
          ? getFilterReadings(filterTextController.text)
          : getAllMemoryReadings();
    } catch (error) {
      rethrow;
    }
  }

  Stream<List<ReadingDetailItem>?> getFilterReadings(String filter) async* {
    yield readings!
        .where((value) =>
            value.numeroMedidor.toLowerCase().contains(filter.toLowerCase()) ||
            value.nombre.toLowerCase().contains(filter.toLowerCase()) ||
            value.direccion.toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  Stream<List<ReadingDetailItem>?> getAllMemoryReadings() async* {
    yield readings;
  }

  void doFilter() {
    notifyListeners();
  }
}
