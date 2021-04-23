// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));

class LoginResponse {
  LoginResponse({
    required this.idUsuario,
    required this.nombre,
    this.foto,
    required this.cargo,
    required this.correo,
    required this.empresa,
    this.supervisor,
    required this.contrato,
    required this.lectorSec,
  });

  int idUsuario;
  String nombre;
  String? foto;
  String cargo;
  String correo;
  String empresa;
  String? supervisor;
  String contrato;
  int lectorSec;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
    idUsuario: json["id_usuario"],
    nombre: json["nombre"],
    foto: json["foto"],
    cargo: json["cargo"],
    correo: json["correo"],
    empresa: json["empresa"],
    supervisor: json["supervisor"],
    contrato: json["contrato"],
    lectorSec: json["lector_sec"],
  );
}
