import 'package:artiko/core/readings/domain/entities/anomalia.dart';
import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
import 'package:artiko/core/readings/domain/use_case/get_anomalies_use_case.dart';
import 'package:artiko/features/home/data/models/reading_images_model.dart';
import 'package:artiko/features/home/domain/use_cases/delete_reading_images.dart';
import 'package:artiko/features/home/domain/use_cases/get_reading_images_by_reading_id.dart';
import 'package:artiko/features/home/domain/use_cases/insert_reading_images.dart';
import 'package:artiko/features/home/domain/use_cases/update_reading_images.dart';
import 'package:flutter/material.dart';

enum ReadingDetailState {
  loading,
  initial,
}

class ReadingDetailBloc extends ChangeNotifier {
  ReadingDetailBloc(
      this._getReadingImagesByReadingIdUseCase,
      this._insertReadingImages,
      this._updateReadingImages,
      this._deleteReadingImages,
      this._getAnomaliesUseCase);

  final GetReadingImagesByReadingIdUseCase _getReadingImagesByReadingIdUseCase;
  final InsertReadingImages _insertReadingImages;
  final UpdateReadingImages _updateReadingImages;
  final DeleteReadingImages _deleteReadingImages;

  final GetAnomaliesUseCase _getAnomaliesUseCase;

  ReadingDetailState readingDetailState = ReadingDetailState.loading;

  List<Anomalia> anomalias = [];
  late int _anomaliaSec;

  int get anomaliaSec => _anomaliaSec;

  setAnomaliaSec(int anomaliaSecValue, ClaseAnomalia claseAnomalia) {
    _anomaliaSec = anomaliaSecValue;
    _claseAnomalia = claseAnomalia;
    notifyListeners();
  }

  late ClaseAnomalia _claseAnomalia;

  ClaseAnomalia get claseAnomalia => _claseAnomalia;

  set claseAnomalia(ClaseAnomalia value) {
    _claseAnomalia = value;
    notifyListeners();
  }

  setClaseAnomaliaSinRefresh(ClaseAnomalia value) => _claseAnomalia = value;

  late ReadingDetailItem readingDetailItem;
  late List<ReadingDetailItem> readings;

  Future<bool> loadInitInfo() async {
    try {
      await Future.wait([_loadAnomalias()], eagerError: true);
      return true;
    } on Exception {
      rethrow;
    } finally {
      readingDetailState = ReadingDetailState.initial;
      notifyListeners();
    }
  }

  Future<void> _loadAnomalias() async {
    anomalias = await _getAnomaliesUseCase(null);
    _anomaliaSec = anomalias[0].anomaliaSec;
    _claseAnomalia = anomalias[0].claseAnomalia[0];
  }

  Stream<List<ReadingImagesModel>?> getReadingImagesByReadingId(
      String readingId) {
    try {
      return _getReadingImagesByReadingIdUseCase(readingId);
    } catch (error) {
      rethrow;
    }
  }

  Future<int> insertReadingImage(ReadingImagesModel readingImagesModel) async {
    try {
      return await _insertReadingImages(readingImagesModel);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateReadingImage(ReadingImagesModel readingImagesModel) {
    try {
      return _updateReadingImages(readingImagesModel);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteReadingImage(ReadingImagesModel readingImagesModel) {
    try {
      return _deleteReadingImages(readingImagesModel);
    } catch (error) {
      rethrow;
    }
  }
}
