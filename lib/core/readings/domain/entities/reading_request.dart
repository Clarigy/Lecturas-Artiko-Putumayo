import 'dart:convert';

String readingRequestToJson(List<ReadingRequest> data, String tipo) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson(tipo))));

class ReadingRequest {
  int detalleLecturaRutaSec;
  double? lectura;
  double? lecturaIntento1;
  double? lecturaIntento2;
  int? anomaliaSec;
  int? observacionSec;
  String? observacionAnomalia;
  String? observacionLectura;
  String? latLecturaTomada;
  String? longLecturaTomada;
  List<String> fotos = [];

  ReadingRequest({required this.detalleLecturaRutaSec});

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
        detalleLecturaRutaSec:
            detalleLecturaRutaSec ?? this.detalleLecturaRutaSec,
      );

  ReadingRequest.all(
      {this.lectura,
      this.lecturaIntento1,
      this.lecturaIntento2,
      required this.detalleLecturaRutaSec});

  Map<String, dynamic> toJson(String tipo) => {
        "detalle_lectura_ruta_sec": detalleLecturaRutaSec,
        "lectura": lectura,
        "lectura_intento_1": lecturaIntento1,
        "lectura_intento_2": lecturaIntento2,
        "anomalia_sec": anomaliaSec,
        "observacion_sec": observacionSec,
        "observacion_anomalia": observacionAnomalia,
        "observacion_lectura": observacionLectura,
        "origen_lectura": 'Terreno',
        "lat_lectura_tomada": latLecturaTomada,
        "long_lectura_tomada": longLecturaTomada,
        "tipo": tipo,
        "fotos": List<dynamic>.from(fotos.map((image) => {
              'image': image,
              'filename': '$detalleLecturaRutaSec-${fotos.indexOf(image)}',
              'mimetype': 'png'
            })),
      };
}
