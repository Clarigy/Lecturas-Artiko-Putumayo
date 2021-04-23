class ServerException implements Exception {
  final String? message;

  ServerException([this.message]);

  @override
  String toString() => message ?? 'Ocurrió un error inesperado';
}

class Failure implements Exception {
  final String? message;

  Failure([this.message]);

  @override
  String toString() => message ?? 'Ocurrió un error inesperado';
}
