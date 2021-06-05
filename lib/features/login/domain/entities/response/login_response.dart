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
    this.foto,
    required this.cargo,
    required this.correoLector,
    this.telefonoLector,
    required this.empresa,
    required this.supervisor,
    required this.telefonoSupervisor,
    required this.correoSupervisor,
    required this.contrato,
    required this.lectorSec,
  });

  @primaryKey
  int idUsuario;
  String nombre;
  String? foto;
  String cargo;
  String correoLector;
  String? telefonoLector;
  String empresa;
  String supervisor;
  String telefonoSupervisor;
  String correoSupervisor;
  String contrato;
  int lectorSec;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        idUsuario: json["id_usuario"],
        nombre: json["nombre"],
        foto: json["foto"],
        cargo: json["cargo"],
        correoLector: json["correo_lector"],
        telefonoLector: json["telefono_lector"],
        empresa: json["empresa"],
        supervisor: json["supervisor"],
        telefonoSupervisor: json["telefono_supervisor"],
        correoSupervisor: json["correo_supervisor"],
        contrato: json["contrato"],
        lectorSec: json["lector_sec"],
      );

  Map<String, dynamic> toJson() => {
        "id_usuario": idUsuario,
        "nombre": nombre,
        "foto": foto,
        "cargo": cargo,
        "correo_lector": correoLector,
        "telefono_lector": telefonoLector,
        "empresa": empresa,
        "supervisor": supervisor,
        "telefono_supervisor": telefonoSupervisor,
        "correo_supervisor": correoSupervisor,
        "contrato": contrato,
        "lector_sec": lectorSec,
      };
}
