import 'package:artiko/core/permissions_handler/gps_permission.dart';
import 'package:artiko/shared/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      if (await Geolocator.isLocationServiceEnabled() &&
          await Permission.location.isGranted) {
        Navigator.pushReplacementNamed(context, AppRoutes.MainScreen);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: checkGpsAndLocation(context),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return snapshot.hasData
                  ? Center(child: Center(child: Text(snapshot.data)))
                  : Center(child: CircularProgressIndicator());
            }));
  }

  Future<String> checkGpsAndLocation(BuildContext context) async {
    final isGrantedGPSPermission = await Permission.location.isGranted;
    final isGPSActive = await Geolocator.isLocationServiceEnabled();

    if (isGrantedGPSPermission && isGPSActive) {
      Navigator.pushReplacementNamed(context, AppRoutes.MainScreen);
      return '';
    } else if (!isGrantedGPSPermission) {
      _askForLocationPermission();
      return 'Es necesario el permiso de GPS';
    } else if (!isGPSActive) {
      return 'Por favor active el GPS';
    } else {
      return 'Es necesario el permiso de GPS y Por favor active el GPS';
    }
  }

  void _goToAccessGPSPage() {
    Navigator.pushReplacementNamed(context, AppRoutes.AccessGPSScreen);
  }

  Future<void> _askForLocationPermission() async {
    if (!await GpsPermission.haveLocationPermissions()) _goToAccessGPSPage();
  }
}
