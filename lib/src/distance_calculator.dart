/// Importing necessary packages
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' show cos, sqrt, asin;

/// Class for the distance calculator
class DistanceCalculator {
  /// Calculates the distance between two points.
  ///
  /// Points are defined by latitudes and longitudes
  ///
  /// First point: [lat1], [lon1]
  ///
  /// Second point: [lat2], [lon2]
  double _routeDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c(((lat2 - lat1)) * p) / 2 +
        c((lat1) * p) * c((lat2) * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  /// Calculates the distance between [points]
  /// and returns the total distance in meters
  double calculateRouteDistance(List<LatLng> points, {int? decimals}) {
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

    final double totalDistanceInMeters = totalDistance * 1000;

    /// Returns the total distance in meters
    return totalDistanceInMeters;
  }
}
