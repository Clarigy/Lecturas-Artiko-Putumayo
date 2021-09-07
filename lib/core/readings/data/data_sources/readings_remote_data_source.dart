import 'package:artiko/core/http/domain/repositories/http_proxy_repository.dart';
import 'package:artiko/core/readings/domain/entities/actualizar_estado_request.dart';
import 'package:artiko/core/readings/domain/entities/new_meter_request.dart';
import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
import 'package:artiko/core/readings/domain/entities/reading_request.dart';
import 'package:artiko/core/readings/domain/entities/routes_response.dart';

class ReadingsRemoteDataSource {
  final HttpProxyInterface _httpImpl;
  final String routesService;
  final String readingDetailService;
  final String actualizarEstadoService;

  ReadingsRemoteDataSource(this._httpImpl,
      {required this.routesService,
      required this.readingDetailService,
      required this.actualizarEstadoService});

  Future<RoutesResponse> getRoutes(int lectorSec) async {
    final _http = _httpImpl.instance();

    final _response = await _http.get(
      '$routesService?lector_sec=$lectorSec',
    );

    return RoutesResponse.fromJson(_response.data);
  }

  Future<ReadingDetailResponse> getReadingDetails(int lecturaRutaSec) async {
    final _http = _httpImpl.instance();

    final _response = await _http.get(
      '$readingDetailService?lectura_ruta_sec=$lecturaRutaSec',
    );

    return ReadingDetailResponse.fromJson(_response.data, lecturaRutaSec);
  }

  Future<void> sincronizarReadings(List<ReadingRequest> readings,
      {String tipo: 'S'}) async {
    final _http = _httpImpl.instance();

    await _http.post('/actualizar_ruta',
        data: readingRequestToJson(readings, tipo));
  }

  Future<void> updateNewMeter(List<NewMeterRequestItem> readings) async {
    final _http = _httpImpl.instance();

    await _http.post('/medidor_encontrado',
        data: newMeterRequestToJson(readings));
  }

  Future<void> closeTerminal(List<ReadingRequest> readings) async {
    await sincronizarReadings(readings, tipo: 'C');
  }

  Future<void> actualizarEstado(
      ActualizarEstadoRequest actualizarEstadoRequest) async {
    final _http = _httpImpl.instance();

    await _http.post(actualizarEstadoService,
        data: actualizarEstadoRequestToJson(actualizarEstadoRequest));
  }
}
