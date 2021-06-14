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

  ClaseAnomalia.otro()
      : this.nombre = 'Otro',
        this.observaciones = [],
        this.lectura = true,
        this.fotografia = true;

  final String nombre;
  final bool lectura;
  final bool fotografia;
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
