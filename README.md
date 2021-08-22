# google_maps_routes

This is a package for creating routes on [google maps](https://pub.dev/packages/google_maps_flutter) using the directions API from Google.
Routes are drawn with help of the [flutter_polyline_points](https://pub.dev/packages/flutter_polyline_points) package.

## Screenshot
<img src="https://raw.githubusercontent.com/aikenahac/google_maps_routes/master/assets/example-route.jpeg" alt="example-route" width="200"/>

## Usage

To use the google_maps_routes package, first [depend on it](https://flutter.dev/docs/development/packages-and-plugins/using-packages).

Then import it where you want to use it

```dart
import 'package:google_maps_routes/google_maps_routes.dart';
```

To use it you need a `List` of points like this:

```dart
/// LatLng is included in google_maps_flutter
List<LatLng> points = [
    LatLng(latitude, longitude),
    LatLng(latitude, longitude),
    LatLng(latitude, longitude),
    LatLng(latitude, longitude),
];
```

Then you need to instantiate this plugin

```dart
MapsRoutes route = new MapsRoutes();
```

To create a route, just call the following function:

```dart
/// routeName is a string and can be anything; it can include spaces but
/// they will be replaced with a dash
/// example: 'Example route'

/// color is a Color type and will be used as the polyline color:
/// example: Color.fromRGBO(130, 78, 210, 1.0)

/// googleApyKey is a string and is a google directions API key
/// example: get it at
/// https://developers.google.com/maps/documentation/directions/get-api-key
await route.drawRoute(points, routeName, color, googleApiKey);
```

To use a different travel mode, use the travelMode parameter.

```dart
/// Options: driving, bicycling, transit, walking
await route.drawRoute(
    points,
    routeName,
    color,
    googleApiKey,
    travelMode: TravelModes.walking
);
```

To display the polylines you need to add a polylines parameter to your google map widget.

```dart
GoogleMap(
    polylines: route.routes
)
```

If you ever want to clear the routes, just call:

```dart
route.routes.clear();
```

If you want to calculate the distance of the route use you call the following function with the same `List` of points you used for drawing the route. You can also use it by itself.

```dart
/// Initialize a calculator
DistanceCalculator distanceCalculator = new DistanceCalculator();

/// Call a function that returns a string
/// Pass it the List of points
/// By default it will return with 1 decimal point but you can pass an 
/// option that changes that 
distanceCalculator.calculateRouteDistance(points, decimals: 1);
```

### Credits

- [google maps](https://pub.dev/packages/google_maps_flutter) for providing the map
- [flutter_polyline_points](https://pub.dev/packages/flutter_polyline_points) for the usage of directions api