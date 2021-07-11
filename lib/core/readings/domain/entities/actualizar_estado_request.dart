// To parse this JSON data, do
//
//     final actualizarEstadoRequest = actualizarEstadoRequestFromJson(jsonString);

import 'dart:convert';

String actualizarEstadoRequestToJson(ActualizarEstadoRequest data) =>
    json.encode(data.toJson());

class ActualizarEstadoRequest {
  ActualizarEstadoRequest({
    required this.items,
  });

  final List<int> items;

  Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items.map((x) => x)),
      };
}
