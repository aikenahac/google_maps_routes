/// Importing necessary packages
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';

/// Choices between modes of travel
enum TravelModes { driving, bicycling, transit, walking }

/// A library for creating a route over google maps with the directions API
class MapsRoutes {
  Set<Polyline> routes = {};

  /// Replaces whitespaces in string with a single dash
  String _replaceWhiteSpaces(String str) {
    return str.replaceAll(' ', '-');
  }

  /// Function that creates a route between two points with directions API
  _createRouteFragment(
    double startLat,
    double startLon,
    double endLat,
    double endLon,
    String routeName,
    Color routeColor,
    String googleApiKey,
    TravelMode travelMode,
    int routeWidth,
  ) async {
    late PolylinePoints routePoints = PolylinePoints();
    List<LatLng> routeCoordinates = [];

    /// If the coordinates are not null, it creates a route between the two points
    PolylineResult result = await routePoints.getRouteBetweenCoordinates(
      googleApiKey,
      PointLatLng(startLat, startLon),
      PointLatLng(endLat, endLon),
      travelMode: travelMode,
    );

    /// Adds coordinates to the route coordinates list
    result.points.forEach((PointLatLng point) {
      routeCoordinates.add(LatLng(point.latitude, point.longitude));
    });

    /// Sets a polyline ID
    PolylineId id = PolylineId('route-$routeName');

    /// Creates a polyline with the route coordinates
    Polyline route = Polyline(
      polylineId: id,
      color: routeColor,
      points: routeCoordinates,
      width: routeWidth,
    );

    /// Adds the route to the routes list
    routes.add(route);
  }

  /// Function that creates the actual route between multiple points
  Future<void> drawRoute(
    List<LatLng> points,
    String routeName,
    Color routeColor,
    String googleApiKey, {
    TravelModes? travelMode,
    int? routeWidth,
  }) async {
    TravelMode travelType;

    /// Checks which travel mode is defined in the parameters
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
    }

    /// If the travel mode is not defined, it uses the default travel mode
    else {
      travelType = TravelMode.driving;
    }

    /// Iterates over the points and creates a route between each pair
    for (int i = 0; i < points.length - 1; i++) {
      LatLng currentPoint = points[i];
      LatLng nextPoint = points[i + 1];

      await _createRouteFragment(
        currentPoint.latitude,
        currentPoint.longitude,
        nextPoint.latitude,
        nextPoint.longitude,
        '${_replaceWhiteSpaces(routeName)}+$i',
        routeColor,
        googleApiKey,
        travelType,
        routeWidth ?? 3,
      );
    }
  }
}
