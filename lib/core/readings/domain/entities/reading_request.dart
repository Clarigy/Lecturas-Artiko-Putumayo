import 'dart:convert';

import 'package:floor/floor.dart';

String readingRequestToJson(List<ReadingRequest> data, String tipo) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson(tipo))));

@Entity(tableName: 'readings_request')
class ReadingRequest {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  int? detalleLecturaRutaSec;
  int? detailId;
  double? lectura;
  double? lecturaIntento1;
  double? lecturaIntento2;
  int? anomaliaSec;
  String? claseAnomalia;
  int? observacionSec;
  String? observacionAnomalia;
  String? observacionLectura;
  String? latLecturaTomada;
  String? longLecturaTomada;

  @ignore
  List<String> fotos = [];

  String idFotos = '';

  ReadingRequest(
      {required this.id,
      required this.detalleLecturaRutaSec,
      required this.detailId,
      required this.lectura,
      required this.lecturaIntento1,
      required this.lecturaIntento2,
      required this.anomaliaSec,
      required this.claseAnomalia,
      required this.observacionSec,
      required this.observacionAnomalia,
      required this.observacionLectura,
      required this.latLecturaTomada,
      required this.longLecturaTomada,
      required this.idFotos});

  ReadingRequest.all(
      {this.id,
      required this.detalleLecturaRutaSec,
      this.detailId,
      this.lectura,
      this.lecturaIntento1,
      this.lecturaIntento2,
      this.anomaliaSec,
      this.claseAnomalia,
      this.observacionSec,
      this.observacionAnomalia,
      this.observacionLectura,
      this.latLecturaTomada,
      this.longLecturaTomada,
      required this.fotos,
      required this.idFotos});

  ReadingRequest.empty({required this.detalleLecturaRutaSec, this.id});

  ReadingRequest copyWith({
    int? id,
    int? detalleLecturaRutaSec,
    int? detailId,
    double? lectura,
    double? lecturaIntento1,
    double? lecturaIntento2,
    int? anomaliaSec,
    String? claseAnomalia,
    int? observacionSec,
    String? observacionAnomalia,
    String? observacionLectura,
    String? latLecturaTomada,
    String? longLecturaTomada,
    List<String>? fotos,
    String? idFotos,
  }) =>
      ReadingRequest.all(
        detalleLecturaRutaSec:
            detalleLecturaRutaSec ?? this.detalleLecturaRutaSec,
        lectura: lectura ?? this.lectura,
        lecturaIntento1: lecturaIntento1 ?? this.lecturaIntento1,
        lecturaIntento2: lecturaIntento2 ?? this.lecturaIntento2,
        anomaliaSec: anomaliaSec ?? this.anomaliaSec,
        observacionSec: observacionSec ?? this.observacionSec,
        observacionAnomalia: observacionAnomalia ?? this.observacionAnomalia,
        observacionLectura: observacionLectura ?? this.observacionLectura,
        latLecturaTomada: latLecturaTomada ?? this.latLecturaTomada,
        longLecturaTomada: longLecturaTomada ?? this.longLecturaTomada,
        claseAnomalia: claseAnomalia ?? this.claseAnomalia,
        fotos: fotos ?? this.fotos,
        id: id ?? this.id,
        idFotos: idFotos ?? this.idFotos,
        detailId: detailId ?? this.detailId,
      );

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
