import '../../dependency_injector.dart';
import 'data/data_sources/anomalies_dao.dart';
import 'domain/entities/anomalies_response.dart';

class AllAnomalies {
  static final AllAnomalies _singleton = AllAnomalies._internal();

  factory AllAnomalies() {
    return _singleton;
  }

  AllAnomalies._internal();

  late List<AnomalyItem>? _anomalias;

  List<AnomalyItem>? get anomalias => _anomalias;

  Future<void> initialize() async {
    _anomalias = await sl<AnomaliesDao>().getAnomalies();
  }
}
