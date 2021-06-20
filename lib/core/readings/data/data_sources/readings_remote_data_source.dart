import 'package:artiko/core/error/exception.dart';
import 'package:artiko/core/http/domain/repositories/http_proxy_repository.dart';
import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
import 'package:artiko/core/readings/domain/entities/reading_request.dart';
import 'package:artiko/core/readings/domain/entities/routes_response.dart';

class ReadingsRemoteDataSource {
  final HttpProxyInterface _httpImpl;
  final String routesService;
  final String readingDetailService;

  ReadingsRemoteDataSource(this._httpImpl,
      {required this.routesService, required this.readingDetailService});

  Future<RoutesResponse> getRoutes(int lectorSec) async {
    final _http = _httpImpl.instance();

    final _response = await _http.get(
      '$routesService?lector_sec=$lectorSec',
    );

    return RoutesResponse.fromJson(_response.data);
  }

  Future<ReadingDetailResponse> getReadingDetails(int lecturaRutaSec) async {
    try {
      final _http = _httpImpl.instance();

      final _response = await _http.get(
        '$readingDetailService?lectura_ruta_sec=$lecturaRutaSec',
      );

      return ReadingDetailResponse.fromJson(_response.data);
    } catch (e) {
      print(e);
      return ReadingDetailResponse(items: []);
    }
  }

  Future<void> sincronizarReadings(List<ReadingRequest> readings,
      {String tipo: 'S'}) async {
    try {
      final _http = _httpImpl.instance();

      await _http.post('/actualizar_ruta',
          data: readingRequestToJson(readings, tipo));
    } catch (e) {
      throw ServerException();
    }
  }

  Future<void> closeTerminal(List<ReadingRequest> readings) async {
    await sincronizarReadings(readings, tipo: 'C');
  }
}
