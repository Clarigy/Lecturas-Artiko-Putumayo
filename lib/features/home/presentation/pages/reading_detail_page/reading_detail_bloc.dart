import 'package:artiko/core/cache/domain/repositories/cache_storage_repository.dart';
import 'package:artiko/core/cache/keys/cache_keys.dart';
import 'package:artiko/core/readings/data/repository/observaciones_repository.dart';
import 'package:artiko/core/readings/domain/entities/anomalia.dart';
import 'package:artiko/core/readings/domain/entities/observaciones_response.dart';
import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
import 'package:artiko/core/readings/domain/use_case/get_anomalies_use_case.dart';
import 'package:artiko/core/readings/domain/use_case/update_reading_use_case.dart';
import 'package:artiko/dependency_injector.dart';
import 'package:artiko/features/home/data/models/reading_images_model.dart';
import 'package:artiko/features/home/domain/use_cases/delete_reading_images.dart';
import 'package:artiko/features/home/domain/use_cases/get_reading_images_by_reading_id.dart';
import 'package:artiko/features/home/domain/use_cases/insert_reading_images.dart';
import 'package:artiko/features/home/domain/use_cases/update_reading_images.dart';
import 'package:artiko/features/home/presentation/pages/activities_page/activities_bloc.dart';
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
    this._getAnomaliesUseCase,
    this._updateReadingUseCase,
  );

  //Casos de uso
  final GetReadingImagesByReadingIdUseCase _getReadingImagesByReadingIdUseCase;
  final InsertReadingImages _insertReadingImages;
  final UpdateReadingImages _updateReadingImages;
  final DeleteReadingImages _deleteReadingImages;
  final UpdateReadingUseCase _updateReadingUseCase;

  final GetAnomaliesUseCase _getAnomaliesUseCase;

  //State
  ReadingDetailState readingDetailState = ReadingDetailState.loading;

  //Form
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final readingIntegers = TextEditingController();
  final readingDecimals = TextEditingController();
  final observacionTextController = TextEditingController();

  bool _verifiedReading = false;

  bool get verifiedReading => _verifiedReading;

  set verifiedReading(bool value) {
    _verifiedReading = value;
    notifyListeners();
  }

  bool? requiredAnomaliaByMeterReading;
  bool? requiredPhotoByMeterReading;

  bool _hideError = false;

  bool get hideError => _hideError;

  bool _alreadyInsertReading = false;

  bool get alreadyInsertReading => _alreadyInsertReading;

  set alreadyInsertReading(bool value) {
    _alreadyInsertReading = value;
    notifyListeners();
  }

  set hideError(bool value) {
    _hideError = value;
    notifyListeners();
  } //Drops

  List<Anomalia> anomalias = [];
  late int _anomaliaSec;

  int get anomaliaSec => _anomaliaSec;

  setAnomaliaSec(int anomaliaSecValue, ClaseAnomalia claseAnomalia) {
    _anomaliaSec = anomaliaSecValue;
    _claseAnomalia = claseAnomalia;

    final temp = anomalias
        .firstWhere((element) => element.anomaliaSec == anomaliaSec)
        .claseAnomalia
        .map((e) {
      if (!alreadyInsertReading) {
        if (!e.lectura) return e;
      } else {
        return e;
      }
    });

    if (!temp.contains(_claseAnomalia)) {
      _claseAnomalia = ClaseAnomalia.ninguna();
    }

    _observacion = claseAnomalia.observaciones.isEmpty
        ? 'Otro'
        : claseAnomalia.observaciones.first;

    notifyListeners();
  }

  late ClaseAnomalia _claseAnomalia;

  ClaseAnomalia get claseAnomalia => _claseAnomalia;

  set claseAnomalia(ClaseAnomalia value) {
    _claseAnomalia = value;
    _observacion = claseAnomalia.observaciones.isEmpty
        ? 'Otro'
        : claseAnomalia.observaciones.first;
    notifyListeners();
  }

  late String _observacion;

  String get observacion => _observacion;

  set observacion(String value) {
    _observacion = value;
    notifyListeners();
  }

  setClaseAnomaliaSinRefresh(ClaseAnomalia value) => _claseAnomalia = value;

  setObservacionSinRefresh(String value) => _observacion = value;

  late ReadingDetailItem readingDetailItem;
  late List<ReadingDetailItem> readings;

  late List<ObservacionItem> observaciones;

  Future<bool> loadInitInfo() async {
    try {
      await Future.wait([_loadAnomalias(), _loadObservaciones()],
          eagerError: true);
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

    if (readingDetailItem.readingRequest.anomaliaSec != null) {
      _anomaliaSec = readingDetailItem.readingRequest.anomaliaSec!;

      if (readingDetailItem.readingRequest.claseAnomalia ==
          ClaseAnomalia.ninguna().nombre) {
        _claseAnomalia = ClaseAnomalia.ninguna();
      } else {
        for (final element in anomalias) {
          for (final clase in element.claseAnomalia) {
            if (clase.nombre ==
                readingDetailItem.readingRequest.claseAnomalia) {
              _claseAnomalia = clase;
            }
          }
        }
      }
    } else {
      _anomaliaSec = anomalias[0].anomaliaSec;
      _claseAnomalia = ClaseAnomalia.ninguna();
    }

    if (readingDetailItem.readingRequest.observacionSec != null) {
      setObservacionSinRefresh(claseAnomalia.observaciones.isEmpty
          ? 'Otro'
          : claseAnomalia.observaciones.firstWhere((element) =>
              element == readingDetailItem.readingRequest.observacionAnomalia));
    } else {
      setObservacionSinRefresh(claseAnomalia.observaciones.isEmpty
          ? 'Otro'
          : claseAnomalia.observaciones[0]);
    }
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

  Future<void> updateReading(ReadingDetailItem readingDetailItem,
      ActivitiesBloc activitiesBloc) async {
    readingDetailState = ReadingDetailState.loading;
    notifyListeners();
    try {
      activitiesBloc.isLoading = true;
      this.readingDetailItem = await _updateReadingUseCase(readingDetailItem);
      await sl<CacheStorageInterface>().save(
          key: CacheKeys.PREVIOUS_ORDER,
          value: readingDetailItem.orden.toString());
    } on Exception {
      rethrow;
    } finally {
      readingDetailState = ReadingDetailState.initial;
      activitiesBloc.isLoading = false;
      notifyListeners();
    }
  }

  void initializeInputValues() {
    final String readingIntegersValue =
        readingDetailItem.readingRequest.lectura?.toInt().toString() ?? '';
    final String readingDecimalsValue =
        readingDetailItem.readingRequest.lectura?.toString().split('.')[1] ??
            '';

    if (readingIntegersValue.isNotEmpty) {
      readingIntegers.text = readingIntegersValue;
    } else {
      readingIntegers.clear();
    }

    if (readingDecimalsValue.isNotEmpty) {
      readingDecimals.text = readingDecimalsValue;
    } else {
      readingDecimals.clear();
    }

    observacionTextController.text =
        readingDetailItem.readingRequest.observacionLectura ?? '';

    hideError = true;
  }

  Future<void> _loadObservaciones() async {
    observaciones =
        (await sl<ObservacionesRepository>().getObservaciones()) ?? [];
  }

  void reset() {
    verifiedReading = false;
    requiredAnomaliaByMeterReading = null;
    requiredPhotoByMeterReading = null;
  }

  void refresh() => notifyListeners();

  bool allowEdit() => readingDetailItem.idRequest == null;
}
