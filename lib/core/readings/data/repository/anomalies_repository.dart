import 'package:artiko/core/error/exception.dart';
import 'package:artiko/core/readings/data/data_sources/anomalies_dao.dart';
import 'package:artiko/core/readings/data/data_sources/anomalies_remote_data_source.dart';
import 'package:artiko/core/readings/domain/entities/anomalia.dart';
import 'package:artiko/core/readings/domain/entities/anomalies_response.dart';
import 'package:artiko/core/readings/domain/repositories/anomalies_repository_contract.dart';

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
    if (anomaliesResponse == null) return [];
    return _convertAnomaliesResponseToAnomalias(anomaliesResponse);
  }

  List<Anomalia> _convertAnomaliesResponseToAnomalias(
      List<AnomalyItem> anomalies) {
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
        nombre: tempItem1.nombre,
        terminal: tempItem1.terminal,
        telemedida: tempItem1.telemedida,
        detectable: tempItem1.detectable,
        imprimeFactura: tempItem1.imprimeFactura,
        revisionCritica: tempItem1.revisionCritica,
        fallida: tempItem1.fallida,
        solucionCritica: tempItem1.solucionCritica,
      );

      temp.forEach((tmp) {
        final clase = ClaseAnomalia(
            nombre: tmp.nombre,
            lectura: tmp.lectura,
            fotografia: tmp.fotografia);

        if (tmp.observacion != null) {
          clase.observaciones.add(tmp.observacion!);
        }

        anomalia.claseAnomalia.add(clase);
      });

      anomalias.add(anomalia);
    });

    return anomalias;
  }

  Future<void> saveAnomalies(List<AnomalyItem> anomalies) async {
    try {
      await _anomaliesDao.insertAll(anomalies);
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
