// To parse this JSON data, do
//
//     final readingDetailItem = readingDetailItemFromJson(jsonString);

import 'dart:convert';

import 'package:floor/floor.dart';

AnomaliesResponse readingDetailItemFromJson(String str) =>
    AnomaliesResponse.fromJson(json.decode(str));

class AnomaliesResponse {
  AnomaliesResponse({
    required this.items,
  });

  List<AnomalyItem> items;

  factory AnomaliesResponse.fromJson(Map<String, dynamic> json) =>
      AnomaliesResponse(
        items: List<AnomalyItem>.from(
            json["items"].map((x) => AnomalyItem.fromJson(x))),
      );
}

@Entity(tableName: 'anomalies')
class AnomalyItem {
  AnomalyItem({
    required this.anomaliaSec,
    required this.clase,
    required this.nombreClase,
    required this.anomalia,
    required this.nombre,
    required this.fotografia,
    required this.lectura,
    required this.terminal,
    required this.telemedida,
    required this.observacion,
    required this.detectable,
    required this.promediable,
    required this.imprimeFactura,
    required this.revisionCritica,
    required this.fallida,
    required this.solucionCritica,
  });

  @PrimaryKey()
  final int anomaliaSec;
  final String clase;
  final String nombreClase;
  final String anomalia;
  final String nombre;
  final String? observacion;
  final bool fotografia;
  final bool lectura;
  final bool terminal;
  final bool telemedida;
  final bool detectable;
  final bool promediable;
  final bool imprimeFactura;
  final bool revisionCritica;
  final bool fallida;
  final String? solucionCritica;

  factory AnomalyItem.fromJson(Map<String, dynamic> json) => AnomalyItem(
        anomaliaSec: json["anomalia_sec"],
        clase: json["clase"],
        nombreClase: json["nombre_clase"],
        anomalia: json["anomalia"],
        nombre: json["nombre"],
        observacion: json["observacion"],
        fotografia: json["fotografia"] == 'S',
        lectura: json["lectura"] == 'S',
        terminal: json["terminal"] == 'S',
        telemedida: json["telemedida"] == 'S',
        detectable: json["detectable"] == 'S',
        promediable: json["promediable"] == 'S',
        imprimeFactura: json["imprime_factura"] == 'S',
        revisionCritica: json["revision_critica"] == 'S',
        fallida: json["fallida"] == 'S',
        solucionCritica: json["solucion_critica"],
      );

  Map<String, dynamic> toJson() => {
        "anomalia_sec": anomaliaSec,
        "clase": clase,
        "nombre_clase": nombreClase,
        "anomalia": anomalia,
        "nombre": nombre,
        "fotografia": fotografia,
        "lectura": lectura,
        "terminal": terminal,
        "telemedida": telemedida,
        "observacion": observacion,
        "detectable": detectable,
        "promediable": promediable,
        "imprime_factura": imprimeFactura,
        "revision_critica": revisionCritica,
        "fallida": fallida,
        "solucion_critica": solucionCritica,
      };
}
