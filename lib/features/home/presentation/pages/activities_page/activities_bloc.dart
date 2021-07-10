import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
import 'package:artiko/features/home/domain/use_cases/get_readings_use_case.dart';
import 'package:flutter/material.dart';

enum FilterType { PENDING, EXCECUTED, FAILED }

class ActivitiesBloc extends ChangeNotifier {
  ActivitiesBloc(this._getReadingsUseCase);

  final GetReadingsUseCase _getReadingsUseCase;
  bool needRefreshList = false;
  bool _isLoading = false;


  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  List<ReadingDetailItem>? readings;

  // List<ReadingDetailItem>? readings;

  final TextEditingController filterTextController = TextEditingController();

  FilterType _filterType = FilterType.PENDING;

  FilterType get filterType => _filterType;

  set filterType(FilterType value) {
    _filterType = value;
    needRefreshList = true;
    notifyListeners();
  }

  int _activitiesCount = 0;

  int get activitiesCount => _activitiesCount;

  set activitiesCount(int value) {
    _activitiesCount = value;
    isLoading = true;
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
          : _getReadingsUseCase(_filterType);
    } catch (error) {
      rethrow;
    }
  }

  Stream<List<ReadingDetailItem>?> getFilterReadings(String filter) async* {
    final List<ReadingDetailItem> tempList = [];
    for (final value in readings!) {
      if (value.numeroMedidor.toLowerCase().contains(filter.toLowerCase()) ||
          value.nombre.toLowerCase().contains(filter.toLowerCase()) ||
          value.direccion.toLowerCase().contains(filter.toLowerCase())) {
        tempList.add(value);
      }
    }

    yield tempList;
  }

  Stream<List<ReadingDetailItem>?> getAllMemoryReadings() async* {
    yield readings;
  }

  void doFilter() {
    notifyListeners();
  }
}
