class CacheException implements Exception {
  late String _message;

  CacheException([String message = 'Sucedio un error al usar Cache Storage']) {
    _message = message;
  }

  @override
  String toString() => _message;
}