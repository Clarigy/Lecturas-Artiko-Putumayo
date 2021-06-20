import 'package:artiko/core/readings/data/data_sources/readings_dao.dart';
import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
import 'package:artiko/core/readings/domain/use_case/save_readings_use_case.dart';
import 'package:artiko/dependency_injector.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CreateMeasureBloc extends ChangeNotifier {
  CreateMeasureBloc(
    this._saveReadingsUseCase,
  );

  final SaveReadingsUseCase _saveReadingsUseCase;

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
      isLoading = true;
      return await _saveReadingsUseCase(newMeasures);
    } catch (_) {
      isLoading = false;

      rethrow;
    }
  }

  Future<List<ReadingDetailItem>?> getReadings() async {
    try {
      return await sl<ReadingsDao>().getFutureReadings();
    } catch (_) {
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  List<ReadingDetailItem> buildReadingDetailItem(
      List<ReadingDetailItem> readings) {
    double promedio = 0;
    readings.forEach((element) {
      promedio += element.detalleLecturaRutaSec;
    });

    promedio /= readings.length;

    return tiposConsumoSeleccionados
        .map((e) => ReadingDetailItem(
        orden: 0,
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
        detalleLecturaRutaSec: promedio.toInt()))
        .toList();
  }
}
