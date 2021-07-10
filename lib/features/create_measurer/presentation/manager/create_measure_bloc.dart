import 'package:artiko/core/cache/domain/repositories/cache_storage_repository.dart';
import 'package:artiko/core/cache/keys/cache_keys.dart';
import 'package:artiko/core/readings/data/repository/reading_repository.dart';
import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
import 'package:artiko/core/readings/domain/use_case/save_readings_use_case.dart';
import 'package:artiko/dependency_injector.dart';
import 'package:artiko/features/home/presentation/pages/activities_page/activities_bloc.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateMeasureBloc extends ChangeNotifier {
  CreateMeasureBloc(
    this._saveReadingsUseCase,
    this._cacheStorageInterface,
  );

  final SaveReadingsUseCase _saveReadingsUseCase;
  final CacheStorageInterface _cacheStorageInterface;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController locationTextEditingController = TextEditingController();
  TextEditingController numeroMedidorTextEditingController =
      TextEditingController();
  TextEditingController marcaMedidorTextEditingController =
      TextEditingController();
  TextEditingController enterosTextEditingController = TextEditingController();
  TextEditingController decimalesTextEditingController =
      TextEditingController();

  final clasesServicio = ['Residencial', 'Oficial', 'Comercial'];
  final tiposConsumo = {
    'A': {'nombreTipoConsumo': 'ENERGIA ACTIVA', 'tipoConsumo': 'ENA'},
    'R': {'nombreTipoConsumo': 'ENERGIA REACTIVA', 'tipoConsumo': 'ENR'}
  };

  late LatLng latLng;
  late String _claseServicio;
  late Set<String> tiposConsumoSeleccionados;

  String get claseServicio => _claseServicio;

  set claseServicio(String value) {
    _claseServicio = value;
    notifyListeners();
  }

  late String location;
  late String numeroMedidor;
  late String marcaMedidor;
  late String enteros;
  late String decimales;

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  late bool isFromMap;

  Future<void> loadInitialData() async {
    final location = await Geolocator.getCurrentPosition();
    latLng = LatLng(location.latitude, location.longitude);

    locationTextEditingController.text =
        '${location.latitude} ${location.longitude}';

    _claseServicio = clasesServicio[0];
    tiposConsumoSeleccionados = Set.of(['A']);

    isLoading = false;
  }

  Future<List<int>> createMeasures(List<ReadingDetailItem> newMeasures) async {
    try {
      return await _saveReadingsUseCase(newMeasures);
    } catch (_) {
      isLoading = false;
      rethrow;
    }
  }

  Future<List<ReadingDetailItem>?> getReadings(FilterType filterType) async {
    try {
      return await sl<ReadingRepository>().getAllReadingsFuture(filterType);
    } catch (_) {
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  Future<List<ReadingDetailItem>> buildReadingDetailItem(
      List<ReadingDetailItem> readings) async {
    final List<ReadingDetailItem> tempReadings = [];
    for (final e in tiposConsumoSeleccionados) {
      String? ordenAnterior =
          await _cacheStorageInterface.fetch(CacheKeys.PREVIOUS_ORDER);

      if (ordenAnterior == null) {
        int max = readings.first.orden;
        readings.forEach((e) {
          if (e.orden > max) max = e.orden;
        });

        ordenAnterior = max.toString();
      }

      await _cacheStorageInterface.save(
          key: CacheKeys.PREVIOUS_ORDER,
          value: (int.parse(ordenAnterior)).toString());

      tempReadings.add(ReadingDetailItem.other(
          orden: int.parse(ordenAnterior) + 1,
          secuencia: 0,
          numeroMedidor: numeroMedidor,
          tipoMedidor: 'EM-ELECTROMECANICO',
          marcaMedidor: marcaMedidor,
          nroEnteros: int.parse(enteros),
          nroDecimales: int.parse(decimales),
          constante: 1,
          lecturaMinima: 0,
          lecturaMaxima: 9999999999,
          falsaMinima: 0,
          falsaMaxima: 9999999999,
          factor: 1,
          lecturaAnterior: "0",
          claseServicio: _claseServicio,
          fechaUltimaLectura: null,
          indicadorSuspension: false,
          nombre: '',
          direccion: '',
          suscriptorSec: 0,
          tipoConsumo: tiposConsumo[e]!['tipoConsumo']!,
          nombreTipoConsumo: tiposConsumo[e]!['nombreTipoConsumo']!,
          detalleLecturaRutaSec: null,
          anomSec: null,
          lecturaRutaSec: readings[0].lecturaRutaSec));
    }
    return tempReadings;
  }
}
