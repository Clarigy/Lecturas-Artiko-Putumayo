// To parse this JSON data, do
//
//     final observacionesResponse = observacionesResponseFromJson(jsonString);

import 'dart:convert';

import 'package:floor/floor.dart';

ObservacionesResponse observacionesResponseFromJson(
        Map<String, dynamic> data) =>
    ObservacionesResponse.fromJson(data);

String observacionesResponseToJson(ObservacionesResponse data) =>
    json.encode(data.toJson());

class ObservacionesResponse {
  ObservacionesResponse({
    required this.items,
  });

  final List<ObservacionItem> items;

  ObservacionesResponse copyWith({
    List<ObservacionItem>? items,
  }) =>
      ObservacionesResponse(
        items: items ?? this.items,
      );

  factory ObservacionesResponse.fromJson(Map<String, dynamic> json) =>
      ObservacionesResponse(
        items: List<ObservacionItem>.from(
            json["items"].map((x) => ObservacionItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

@Entity(tableName: 'observaciones')
class ObservacionItem {
  ObservacionItem({
    required this.observacionSec,
    required this.codigo,
    required this.descripcion,
    required this.anomaliaSec,
  });

  @primaryKey
  final int observacionSec;

  final String codigo;
  final String descripcion;
  final int anomaliaSec;

  ObservacionItem copyWith({
    int? observacionSec,
    String? codigo,
    String? descripcion,
    int? anomaliaSec,
  }) =>
      ObservacionItem(
        observacionSec: observacionSec ?? this.observacionSec,
        codigo: codigo ?? this.codigo,
        descripcion: descripcion ?? this.descripcion,
        anomaliaSec: anomaliaSec ?? this.anomaliaSec,
      );

  factory ObservacionItem.fromJson(Map<String, dynamic> json) =>
      ObservacionItem(
        observacionSec: json["observacion_sec"],
        codigo: json["codigo"],
        descripcion: json["descripcion"],
        anomaliaSec: json["anomalia_sec"],
      );

  Map<String, dynamic> toJson() => {
        "observacion_sec": observacionSec,
        "codigo": codigo,
        "descripcion": descripcion,
        "anomalia_sec": anomaliaSec,
      };
}
