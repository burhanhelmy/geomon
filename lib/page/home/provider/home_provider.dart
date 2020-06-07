import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong/latlong.dart' as latlong;

class GeofenceLocationStatus {
  static const locating = 'LOCATING';
  static const inside = 'INSIDE';
  static const outside = 'OUTSIDE';
}

enum BottomDrawerMenuState { VIEW, EDIT }
enum BottomDrawerEditMenuState { PIN, RADIUS, DELETE }

class HomeProvider with ChangeNotifier {
  double currentlatitude = 0;
  double currentlongitude = 0;
  double monitorlatitude = 3.1510;
  double monitorlongitude = 101.5982;
  double monitorRadius = 1000;
  double maxMonitorRadius = 1000;
  double monitorlatitudeBak = 0;
  double monitorlongitudeBak = 0;
  double monitorRadiusBak = 0;
  int focusCurrentLocation = 0;
  String status = GeofenceLocationStatus.inside;

  Set<Circle> circles = Set.from([]);

  BottomDrawerMenuState bottomDrawerMenuState = BottomDrawerMenuState.VIEW;
  BottomDrawerEditMenuState _bottomDrawerEditMenuState =
      BottomDrawerEditMenuState.PIN;

  init() async {
    Geolocator().getPositionStream().listen((position) async {
      currentlatitude = position.latitude;
      currentlongitude = position.longitude;
      notifyListeners();
      _calculateDistance();
      _updateCircle();
    });
  }

  get bottomDrawerEditMenuState => _bottomDrawerEditMenuState;
  set bottomDrawerEditMenuState(state) {
    _bottomDrawerEditMenuState = state;
    notifyListeners();
  }

  _calculateDistance() {
    final latlong.Distance distance = latlong.Distance();
    final meter = distance.as(
        latlong.LengthUnit.Meter,
        latlong.LatLng(monitorlatitude, monitorlongitude),
        latlong.LatLng(currentlatitude, currentlongitude));

    if (meter >= monitorRadius) {
      status = GeofenceLocationStatus.outside;
    } else {
      status = GeofenceLocationStatus.inside;
    }
  }

  clearMonitorArea() {
    bottomDrawerEditMenuState = BottomDrawerEditMenuState.DELETE;
    monitorlatitude = 0;
    monitorlongitude = 0;
    monitorRadius = 0;
    _updateCircle();
  }

  editArea() {
    bottomDrawerMenuState = BottomDrawerMenuState.EDIT;
    _backupMonitorArea();
    notifyListeners();
  }

  updateMonitorLocation(LatLng latLng) {
    if (bottomDrawerEditMenuState == BottomDrawerEditMenuState.PIN &&
        bottomDrawerMenuState == BottomDrawerMenuState.EDIT) {
      monitorlatitude = latLng.latitude;
      monitorlongitude = latLng.longitude;
      if (monitorRadius == 0) {
        monitorRadius = 100;
      }
      bottomDrawerEditMenuState = BottomDrawerEditMenuState.RADIUS;
      _updateCircle();
      notifyListeners();
    }
  }

  updateMonitorRadius(double value) {
    monitorRadius = value * maxMonitorRadius;
    _updateCircle();
  }

  onfocusCurrentLocation() {
    var rng = new Random();
    focusCurrentLocation = rng.nextInt(100);
    notifyListeners();
  }

  _backupMonitorArea() {
    monitorlatitudeBak = monitorlatitude;
    monitorlongitudeBak = monitorlongitude;
    monitorRadiusBak = monitorRadius;
  }

  saveMonitorArea() {
    bottomDrawerMenuState = BottomDrawerMenuState.VIEW;
    bottomDrawerEditMenuState = BottomDrawerEditMenuState.PIN;
    notifyListeners();
  }

  restoreMonitorArea() {
    bottomDrawerMenuState = BottomDrawerMenuState.VIEW;
    monitorlatitude = monitorlatitudeBak;
    monitorlongitude = monitorlongitudeBak;
    monitorRadius = monitorRadiusBak;
    notifyListeners();
  }

  _updateCircle() {
    circles = Set.from([
      Circle(
        strokeColor: Colors.blue,
        strokeWidth: 1,
        fillColor: Colors.blue.withOpacity(0.3),
        circleId: CircleId('monitor_area'),
        center: LatLng(monitorlatitude, monitorlongitude),
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
    notifyListeners();
  }
}
