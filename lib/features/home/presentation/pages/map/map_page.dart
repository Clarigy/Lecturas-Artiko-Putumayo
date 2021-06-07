import 'package:artiko/core/readings/domain/entities/reading_detail_response.dart';
import 'package:artiko/features/home/presentation/pages/activities_page/activities_bloc.dart';
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

  @override
  void initState() {
    WidgetsBinding.instance!
        .addPostFrameCallback((_) async => await afterLayout());
    super.initState();
  }

  Future<void> afterLayout() async {
    await loadMarker();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<ActivitiesBloc>();

    if (marker == null) return Center(child: CircularProgressIndicator());

    return StreamBuilder<Position>(
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
            myLocationButtonEnabled: true,
            markers: _buildMarkers(bloc.readings),
            initialCameraPosition: CameraPosition(
              target: LatLng(snapshot.data!.latitude, snapshot.data!.longitude),
              zoom: 11.0,
            ),
          );
        }
      },
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
            icon: marker!,
            position: LatLng(double.parse(e.latPuntoMedicion!),
                double.parse(e.longPuntoMedicion!))))
        .toSet();
  }

  Future<void> loadMarker() async {
    marker = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, 'assets/images/png/marker.png');
    setState(() {});
  }
}
