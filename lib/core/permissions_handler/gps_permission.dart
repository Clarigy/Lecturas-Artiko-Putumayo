import 'package:permission_handler/permission_handler.dart';

abstract class GpsPermission {
  static Future<bool> haveLocationPermissions() async {
    final status = await Permission.location.request();
    return await _accessGPS(status);
  }

  static Future<bool> _accessGPS(PermissionStatus status) async {
    switch (status) {
      case PermissionStatus.granted:
        return true;
      case PermissionStatus.denied:
        return false;
      case PermissionStatus.limited:
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
        openAppSettings();
        return false;
    }
  }
}
