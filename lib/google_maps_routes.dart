library google_maps_routes;

/// Importing necessary packages
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';

enum TravelModes { driving, bicycling, transit, walking }

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
      String googleApiKey,
      TravelMode travelMode) async {
    late PolylinePoints routePoints = PolylinePoints();
    List<LatLng> routeCoordinates = [];

    /// If the coordinates are null, it returns an empty route
    if (startLat == null ||
        startLon == null ||
        endLat == null ||
        endLon == null) {
      return;
    }

    /// If the coordinates are not null, it creates a route between the two points
    PolylineResult result = await routePoints.getRouteBetweenCoordinates(
        googleApiKey,
        PointLatLng(startLat, startLon),
        PointLatLng(endLat, endLon),
        travelMode: travelMode);

    /// Adds coordinates to the route coordinates list
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        routeCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    /// Sets a polyline ID
    PolylineId id = PolylineId('route-$routeName');

    /// Creates a polyline with the route coordinates
    Polyline route = Polyline(
        polylineId: id, color: routeColor, points: routeCoordinates, width: 3);

    /// Adds the route to the routes list
    routes.add(route);
  }

  /// Function that creates the actual route between multiple points
  Future<void> drawRoute(List<LatLng> points, String routeName,
      Color routeColor, String googleApiKey,
      {TravelModes? travelMode}) async {
    var previousPoint;
    TravelMode travelType;

    if (travelMode != null) {
      switch (travelMode) {
        case TravelModes.driving:
          travelType = TravelMode.driving;
          break;
        case TravelModes.bicycling:
          travelType = TravelMode.bicycling;
          break;
        case TravelModes.transit:
          travelType = TravelMode.transit;
          break;
        case TravelModes.walking:
          travelType = TravelMode.walking;
          break;
        default:
          travelType = TravelMode.driving;
      }
    } else {
      travelType = TravelMode.driving;
    }

    /// Iterates over the points and creates a route between each pair
    for (var i = 0; i < points.length; i++) {
      var point = points[i];

      /// If the previous point is null it creates a route
      /// from the first and second point
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
            googleApiKey,
            travelType);
      }

      /// If the previous point is not null it creates a route
      /// between the previous and current point
      else {
        _createRouteFragment(
            previousPoint.latitude,
            previousPoint.longitude,
            point.latitude,
            point.longitude,
            '${_replaceWhiteSpaces(routeName)}+$i',
            routeColor,
            googleApiKey,
            travelType);
      }
    }
  }
}
