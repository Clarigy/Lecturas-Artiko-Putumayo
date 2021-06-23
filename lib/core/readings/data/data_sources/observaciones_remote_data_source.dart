import 'package:artiko/core/http/domain/repositories/http_proxy_repository.dart';
import 'package:artiko/core/readings/domain/entities/observaciones_response.dart';
import 'package:artiko/dependency_injector.dart';

import 'observaciones_dao.dart';

class ObservacionesRemoteDataSource {
  final HttpProxyInterface _httpImpl;
  final String _service;

  ObservacionesRemoteDataSource(this._httpImpl, this._service);

  Future<void> loadAndSaveObservaciones() async {
    final _http = _httpImpl.instance();

    final _responseObservaciones = await _http.get(_service);

    final observaciones =
        observacionesResponseFromJson(_responseObservaciones.data);

    await sl<ObservacionesDao>().insertAll(observaciones.items);
  }

  Future<List<ObservacionItem>> getObservaciones() async {
    return (await sl<ObservacionesDao>().getObservaciones()) ?? [];
  }
}
