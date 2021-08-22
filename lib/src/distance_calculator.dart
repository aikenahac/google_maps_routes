/// Importing necessary packages
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' show cos, sqrt, asin;

/// Class for the distance calculator
class DistanceCalculator {
  /// Calculates the distance between two points
  double _routeDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c(((lat2 - lat1) as num) * p) / 2 +
        c((lat1 as num) * p) *
            c((lat2 as num) * p) *
            (1 - c(((lon2 - lon1) as num) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }

  /// Calculates the distance between all points in a list
  String calculateRouteDistance(List<LatLng> points, {decimals}) {
    double totalDistance = 0.0;

    /// Defaults the number of decimals to 1 if not specified
    decimals ??= 1;

    /// Iterates through all points in the list and calculates
    /// the distance between each point
    for (int i = 0; i < points.length - 1; i++) {
      totalDistance += _routeDistance(
        points[i].latitude,
        points[i].longitude,
        points[i + 1].latitude,
        points[i + 1].longitude,
      );
    }

    print('TOTAL DISTANCE: ${totalDistance.toStringAsFixed(decimals)} km');

    /// Returns the total distance in km
    return '${totalDistance.toStringAsFixed(decimals)} km';
  }
}
