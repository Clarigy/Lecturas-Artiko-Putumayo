import 'package:artiko/core/permissions_handler/gps_permission.dart';
import 'package:artiko/shared/routes/app_routes.dart';
import 'package:artiko/shared/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AccessGpsPage extends StatefulWidget {
  @override
  _AccessGpsPageState createState() => _AccessGpsPageState();
}

class _AccessGpsPageState extends State<AccessGpsPage>
    with WidgetsBindingObserver {
  bool popup = false;

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed && !popup) {
      if (await Permission.location.isGranted) {
        Navigator.pushReplacementNamed(context, AppRoutes.LoadingScreen);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text('Es necesario el GPS para usar esta app'),
        MainButton(
            text: 'Solicitar Acceso',
            onTap: () async {
              popup = true;
              _tryAccessGPS();
              popup = false;
            })
      ])),
    );
  }

  Future<void> _tryAccessGPS() async {
    final haveLocationPermissions =
        await GpsPermission.haveLocationPermissions();
    if (haveLocationPermissions) {
      await Navigator.pushReplacementNamed(context, AppRoutes.LoadingScreen);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }
}
