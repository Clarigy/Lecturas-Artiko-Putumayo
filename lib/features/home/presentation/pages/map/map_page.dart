import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
import 'package:artiko/features/home/presentation/pages/activities_page/activities_bloc.dart';
import 'package:artiko/shared/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  BitmapDescriptor? marker;
  BitmapDescriptor? markerDone;

  @override
  void initState() {
    WidgetsBinding.instance!
        .addPostFrameCallback((_) async => await afterLayout());
    super.initState();
  }

  Future<void> afterLayout() async {
    await loadMarkers();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<ActivitiesBloc>();

    if (marker == null) return Center(child: CircularProgressIndicator());

    return Stack(
      children: [
        StreamBuilder<Position>(
          stream: Geolocator.getPositionStream(
              desiredAccuracy: LocationAccuracy.bestForNavigation,
              distanceFilter: 10),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return GoogleMap(
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: true,
                markers: _buildMarkers(bloc.readings),
                initialCameraPosition: CameraPosition(
                  target:
                      LatLng(snapshot.data!.latitude, snapshot.data!.longitude),
                  zoom: 12,
                ),
              );
            }
          },
        ),
        Positioned(
            bottom: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: FloatingActionButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.CreateMeasure);
                  },
                  child: Icon(Icons.add)),
            ))
      ],
    );
  }

  Set<Marker> _buildMarkers(List<ReadingDetailItem>? readings) {
    if (readings == null) return Set.of(List.empty());

    return readings
        .where((element) =>
            element.latPuntoMedicion != null &&
            element.longPuntoMedicion != null)
        .map((e) => Marker(
            markerId: MarkerId(e.numeroMedidor),
            icon: e.readingRequest.lectura != null ? markerDone! : marker!,
            position: LatLng(double.parse(e.latPuntoMedicion!),
                double.parse(e.longPuntoMedicion!))))
        .toSet();
  }

  Future<void> loadMarkers() async {
    marker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, 'assets/images/png/marker.png');
    markerDone = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, 'assets/images/png/marker_done.png');
    setState(() {});
  }
}
