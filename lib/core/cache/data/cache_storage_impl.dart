import 'package:artiko/core/cache/domain/repositories/cache_storage_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../domain/exceptions/cache_exception.dart';

class CacheStorageImpl extends CacheStorageInterface {
  final cacheStorage = FlutterSecureStorage();

  @override
  Future<void> delete(String key) async {
    try {
      await cacheStorage.delete(key: key);
    } catch (_) {
      CacheException(
          'Hubo un error al tratar de eliminar $key en el almacenamiento');
    }
  }

  @override
  Future fetch(String key) async {
    try {
      return await cacheStorage.read(key: key);
    } catch (_) {
      CacheException(
          'Hubo un error al tratar de consultar $key en el almacenamiento');
    }
  }

  @override
  Future save({required String key, required String value}) async {
    try {
      await cacheStorage.write(key: key, value: value);
    } catch (_) {
      throw CacheException(
          'Hubo un error al tratar de escribir $key en el almacenamiento');
    }
  }

  @override
  Future clear() async {
    try {
      await cacheStorage.deleteAll();
    } catch (_) {
      CacheException('Hubo un error al tratar de borrar el almacenamiento');
    }
  }
}
