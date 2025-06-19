import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:mapakaon2/pages/maps_page/routing/routeDialogue.dart';
import 'package:mapakaon2/pages/maps_page/routing/routeGuide.dart';
import 'package:mapakaon2/pages/maps_page/routing/routeStorage.dart';
import 'package:mapakaon2/pages/maps_page/routing/route_utils.dart';

const bool debugMode = false; // debug mode

class MapHelpers {
  static Future<void> loadDefaultRoutesFromAssets({
    required List<StoredRoute> storedRoutes,
    required void Function(VoidCallback fn) setState,
  }) async {
    final String jsonString = await rootBundle.loadString('assets/routes/default_routes.json');
    final List<dynamic> jsonData = json.decode(jsonString);
    final defaultRoutes = jsonData.map((route) => StoredRoute.fromJson(route)).toList();

    setState(() {
      storedRoutes.addAll(defaultRoutes);
    });
  }

  static Future<void> generateStepByStepRoute({
    required LatLng start,
    required LatLng end,
    required List<StoredRoute> storedRoutes,
    required void Function(VoidCallback fn) setState,
    required void Function(String message) onError,
    required void Function(List<LatLng> path) onSuccess,
  }) async {
    final stepBuilder = StepByStepRoute(
      start: start,
      end: end,
      jeepneyRoutes: storedRoutes,
    );

    try {
      final path = await stepBuilder.computeStepByStepPath();
      onSuccess(path);
      setState(() {});
    } catch (e) {
      onError('Step-by-step route error: $e');
    }
  }

  static Future<void> fetchRouteSegments({
    required List<LatLng> clickedPoints,
    required void Function(List<List<LatLng>> segments) onComplete,
    required String apiKey,
    required void Function(String error) onError,
  }) async {
    if (clickedPoints.length < 2) return;

    List<List<LatLng>> segments = [];

    for (int i = 0; i < clickedPoints.length - 1; i++) {
      final start = clickedPoints[i];
      final end = clickedPoints[i + 1];

      await Future.delayed(const Duration(milliseconds: 600));

      final url = Uri.parse('https://api.openrouteservice.org/v2/directions/driving-car/json');
      final body = {
        "coordinates": [
          [start.longitude, start.latitude],
          [end.longitude, end.latitude],
        ],
      };

      try {
        final response = await http.post(
          url,
          headers: {
            'Authorization': apiKey,
            'Content-Type': 'application/json',
          },
          body: json.encode(body),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final geometry = data['routes'][0]['geometry'];

          PolylinePoints polylinePoints = PolylinePoints();
          List<PointLatLng> decodedPoints = polylinePoints.decodePolyline(geometry);

          final polyline = decodedPoints
              .map((point) => LatLng(point.latitude, point.longitude))
              .toList();

          segments.add(polyline);
        } else {
          onError('Routing failed for segment $i: ${response.body}');
        }
      } catch (e) {
        onError('Error fetching segment $i: $e');
      }
    }

    onComplete(segments);
  }

  static Future<void> loadStoredRoutes({
    required void Function(List<StoredRoute> routes) onLoaded,
  }) async {
    final loadedRoutes = await loadRoutesFromFile();
    onLoaded(loadedRoutes);
  }

  static Future<void> saveCurrentRoute({
    required String name,
    required List<LatLng> clickedPoints,
    required List<StoredRoute> storedRoutes,
    required void Function(VoidCallback fn) setState,
    required void Function(List<StoredRoute> updatedRoutes) onSaved,
  }) async {
    if (clickedPoints.isEmpty) return;

    final newRoute = StoredRoute(
      routeName: name,
      coordinates: List<LatLng>.from(clickedPoints),
    );

    setState(() {
      storedRoutes.add(newRoute);
      onSaved(List<StoredRoute>.from(storedRoutes));
    });

    await saveRoutesToFile(storedRoutes);
    debugPrint('✅ Saved route "$name" with ${newRoute.coordinates.length} points.');
  }

  static void printCurrentRoute(String routeName, List<List<LatLng>> segments) {
    final allPoints = segments.expand((s) => s).toList();
    print('{\n  "routeName": "$routeName",\n  "coordinates": [');

    for (int i = 0; i < allPoints.length; i++) {
      final p = allPoints[i];
      final comma = i == allPoints.length - 1 ? '' : ',';
      print('    {"latitude": ${p.latitude}, "longitude": ${p.longitude}}$comma');
    }

    print('  ]\n},');
  }

  static void showSavedRoutesDialog({
    required BuildContext context,
    required List<StoredRoute> storedRoutes,
    required void Function(List<LatLng> selected) onSelected,
    required Future<void> Function(List<LatLng>) onFetchRouteSegments,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Saved Routes'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: storedRoutes.length,
            itemBuilder: (context, index) {
              final route = storedRoutes[index];
              return ListTile(
                title: Text(route.routeName),
                onTap: () {
                  Navigator.of(context).pop();
                  onSelected(List<LatLng>.from(route.coordinates));
                  onFetchRouteSegments(route.coordinates);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  static Future<void> showRoutePicker({
    required BuildContext context,
    required void Function(List<LatLng>) onPicked,
    required Future<void> Function(List<LatLng>) onFetchRouteSegments,
  }) async {
    final selectedRoute = await showDialog(
      context: context,
      builder: (context) => const RoutePickerDialog(),
    );

    if (selectedRoute != null) {
      onPicked(List<LatLng>.from(selectedRoute.coordinates));
      onFetchRouteSegments(selectedRoute.coordinates);
    }
  }

  static void handleMapTap({
    required LatLng latlng,
    required bool isAddingMarkers,
    required bool debugMode,
    required List<LatLng> clickedPoints,
    required void Function(VoidCallback fn) setState,
    required List<StoredRoute> storedRoutes,
    required void Function(List<LatLng> path) onStepPathReady,
    required void Function(String message) onError,
  }) {
    if (!isAddingMarkers) return;

    setState(() {
      if (debugMode) {
        if (clickedPoints.isNotEmpty) {
          LatLng lastPoint = clickedPoints.last;
          // Additional debug logic
        } else {
          debugPrint('❌ clickedPoints is empty when trying to access .last');
          return;
        }
      } else {
        if (clickedPoints.length == 2) {
          clickedPoints.clear();
        }
        clickedPoints.add(latlng); // ✅ Correct usage
      }
    });

    debugPrint('Stored clicked points:');
    for (final p in clickedPoints) {
      print('{"latitude": ${p.latitude}, "longitude": ${p.longitude}},');
    }

    if (!debugMode && clickedPoints.length == 2) {
      final stepper = StepByStepRoute(
        start: clickedPoints[0],
        end: clickedPoints[1],
        jeepneyRoutes: storedRoutes,
      );

      stepper.computeStepByStepPath().then((stepPath) {
        debugPrint('✅ Step-by-step path has ${stepPath.length} points');
        onStepPathReady(stepPath);
      }).catchError((e) {
        onError('❌ Failed to compute step-by-step route: $e');
      });
    }
  }
}
