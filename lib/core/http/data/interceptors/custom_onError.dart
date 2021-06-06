import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

Future<DioError> customOnError(DioError dioError) async {
  if (dioError.type == DioErrorType.connectTimeout) {
    return _customReportError(dioError,
        'En estos momentos estamos trabajando en cambios, vuelva en un momento');
  }

  if (dioError.error is SocketException) {
    return _customReportError(dioError, 'Sin conexión a internet');
  }

  if (dioError.response is Map) {
    if (dioError.response?.data?.containsKey('mensaje') ?? false) {
      return dioError.error = dioError.response?.data['mensaje'];
    }
  }

  switch (dioError.response?.statusCode ?? 501) {
    case 400:
      return _customReportError(
          dioError, 'Peticion mal hecha, intentalo de nuevo');
    case 401:
      return _customReportError(dioError, 'No tienes permiso');
    case 404:
      return _customReportError(dioError, 'No se ha encontrado nada');
    case 500:
      dioError.error = 'Tuvimos un error interno';
      return dioError;
    default:
      return dioError;
  }
}

Future<DioError> _customReportError(DioError dioError, String error) async {
  dioError.error = error;
  return dioError;
}
