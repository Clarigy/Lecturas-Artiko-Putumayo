class Anomalia {
  Anomalia({
    required this.anomaliaSec,
    required this.anomalia,
    required this.nombre,
    required this.terminal,
    required this.telemedida,
    required this.detectable,
    required this.imprimeFactura,
    required this.revisionCritica,
    required this.fallida,
    required this.solucionCritica,
  }) : this.claseAnomalia = [];

  final int anomaliaSec;
  final String anomalia;
  final String nombre;
  final bool terminal;
  final bool telemedida;
  final bool detectable;
  final bool imprimeFactura;
  final bool revisionCritica;
  final bool fallida;
  final String? solucionCritica;
  final List<ClaseAnomalia> claseAnomalia;
}

class ClaseAnomalia {
  ClaseAnomalia({
    required this.nombre,
    required this.lectura,
    required this.fotografia,
  }) : this.observaciones = [];

  final String nombre;
  final bool lectura;
  final bool fotografia;
  final List<String> observaciones;
}
