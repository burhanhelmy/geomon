import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong/latlong.dart' as latlong;

class MapWidget extends StatefulWidget {
  @override
  State<MapWidget> createState() => MapWidgetState();
}

class MapWidgetState extends State<MapWidget> {
  Completer<GoogleMapController> _controller = Completer();

  double currentlatitude = 0;
  double currentlongitude = 0;
  double currentDistance = 0;
  double monitorRadius = 1000;
  String status = 'NOTSURE';

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(3.1510, 101.5982),
    zoom: 19,
  );

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  _getLocation() async {
    Geolocator().getPositionStream().listen((position) async {
      setState(() {
        currentlatitude = position.latitude;
        currentlongitude = position.longitude;
        _calculateDistance();
      });
    });
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;

    _getLocation();
  }

  _calculateDistance() {
    final latlong.Distance distance = latlong.Distance();

    final meter = distance.as(
        latlong.LengthUnit.Meter,
        latlong.LatLng(3.1510, 101.5982),
        latlong.LatLng(currentlatitude, currentlongitude));

    log("meter");
    log(meter.toString());

    setState(() {
      if (meter > monitorRadius) {
        status = 'OUTSIDE';
      } else {
        status = 'INSIDE';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Set<Circle> circles = Set.from([
      Circle(
        strokeColor: Colors.blue,
        strokeWidth: 1,
        fillColor: Colors.blue.withOpacity(0.3),
        circleId: CircleId('1231dassad'),
        center: LatLng(3.1510, 101.5982),
        radius: monitorRadius,
      ),
      Circle(
        strokeColor: Colors.blue,
        strokeWidth: 2,
        fillColor: Colors.white,
        circleId: CircleId('current_location'),
        center: LatLng(currentlatitude, currentlongitude),
        radius: 30,
      )
    ]);
    return Column(
      children: <Widget>[
        Expanded(
          child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            circles: circles,
          ),
        ),
        Text(status)
      ],
    );
  }
}
