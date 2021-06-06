// To parse this JSON data, do
//
//     final readingDetailResponse = readingDetailResponseFromJson(jsonString);

import 'dart:convert';

import 'package:floor/floor.dart';

ReadingDetailResponse readingDetailResponseFromJson(String str) =>
    ReadingDetailResponse.fromJson(json.decode(str));

String readingDetailResponseToJson(ReadingDetailResponse data) =>
    json.encode(data.toJson());

class ReadingDetailResponse {
  ReadingDetailResponse({
    required this.items,
  });

  List<ReadingDetailItem> items;

  factory ReadingDetailResponse.fromJson(Map<String, dynamic> json) =>
      ReadingDetailResponse(
        items: List<ReadingDetailItem>.from(
            json["items"].map((x) => ReadingDetailItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

@Entity(tableName: 'readings')
class ReadingDetailItem {
  ReadingDetailItem({
    required this.orden,
    required this.secuencia,
    required this.numeroMedidor,
    required this.tipoMedidor,
    required this.marcaMedidor,
    required this.nroEnteros,
    required this.nroDecimales,
    required this.constante,
    required this.lecturaMinima,
    required this.lecturaMaxima,
    required this.falsaMinima,
    required this.falsaMaxima,
    required this.factor,
    required this.lecturaAnterior,
    required this.claseServicio,
    required this.fechaUltimaLectura,
    this.indRangoCritica,
    this.indicadorSuspension,
    required this.nombre,
    required this.direccion,
    required this.suscriptorSec,
    required this.tipoConsumo,
    required this.nombreTipoConsumo,
    this.latPuntoMedicion,
    this.longPuntoMedicion,
    required this.detalleLecturaRutaSec,
  });

  @PrimaryKey()
  String numeroMedidor;

  int orden;
  int secuencia;
  String tipoMedidor;
  String marcaMedidor;
  int nroEnteros;
  int nroDecimales;
  int constante;
  int lecturaMinima;
  int lecturaMaxima;
  int falsaMinima;
  int falsaMaxima;
  int factor;
  String lecturaAnterior;
  String claseServicio;
  String fechaUltimaLectura;
  String? indRangoCritica;
  String? indicadorSuspension;
  String nombre;
  String direccion;
  int suscriptorSec;
  String tipoConsumo;
  String nombreTipoConsumo;
  String? latPuntoMedicion;
  String? longPuntoMedicion;
  int detalleLecturaRutaSec;

  factory ReadingDetailItem.fromJson(Map<String, dynamic> json) =>
      ReadingDetailItem(
        orden: json["orden"],
        secuencia: json["secuencia"],
        numeroMedidor: json["numero_medidor"],
        tipoMedidor: json["tipo_medidor"],
        marcaMedidor: json["marca_medidor"],
        nroEnteros: json["nro_enteros"],
        nroDecimales: json["nro_decimales"],
        constante: json["constante"],
        lecturaMinima: json["lectura_minima"],
        lecturaMaxima: json["lectura_maxima"],
        falsaMinima: json["falsa_minima"],
        falsaMaxima: json["falsa_maxima"],
        factor: json["factor"],
        lecturaAnterior: json["lectura_anterior"],
        claseServicio: json["clase_servicio"],
        fechaUltimaLectura: json["fecha_ultima_lectura"],
        indRangoCritica: json["ind_rango_critica"],
        indicadorSuspension: json["indicador_suspension"],
        nombre: json["nombre"],
        direccion: json["direccion"],
        suscriptorSec: json["suscriptor_sec"],
        tipoConsumo: json["tipo_consumo"],
        nombreTipoConsumo: json["nombre_tipo_consumo"],
        latPuntoMedicion: json["lat_punto_medicion"],
        longPuntoMedicion: json["long_punto_medicion"],
        detalleLecturaRutaSec: json["detalle_lectura_ruta_sec"],
      );

  Map<String, dynamic> toJson() => {
        "orden": orden,
        "secuencia": secuencia,
        "numero_medidor": numeroMedidor,
        "tipo_medidor": tipoMedidor,
        "marca_medidor": marcaMedidor,
        "nro_enteros": nroEnteros,
        "nro_decimales": nroDecimales,
        "constante": constante,
        "lectura_minima": lecturaMinima,
        "lectura_maxima": lecturaMaxima,
        "falsa_minima": falsaMinima,
        "falsa_maxima": falsaMaxima,
        "factor": factor,
        "lectura_anterior": lecturaAnterior,
        "clase_servicio": claseServicio,
        "fecha_ultima_lectura": fechaUltimaLectura,
        "ind_rango_critica": indRangoCritica,
        "indicador_suspension": indicadorSuspension,
        "nombre": nombre,
        "direccion": direccion,
        "suscriptor_sec": suscriptorSec,
        "tipo_consumo": tipoConsumo,
        "nombre_tipo_consumo": nombreTipoConsumo,
        "lat_punto_medicion": latPuntoMedicion,
        "long_punto_medicion": longPuntoMedicion,
        "detalle_lectura_ruta_sec": detalleLecturaRutaSec,
      };
}