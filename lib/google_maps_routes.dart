library google_maps_routes;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';

/// A library for creating a route over google maps with the directions API
class MapsRoutes {
  Set<Polyline> routes = {};

  /// Replaces whitespaces in string with a single dash
  String _replaceWhiteSpaces(String str) {
    return str.replaceAll(' ', '-');
  }

  Set<Polyline> returnRoutes() {
    return routes;
  }

  /// Function that creates a route between two points with directions API
  void _createRouteFragment(
      double? startLat,
      double? startLon,
      double? endLat,
      double? endLon,
      String routeName,
      Color routeColor,
      String googleApiKey) async {
    late PolylinePoints routePoints = PolylinePoints();
    List<LatLng> routeCoordinates = [];

    if (startLat == null ||
        startLon == null ||
        endLat == null ||
        endLon == null) {
      return;
    }

    PolylineResult result = await routePoints.getRouteBetweenCoordinates(
      googleApiKey,
      PointLatLng(startLat, startLon),
      PointLatLng(endLat, endLon),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        routeCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId('route-$routeName');

    Polyline route = Polyline(
        polylineId: id, color: routeColor, points: routeCoordinates, width: 3);

    routes.add(route);
  }

  Future<void> drawRoute(List<LatLng> points, String routeName,
      Color routeColor, String googleApiKey) async {
    var previousPoint;
    print(googleApiKey);

    for (var i = 0; i < points.length; i++) {
      var point = points[i];

      if (previousPoint == null) {
        var nextPoint = points[i + 1];
        previousPoint = point;
        _createRouteFragment(
            point.latitude,
            point.longitude,
            nextPoint.latitude,
            nextPoint.longitude,
            '${_replaceWhiteSpaces(routeName)}+$i',
            routeColor,
            googleApiKey);
      } else {
        _createRouteFragment(
            previousPoint.latitude,
            previousPoint.longitude,
            point.latitude,
            point.longitude,
            '${_replaceWhiteSpaces(routeName)}+$i',
            routeColor,
            googleApiKey);
      }
    }

    print('Routes: ');
    print(routes);
  }
}
