class Anomalia {
  Anomalia({
    required this.anomaliaSec,
    required this.anomalia,
    required this.terminal,
    required this.telemedida,
    required this.detectable,
    required this.imprimeFactura,
    required this.revisionCritica,
    required this.solucionCritica,
    required this.nombreClase,
  }) : this.claseAnomalia = [];

  final int anomaliaSec;
  final String anomalia;
  final String nombreClase;
  final bool terminal;
  final bool telemedida;
  final bool detectable;
  final bool imprimeFactura;
  final bool revisionCritica;
  final String? solucionCritica;
  final List<ClaseAnomalia> claseAnomalia;
}

class ClaseAnomalia {
  ClaseAnomalia({
    required this.nombre,
    required this.lectura,
    required this.anomSec,
    required this.fallida,
    required this.fotografia,
  }) : this.observaciones = [];

  ClaseAnomalia.ninguna()
      : this.nombre = 'Ninguna',
        this.observaciones = [],
        this.lectura = true,
        this.anomSec = -1,
        this.fallida = false,
        this.fotografia = false;

  final String nombre;
  final bool lectura;
  final bool fotografia;
  final bool fallida;
  final int anomSec;
  final List<String> observaciones;

  bool operator ==(dynamic other) =>
      other != null &&
      other is ClaseAnomalia &&
      this.nombre == other.nombre &&
      this.lectura == other.lectura &&
      this.fotografia == other.fotografia;

  @override
  int get hashCode => super.hashCode;
}
