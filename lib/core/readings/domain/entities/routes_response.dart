// To parse this JSON data, do
//
//     final routesResponse = routesResponseFromJson(jsonString);

import 'dart:convert';

import 'package:floor/floor.dart';

RoutesResponse routesResponseFromJson(String str) =>
    RoutesResponse.fromJson(json.decode(str));

String routesResponseToJson(RoutesResponse data) => json.encode(data.toJson());

class RoutesResponse {
  RoutesResponse({
    required this.items,
  });

  List<RoutesItem> items;

  factory RoutesResponse.fromJson(Map<String, dynamic> json) => RoutesResponse(
        items: List<RoutesItem>.from(
            json["items"].map((x) => RoutesItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

@Entity(tableName: 'routes')
class RoutesItem {
  RoutesItem({
    required this.nro,
    required this.lecturaRutaSec,
    required this.itinerario,
    required this.ruta,
    required this.sector,
    required this.zona,
    required this.ciclo,
    required this.nombreRuta,
    required this.nombreSector,
    required this.nombreZona,
    required this.nombreCiclo,
    required this.tipoMedicion,
    required this.totalLecturas,
    required this.lector,
    required this.lectorSec,
  });

  @PrimaryKey()
  int lecturaRutaSec;

  int nro;
  int itinerario;
  int ruta;
  int sector;
  String zona;
  int ciclo;
  String nombreRuta;
  String nombreSector;
  String nombreZona;
  String nombreCiclo;
  String tipoMedicion;
  int totalLecturas;
  String lector;
  int lectorSec;

  factory RoutesItem.fromJson(Map<String, dynamic> json) => RoutesItem(
    nro: json["nro"],
    lecturaRutaSec: json["lectura_ruta_sec"],
    itinerario: json["itinerario"],
    ruta: json["ruta"],
    sector: json["sector"],
    zona: json["zona"],
    ciclo: json["ciclo"],
    nombreRuta: json["nombre_ruta"],
    nombreSector: json["nombre_sector"],
    nombreZona: json["nombre_zona"],
    nombreCiclo: json["nombre_ciclo"],
    tipoMedicion: json["tipo_medicion"],
    totalLecturas: json["total_lecturas"],
    lector: json["lector"],
    lectorSec: json["lector_sec"],
  );

  Map<String, dynamic> toJson() => {
    "nro": nro,
    "lectura_ruta_sec": lecturaRutaSec,
    "itinerario": itinerario,
    "ruta": ruta,
    "sector": sector,
    "zona": zona,
    "ciclo": ciclo,
    "nombre_ruta": nombreRuta,
    "nombre_sector": nombreSector,
    "nombre_zona": nombreZona,
    "nombre_ciclo": nombreCiclo,
    "tipo_medicion": tipoMedicion,
    "total_lecturas": totalLecturas,
    "lector": lector,
    "lector_sec": lectorSec,
  };
}
