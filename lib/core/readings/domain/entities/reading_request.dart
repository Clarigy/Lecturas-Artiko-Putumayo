class ReadingRequest {
  ReadingRequest({
    required this.detalleLecturaRutaSec,
    required this.lectura,
    required this.lecturaIntento1,
    required this.lecturaIntento2,
    required this.anomaliaSec,
    required this.observacionSec,
    required this.observacionAnomalia,
    required this.observacionLectura,
    required this.origenLectura,
    required this.latLecturaTomada,
    required this.longLecturaTomada,
    required this.tipo,
    required this.fotos,
  });

  final int detalleLecturaRutaSec;
  final int lectura;
  final int lecturaIntento1;
  final int lecturaIntento2;
  final int anomaliaSec;
  final int observacionSec;
  final String observacionAnomalia;
  final String observacionLectura;
  final String origenLectura;
  final String latLecturaTomada;
  final String longLecturaTomada;
  final String tipo;
  final List<String> fotos;
}
