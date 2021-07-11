import 'package:artiko/core/error/exception.dart';
import 'package:artiko/core/permissions_handler/gps_permission.dart';
import 'package:artiko/core/readings/data/data_sources/readings_dao.dart';
import 'package:artiko/dependency_injector.dart';
import 'package:artiko/features/home/presentation/pages/init/loading_bloc.dart';
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
        body: FutureBuilder<bool>(
            future: _loadAndSaveAllData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }

              if (snapshot.data == false) {
                return Center(
                  child: Text('Ocurrió un error inesperado'),
                );
              }

              return snapshot.hasData && snapshot.data == true
                  ? FutureBuilder(
                      future: checkGpsAndLocation(context),
                      builder: (BuildContext context, AsyncSnapshot snp) {
                        return snp.hasData
                            ? Center(child: Center(child: Text(snp.data)))
                            : Center(child: CircularProgressIndicator());
                      })
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

  Future<bool> _loadAndSaveAllData() async {
    final bloc = sl<LoadingBloc>();

    final currentUser = await bloc.getCurrentUserFromDb();

    if (currentUser == null) {
      Navigator.pushReplacementNamed(context, AppRoutes.LoginScreen);
      return false;
    }

    final readings = await sl<ReadingsDao>().getFutureReadings();

    if (readings != null && readings.isNotEmpty) {
      return true;
    }

    try {
      await bloc.loadAndSaveAllData(currentUser.lectorSec);
      return true;
    } on ServerException catch (error) {
      final snackBar =
          SnackBar(content: Text(error.message ?? 'Error inesperado'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    } catch (e) {
      final snackBar = SnackBar(content: Text('Error inesperado'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
  }
}
