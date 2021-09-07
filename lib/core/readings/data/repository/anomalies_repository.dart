import 'package:artiko/core/error/exception.dart';
import 'package:artiko/core/readings/data/data_sources/anomalies_dao.dart';
import 'package:artiko/core/readings/data/data_sources/anomalies_remote_data_source.dart';
import 'package:artiko/core/readings/data/repository/observaciones_repository.dart';
import 'package:artiko/core/readings/domain/entities/anomalia.dart';
import 'package:artiko/core/readings/domain/entities/anomalies_response.dart';
import 'package:artiko/core/readings/domain/entities/observaciones_response.dart';
import 'package:artiko/core/readings/domain/repositories/anomalies_repository_contract.dart';
import 'package:artiko/dependency_injector.dart';

class AnomaliesRepository implements AnomaliesRepositoryContract {
  final AnomaliesRemoteDataSource _remoteDataSource;
  final AnomaliesDao _anomaliesDao;

  AnomaliesRepository(this._remoteDataSource, this._anomaliesDao);

  @override
  Future<AnomaliesResponse> loadAndSaveAnomalies() async {
    try {
      final anomalies = await _remoteDataSource.getAnomalies();
      await saveAnomalies(anomalies.items);
      return anomalies;
    } catch (_) {
      throw ServerException();
    }
  }

  Future<List<Anomalia>> getAnomalies() async {
    final anomaliesResponse = await loadAnomalies();
    final observaciones =
        await sl<ObservacionesRepository>().getObservaciones();
    if (anomaliesResponse == null || observaciones == null) return [];
    return _convertAnomaliesResponseToAnomalias(
        anomaliesResponse, observaciones);
  }

  List<Anomalia> _convertAnomaliesResponseToAnomalias(
      List<AnomalyItem> anomalies, List<ObservacionItem> observaciones) {
    final List<Anomalia> anomalias = [];
    final Set<String> claseAnomalias = Set.of([]);

    anomalies.forEach((element) {
      claseAnomalias.add(element.clase);
    });

    claseAnomalias.forEach((element) {
      final temp = anomalies.where((x) => x.clase == element).toList();

      final tempItem1 = temp[0];

      final anomalia = Anomalia(
        anomaliaSec: tempItem1.anomaliaSec,
        anomalia: tempItem1.anomalia,
        terminal: tempItem1.terminal,
        telemedida: tempItem1.telemedida,
        detectable: tempItem1.detectable,
        imprimeFactura: tempItem1.imprimeFactura,
        revisionCritica: tempItem1.revisionCritica,
        solucionCritica: tempItem1.solucionCritica,
        nombreClase: tempItem1.nombreClase,
      );

      temp.forEach((tmp) {
        final clase = ClaseAnomalia(
          nombre: tmp.nombre,
          lectura: tmp.lectura,
          fotografia: tmp.fotografia,
          anomSec: tmp.anomaliaSec,
          fallida: tmp.fallida,
          cierre: tmp.cierre,
        );

        final tempObservaciones = observaciones
            .where((element) => element.anomaliaSec == tmp.anomaliaSec)
            .toList();

        tempObservaciones.forEach((element) {
          clase.observaciones.add(element.descripcion);
        });

        anomalia.claseAnomalia.add(clase);
      });

      anomalias.add(anomalia);
    });

    return anomalias;
  }

  Future<void> saveAnomalies(List<AnomalyItem> anomalies) async {
    try {
      await _anomaliesDao.insertAll(anomalies);

      final x = await _anomaliesDao.getAnomalies();
      print(x);
    } catch (_) {
      throw ServerException();
    }
  }

  Future<List<AnomalyItem>?> loadAnomalies() async {
    try {
      return await _anomaliesDao.getAnomalies();
    } catch (_) {
      throw ServerException();
    }
  }
}
