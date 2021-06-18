class ReadingRequest {
  late int detalleLecturaRutaSec;
  double? lectura;
  double? lecturaIntento1;
  double? lecturaIntento2;
  late int anomaliaSec;
  late int observacionSec;
  late String observacionAnomalia;
  late String observacionLectura;
  late String origenLectura;
  late String latLecturaTomada;
  late String longLecturaTomada;
  late String tipo;
  List<String> fotos = [];

  ReadingRequest();

  ReadingRequest copyWith({
    int? detalleLecturaRutaSec,
    double? lectura,
    double? lecturaIntento1,
    double? lecturaIntento2,
    int? anomaliaSec,
    int? observacionSec,
    String? observacionAnomalia,
    String? observacionLectura,
    String? origenLectura,
    String? latLecturaTomada,
    String? longLecturaTomada,
    String? tipo,
    List<String>? fotos,
  }) =>
      ReadingRequest.all(
        lectura: lectura ?? this.lectura,
        lecturaIntento1: lecturaIntento1 ?? this.lecturaIntento1,
        lecturaIntento2: lecturaIntento2 ?? this.lecturaIntento2,
      );

  ReadingRequest.all({
    this.lectura,
    this.lecturaIntento1,
    this.lecturaIntento2,
  });
}
