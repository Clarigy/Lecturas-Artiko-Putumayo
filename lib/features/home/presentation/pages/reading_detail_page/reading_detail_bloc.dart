import 'package:artiko/features/home/data/models/reading_images_model.dart';
import 'package:artiko/features/home/domain/use_cases/delete_reading_images.dart';
import 'package:artiko/features/home/domain/use_cases/get_reading_images_by_reading_id.dart';
import 'package:artiko/features/home/domain/use_cases/insert_reading_images.dart';
import 'package:artiko/features/home/domain/use_cases/update_reading_images.dart';
import 'package:flutter/material.dart';

enum ReadingDetailState { loading, ready, saving }

class ReadingDetailBloc extends ChangeNotifier {
  final GetReadingImagesByReadingIdUseCase _getReadingImagesByReadingIdUseCase;
  final InsertReadingImages _insertReadingImages;
  final UpdateReadingImages _updateReadingImages;
  final DeleteReadingImages _deleteReadingImages;

  ReadingDetailBloc(
      this._getReadingImagesByReadingIdUseCase,
      this._insertReadingImages,
      this._updateReadingImages,
      this._deleteReadingImages);

  ReadingDetailState readingDetailState = ReadingDetailState.loading;

  Stream<List<ReadingImagesModel>?> getReadingImagesByReadingId(int readingId) {
    readingDetailState = ReadingDetailState.loading;
    notifyListeners();

    try {
      return _getReadingImagesByReadingIdUseCase(readingId);
    } catch (error) {
      rethrow;
    } finally {
      readingDetailState = ReadingDetailState.ready;
      notifyListeners();
    }
  }

  Future<int> insertReadingImage(ReadingImagesModel readingImagesModel) async {
    readingDetailState = ReadingDetailState.saving;
    notifyListeners();

    try {
      return await _insertReadingImages(readingImagesModel);
    } catch (error) {
      rethrow;
    } finally {
      readingDetailState = ReadingDetailState.ready;
      notifyListeners();
    }
  }

  Future<void> updateReadingImage(ReadingImagesModel readingImagesModel) {
    readingDetailState = ReadingDetailState.saving;
    notifyListeners();

    try {
      return _updateReadingImages(readingImagesModel);
    } catch (error) {
      rethrow;
    } finally {
      readingDetailState = ReadingDetailState.ready;
      notifyListeners();
    }
  }

  Future<void> deleteReadingImage(ReadingImagesModel readingImagesModel) {
    readingDetailState = ReadingDetailState.saving;
    notifyListeners();

    try {
      return _deleteReadingImages(readingImagesModel);
    } catch (error) {
      rethrow;
    } finally {
      readingDetailState = ReadingDetailState.ready;
      notifyListeners();
    }
  }
}
