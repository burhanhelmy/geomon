import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geomon/page/home/provider/home_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapWidget extends StatefulWidget {
  @override
  State<MapWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  Completer<GoogleMapController> _controller = Completer();
  int focusCurrentLocation;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(3.1592907, 101.7540397),
    zoom: 19,
  );

  @override
  void initState() {
    super.initState();
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    focusCurrentLocation = homeProvider.focusCurrentLocation;
    homeProvider.init();
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    final CameraPosition _currentLocation = CameraPosition(
        target:
            LatLng(homeProvider.currentlatitude, homeProvider.currentlongitude),
        zoom: 16);

    Future<void> _focusCurrentLocation() async {
      final GoogleMapController controller = await _controller.future;
      controller
          .animateCamera(CameraUpdate.newCameraPosition(_currentLocation));
    }

    if (homeProvider.focusCurrentLocation != focusCurrentLocation) {
      _focusCurrentLocation();
      focusCurrentLocation = homeProvider.focusCurrentLocation;
    }

    return Column(
      children: <Widget>[
        Expanded(
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            circles: homeProvider.circles,
            onTap: (latLng) {
              homeProvider.updateMonitorLocation(latLng);
            },
          ),
        ),
        Text(homeProvider.status)
      ],
    );
  }
}
