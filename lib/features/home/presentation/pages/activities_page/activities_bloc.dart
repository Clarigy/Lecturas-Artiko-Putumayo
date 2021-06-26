import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
import 'package:artiko/features/home/domain/use_cases/get_readings_use_case.dart';
import 'package:flutter/material.dart';

enum FilterType { PENDING, EXCECUTED, FAILED }

class ActivitiesBloc extends ChangeNotifier {
  ActivitiesBloc(this._getReadingsUseCase);

  final GetReadingsUseCase _getReadingsUseCase;
  bool needRefreshList = false;

  List<ReadingDetailItem>? readings;

  final TextEditingController filterTextController = TextEditingController();

  FilterType _filterType = FilterType.PENDING;

  FilterType get filterType => _filterType;

  set filterType(FilterType value) {
    _filterType = value;
    needRefreshList = true;
    notifyListeners();
  }

  Stream<List<ReadingDetailItem>?> getReadings() {
    try {
      if (readings == null || readings!.isEmpty || needRefreshList) {
        needRefreshList = false;
        return _getReadingsUseCase(_filterType);
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
