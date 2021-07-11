import 'package:artiko/features/home/presentation/pages/activities_page/widgets/readings_card.dart';
import 'package:artiko/features/home/presentation/pages/providers/home_provider.dart';
import 'package:artiko/shared/routes/app_routes.dart';
import 'package:artiko/shared/routes/route_args_keys.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

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
    _customInfoWindowController.googleMapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    if (marker == null) return Center(child: CircularProgressIndicator());
    final size = MediaQuery.of(context).size;
    final activitiesBloc = context.read(activitiesBlocProvider);

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
              return Stack(
                children: [
                  GoogleMap(
                    onMapCreated: _onMapCreated,
                    myLocationEnabled: true,
                    zoomControlsEnabled: false,
                    onCameraMove: (_) {
                      _customInfoWindowController.onCameraMove!();
                    },
                    onTap: (_) {
                      _customInfoWindowController.hideInfoWindow!();
                    },
                    myLocationButtonEnabled: true,
                    markers: _buildMarkers(),
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                          snapshot.data!.latitude, snapshot.data!.longitude),
                      zoom: 12,
                    ),
                  ),
                  CustomInfoWindow(
                    width:
                        size.width < 400 ? size.width * .938 : size.width * .89,
                    height: size.height < 600
                        ? size.height * .4
                        : size.height * .26,
                    controller: _customInfoWindowController,
                  )
                ],
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
                    Navigator.pushNamed(context, AppRoutes.CreateMeasure,
                        arguments: {IS_FROM_MAP: true});
                  },
                  child: Icon(Icons.add)),
            ))
      ],
    );
  }

  Set<Marker> _buildMarkers() {
    final readings = context.read(activitiesBlocProvider).readings;

    if (readings == null) return Set.of(List.empty());

    return readings
        .where((element) =>
            element.latPuntoMedicion != null &&
            element.longPuntoMedicion != null)
        .map((e) => Marker(
            markerId: MarkerId(e.numeroMedidor),
            icon: e.readingRequest.lectura != null ? markerDone! : marker!,
            onTap: () {
              _customInfoWindowController.addInfoWindow!(
                GestureDetector(
                    onTap: () => Navigator.pushNamed(
                        context, AppRoutes.ReadingDetailScreen,
                        arguments: {READING_DETAIL: e, READINGS: readings}),
                    child: ReadingsCard(item: e)),
                LatLng(double.parse(e.latPuntoMedicion!),
                    double.parse(e.longPuntoMedicion!)),
              );
            },
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

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }
}
