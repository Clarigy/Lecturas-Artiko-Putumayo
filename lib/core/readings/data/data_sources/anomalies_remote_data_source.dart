import 'package:artiko/core/http/domain/repositories/http_proxy_repository.dart';
import 'package:artiko/core/readings/domain/entities/anomalies_response.dart';

class AnomaliesRemoteDataSource {
  final HttpProxyInterface _httpImpl;
  final String _service;

  AnomaliesRemoteDataSource(this._httpImpl, this._service);

  Future<AnomaliesResponse> getAnomalies() async {
    final _http = _httpImpl.instance();

    final _response = await _http.get('$_service');

    return AnomaliesResponse.fromJson(_response.data);
  }
}
