// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

import 'package:floor/floor.dart';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

@Entity(tableName: 'current_user')
class LoginResponse {
  LoginResponse({
    required this.idUsuario,
    required this.nombre,
    required this.cargo,
    required this.correoLector,
    this.telefonoLector,
    this.empresa,
    this.supervisor,
    this.telefonoSupervisor,
    this.correoSupervisor,
    required this.lectorSec,
    required this.href,
  });

  @primaryKey
  int idUsuario;
  String nombre;
  String cargo;
  @ColumnInfo(name: 'correoLector')
  String correoLector;
  String? telefonoLector;
  String? empresa;
  String? supervisor;
  String? telefonoSupervisor;
  String? correoSupervisor;
  int lectorSec;
  String href;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        idUsuario: json["id_usuario"],
        nombre: json["nombre"],
        cargo: json["cargo"],
        correoLector: json["correo_lector"],
        telefonoLector: json["telefono_lector"],
        empresa: json["empresa"],
        supervisor: json["supervisor"],
        telefonoSupervisor: json["telefono_supervisor"],
        correoSupervisor: json["correo_supervisor"],
        lectorSec: json["lector_sec"],
        href: json["links"][0]['href'],
      );

  Map<String, dynamic> toJson() => {
        "id_usuario": idUsuario,
        "nombre": nombre,
        "cargo": cargo,
        "correo_lector": correoLector,
        "telefono_lector": telefonoLector,
        "empresa": empresa,
        "supervisor": supervisor,
        "telefono_supervisor": telefonoSupervisor,
        "correo_supervisor": correoSupervisor,
        "lector_sec": lectorSec,
        "href": href,
      };
}
