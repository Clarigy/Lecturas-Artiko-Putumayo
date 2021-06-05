class AuthException implements Exception {
  late String _message;

  AuthException([String message = 'Sucedio un error en el servicio Auth']) {
    _message = message;
  }

  @override
  String toString() {
    return _message;
  }
}
