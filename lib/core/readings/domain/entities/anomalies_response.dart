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
    required this.cierre,
    required this.solucionCritica,
    required this.claseAnomalia,
  });

  @PrimaryKey()
  int anomaliaSec;

  String anomalia;
  String nombre;
  String observacion;
  bool fotografia;
  bool lectura;
  bool terminal;
  bool telemedida;
  bool detectable;
  bool promediable;
  bool imprimeFactura;
  bool revisionCritica;
  bool fallida;
  bool cierre;
  String solucionCritica;
  String claseAnomalia;

  factory AnomalyItem.fromJson(Map<String, dynamic> json) => AnomalyItem(
        anomaliaSec: json["anomalia_sec"],
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
        cierre: json["cierre"] == 'S',
        solucionCritica: json["solucion_critica"],
        claseAnomalia: json["clase_anomalia"],
      );

  Map<String, dynamic> toJson() => {
        "anomalia_sec": anomaliaSec,
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
        "cierre": cierre,
        "solucion_critica": solucionCritica,
        "clase_anomalia": claseAnomalia,
      };
}
