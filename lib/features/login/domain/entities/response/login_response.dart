// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    required this.idUsuario,
    required this.nombre,
    required this.cargo,
    required this.correoLector,
    required this.telefonoLector,
    required this.empresa,
    required this.supervisor,
    required this.telefonoSupervisor,
    required this.contrato,
    required this.correoSupervisor,
    required this.lectorSec,
    required this.href,
  });

  int idUsuario;
  String nombre;
  String cargo;
  String? correoLector;
  String? telefonoLector;
  String? empresa;
  String? supervisor;
  String? telefonoSupervisor;
  String? correoSupervisor;
  String contrato;
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
        contrato: json["contrato"],
        lectorSec: json["lector_sec"],
        href: json['href'] == null ? json['links'][0]['href'] : json['href'],
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
        "contrato": contrato,
      };
}
