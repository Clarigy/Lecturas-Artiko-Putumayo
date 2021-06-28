// To parse this JSON data, do
//
//     final newMeterRequest = newMeterRequestFromJson(jsonString);

import 'dart:convert';

import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';

NewMeterRequest newMeterRequestFromJson(String str) =>
    NewMeterRequest.fromJson(json.decode(str));

String newMeterRequestToJson(List<NewMeterRequestItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NewMeterRequest {
  NewMeterRequest({
    required this.items,
  });

  final List<NewMeterRequestItem> items;

  factory NewMeterRequest.fromJson(Map<String, dynamic> json) =>
      NewMeterRequest(
        items: List<NewMeterRequestItem>.from(
            json["items"].map((x) => NewMeterRequestItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class NewMeterRequestItem {
  NewMeterRequestItem({
    required this.detalleLecturaRutaSec,
    required this.lecturaRutaSec,
    required this.ordenAnterior,
    required this.orden,
    required this.ordenSiguiente,
    required this.claseServicio,
    required this.latPuntoMedida,
    required this.longPuntoMedida,
    required this.numeroMedidor,
    required this.marcaMedidor,
    required this.tipoMedidor,
    required this.nroEnteros,
    required this.nroDecimales,
    required this.lectura,
    required this.lecturaIntento1,
    required this.lecturaIntento2,
    required this.anomaliaSec,
    required this.observacionSec,
    required this.observacionAnomalia,
    required this.origenLectura,
    required this.latLecturaTomada,
    required this.longLecturaTomada,
    required this.tipoRegistro,
    required this.fotos,
  });

  NewMeterRequestItem.fromReadingDetail(
    ReadingDetailItem readingDetailItem, {
    required this.ordenAnterior,
    required this.orden,
  })  : this.detalleLecturaRutaSec = readingDetailItem.detalleLecturaRutaSec,
        this.lecturaRutaSec = readingDetailItem.lecturaRutaSec,
        this.claseServicio = readingDetailItem.claseServicio,
        this.latPuntoMedida = readingDetailItem.latPuntoMedicion,
        this.longPuntoMedida = readingDetailItem.longPuntoMedicion,
        this.numeroMedidor = readingDetailItem.numeroMedidor,
        this.marcaMedidor = readingDetailItem.marcaMedidor,
        this.tipoMedidor = readingDetailItem.tipoMedidor,
        this.nroEnteros = readingDetailItem.nroEnteros,
        this.nroDecimales = readingDetailItem.nroDecimales,
        this.lectura = readingDetailItem.readingRequest.lectura,
        this.lecturaIntento1 = readingDetailItem.readingRequest.lecturaIntento1,
        this.lecturaIntento2 = readingDetailItem.readingRequest.lecturaIntento2,
        this.anomaliaSec = readingDetailItem.anomSec,
        this.observacionSec = readingDetailItem.readingRequest.observacionSec,
        this.observacionAnomalia =
            readingDetailItem.readingRequest.observacionAnomalia,
        this.origenLectura = 'Terreno',
        this.latLecturaTomada =
            readingDetailItem.readingRequest.latLecturaTomada,
        this.longLecturaTomada =
            readingDetailItem.readingRequest.longLecturaTomada,
        this.tipoRegistro = 'C',
        this.ordenSiguiente = null,
        this.fotos = readingDetailItem.readingRequest.fotos
            .map((e) => Foto(
                foto: e,
                filename:
                    '${readingDetailItem.detalleLecturaRutaSec ?? ''}-${readingDetailItem.readingRequest.fotos.indexOf(e)}',
                mimetype: 'png'))
            .toList();

  final int? detalleLecturaRutaSec;
  final int lecturaRutaSec;
  final int? ordenAnterior;
  final int? orden;
  final int? ordenSiguiente;
  final String claseServicio;
  final String? latPuntoMedida;
  final String? longPuntoMedida;
  final String numeroMedidor;
  final String marcaMedidor;
  final String tipoMedidor;
  final int nroEnteros;
  final int nroDecimales;
  final double? lectura;
  final double? lecturaIntento1;
  final double? lecturaIntento2;
  final int? anomaliaSec;
  final int? observacionSec;
  final String? observacionAnomalia;
  final String origenLectura;
  final String? latLecturaTomada;
  final String? longLecturaTomada;
  final String tipoRegistro;
  final List<Foto> fotos;

  factory NewMeterRequestItem.fromJson(Map<String, dynamic> json) =>
      NewMeterRequestItem(
        detalleLecturaRutaSec: json["detalle_lectura_ruta_sec"],
        lecturaRutaSec: json["lectura_ruta_sec"],
        ordenAnterior: json["orden_anterior"],
        orden: json["orden"],
        ordenSiguiente: json["orden_siguiente"],
        claseServicio: json["clase_servicio"],
        latPuntoMedida: json["lat_punto_medida"],
        longPuntoMedida: json["long_punto_medida"],
        numeroMedidor: json["numero_medidor"],
        marcaMedidor: json["marca_medidor"],
        tipoMedidor: json["tipo_medidor"],
        nroEnteros: json["nro_enteros"],
        nroDecimales: json["nro_decimales"],
        lectura: json["lectura"],
        lecturaIntento1: json["lectura_intento_1"],
        lecturaIntento2: json["lectura_intento_2"],
        anomaliaSec: json["anomalia_sec"],
        observacionSec: json["observacion_sec"],
        observacionAnomalia: json["observacion_anomalia"],
        origenLectura: json["origen_lectura"],
        latLecturaTomada: json["lat_lectura_tomada"],
        longLecturaTomada: json["long_lectura_tomada"],
        tipoRegistro: json["tipo_registro"],
        fotos: List<Foto>.from(json["fotos"].map((x) => Foto.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "detalle_lectura_ruta_sec": detalleLecturaRutaSec,
        "lectura_ruta_sec": lecturaRutaSec,
        "orden_anterior": ordenAnterior,
        "orden": orden,
        "orden_siguiente": ordenSiguiente,
        "clase_servicio": claseServicio,
        "lat_punto_medida": latPuntoMedida,
        "long_punto_medida": longPuntoMedida,
        "numero_medidor": numeroMedidor,
        "marca_medidor": marcaMedidor,
        "tipo_medidor": tipoMedidor,
        "nro_enteros": nroEnteros,
        "nro_decimales": nroDecimales,
        "lectura": lectura,
        "lectura_intento_1": lecturaIntento1,
        "lectura_intento_2": lecturaIntento2,
        "anomalia_sec": anomaliaSec,
        "observacion_sec": observacionSec,
        "observacion_anomalia": observacionAnomalia,
        "origen_lectura": origenLectura,
        "lat_lectura_tomada": latLecturaTomada,
        "long_lectura_tomada": longLecturaTomada,
        "tipo_registro": tipoRegistro,
        "fotos": List<dynamic>.from(fotos.map((x) => x.toJson())),
      };
}

class Foto {
  Foto({
    required this.foto,
    required this.filename,
    required this.mimetype,
  });

  final String foto;
  final String filename;
  final String mimetype;

  factory Foto.fromJson(Map<String, dynamic> json) => Foto(
        foto: json["foto"],
        filename: json["filename"],
        mimetype: json["mimetype"],
      );

  Map<String, dynamic> toJson() => {
        "foto": foto,
        "filename": filename,
        "mimetype": mimetype,
      };
}
