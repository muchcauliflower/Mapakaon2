import 'package:latlong2/latlong.dart';

class StoredRoute {
  final String routeName;
  final List<LatLng> coordinates;

  StoredRoute({required this.routeName, required this.coordinates});

  factory StoredRoute.fromJson(Map<String, dynamic> json) {
    final coords = (json['coordinates'] as List).map((coord) {
      return LatLng(
        (coord['latitude'] ?? 0).toDouble(),
        (coord['longitude'] ?? 0).toDouble(),
      );
    }).toList();

    return StoredRoute(
      routeName: json['routeName'] ?? 'Unnamed Route',
      coordinates: coords,
    );
  }

  Map<String, dynamic> toJson() => {
    'routeName': routeName,
    'coordinates': coordinates
        .map((point) => {
      'latitude': point.latitude,
      'longitude': point.longitude,
    })
        .toList(),
  };
}

List<StoredRoute> storedRoutes = []; // global temporary list