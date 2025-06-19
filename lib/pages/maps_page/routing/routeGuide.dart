import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapakaon2/pages/maps_page/routing/routeStorage.dart';

class StepByStepRoute {
  final LatLng start;
  final LatLng end;
  final List<StoredRoute> jeepneyRoutes;
  final double maxWalkingDistance = 300.0; // meters

  StepByStepRoute({
    required this.start,
    required this.end,
    required this.jeepneyRoutes,
  });

  Future<List<LatLng>> computeStepByStepPath() async {
    final routeSequence = _findBestRouteSequence(start, end);

    if (routeSequence.isEmpty) {
      throw Exception('No suitable jeepney route sequence found.');
    }

    return _buildPathFromSequence(routeSequence);
  }

  List<LatLng> _buildPathFromSequence(List<RouteSegmentInfo> sequence) {
    final path = <LatLng>[start];
    LatLng currentPosition = start;

    for (int i = 0; i < sequence.length; i++) {
      final segment = sequence[i];
      final isFirstSegment = i == 0;
      final isLastSegment = i == sequence.length - 1;

      // Add walking segment to route start if needed
      if (isFirstSegment) {
        final walkStart = _findClosestPoint(segment.route.coordinates, currentPosition);
        if (walkStart != currentPosition) {
          path.add(walkStart);
          debugPrint('🚶 Walking to ${segment.route.routeName} at $walkStart');
        }
      }

      // Add the jeepney route segment
      final routePoints = segment.route.coordinates;
      final segmentPoints = routePoints.sublist(segment.startIndex, segment.endIndex + 1);
      path.addAll(segmentPoints);
      currentPosition = segmentPoints.last;

      debugPrint('🛻 Riding ${segment.route.routeName} from ${segmentPoints.first} to ${segmentPoints.last}');

      // Add transfer walking segment if needed
      if (!isLastSegment) {
        final nextSegment = sequence[i + 1];
        final transferPoint = nextSegment.route.coordinates[nextSegment.startIndex];

        if (transferPoint != currentPosition) {
          path.add(transferPoint);
          debugPrint('🚶 Transferring to ${nextSegment.route.routeName} at $transferPoint');
          currentPosition = transferPoint;
        }
      }
    }

    // Add final destination if needed
    if (path.last != end) {
      path.add(end);
      debugPrint('🚶 Walking to final destination at $end');
    }

    return path;
  }

  List<RouteSegmentInfo> _findBestRouteSequence(LatLng start, LatLng end) {
    final allOptions = <List<RouteSegmentInfo>>[];

    // 1. Check direct routes first
    final directRoutes = _findDirectRouteOptions(start, end);
    allOptions.addAll(directRoutes);

    // 2. Check transfer options
    final transferOptions = _findTransferRouteOptions(start, end);
    allOptions.addAll(transferOptions);

    // 3. Select best option based on total distance
    if (allOptions.isEmpty) return [];

    allOptions.sort((a, b) => _calculateTotalCost(a).compareTo(_calculateTotalCost(b)));
    return allOptions.first;
  }

  List<List<RouteSegmentInfo>> _findDirectRouteOptions(LatLng start, LatLng end) {
    final options = <List<RouteSegmentInfo>>[];

    for (final route in jeepneyRoutes) {
      final startIndex = _findClosestIndex(route.coordinates, start);
      final endIndex = _findClosestIndex(route.coordinates, end);

      // Check if valid single route option
      if (startIndex < endIndex) {
        final walkToStart = const Distance().as(LengthUnit.Meter, start, route.coordinates[startIndex]);
        final walkFromEnd = const Distance().as(LengthUnit.Meter, route.coordinates[endIndex], end);

        if (walkToStart <= maxWalkingDistance && walkFromEnd <= maxWalkingDistance) {
          options.add([
            RouteSegmentInfo(
              route: route,
              startIndex: startIndex,
              endIndex: endIndex,
            )
          ]);
        }
      }
    }

    return options;
  }

  List<List<RouteSegmentInfo>> _findTransferRouteOptions(LatLng start, LatLng end) {
    final options = <List<RouteSegmentInfo>>[];
    final startRoutes = _findNearbyRoutes(start, maxWalkingDistance);
    final endRoutes = _findNearbyRoutes(end, maxWalkingDistance);

    for (final startRoute in startRoutes) {
      for (final endRoute in endRoutes) {
        if (startRoute.route == endRoute.route) continue;

        // Find all possible connection points between routes
        final connections = _findRouteConnections(startRoute.route, endRoute.route);

        for (final connection in connections) {
          // Check if the path direction makes sense
          if (startRoute.index <= connection.startIndex &&
              connection.endIndex <= endRoute.index) {

            final totalWalkDistance =
                const Distance().as(LengthUnit.Meter, start, startRoute.route.coordinates[startRoute.index]) +
                    const Distance().as(LengthUnit.Meter, endRoute.route.coordinates[endRoute.index], end);

            if (totalWalkDistance <= maxWalkingDistance * 2) {
              options.add([
                RouteSegmentInfo(
                  route: startRoute.route,
                  startIndex: startRoute.index,
                  endIndex: connection.startIndex,
                ),
                RouteSegmentInfo(
                  route: endRoute.route,
                  startIndex: connection.endIndex,
                  endIndex: endRoute.index,
                )
              ]);
            }
          }
        }
      }
    }

    return options;
  }

  double _calculateTotalCost(List<RouteSegmentInfo> sequence) {
    double cost = 0;
    LatLng? previousPoint = start;

    for (final segment in sequence) {
      final routePoints = segment.route.coordinates;

      // Walking cost to route start
      final walkDistance = const Distance().as(LengthUnit.Meter,
          previousPoint!,
          routePoints[segment.startIndex]);

      // Apply penalty for walking (3x more costly than riding)
      cost += walkDistance * 3;

      // Riding cost
      for (int i = segment.startIndex + 1; i <= segment.endIndex; i++) {
        cost += const Distance().as(LengthUnit.Meter,
            routePoints[i-1],
            routePoints[i]);
      }

      previousPoint = routePoints[segment.endIndex];
    }

    // Final walking cost to destination
    cost += const Distance().as(LengthUnit.Meter, previousPoint!, end) * 3;

    return cost;
  }

  List<RouteWithIndex> _findNearbyRoutes(LatLng point, double maxDistance) {
    final nearbyRoutes = <RouteWithIndex>[];

    for (final route in jeepneyRoutes) {
      final index = _findClosestIndex(route.coordinates, point);
      final distance = const Distance().as(LengthUnit.Meter, point, route.coordinates[index]);

      if (distance <= maxDistance) {
        nearbyRoutes.add(RouteWithIndex(route, index));
      }
    }

    return nearbyRoutes;
  }

  List<RouteConnection> _findRouteConnections(StoredRoute route1, StoredRoute route2) {
    final connections = <RouteConnection>[];

    for (int i = 0; i < route1.coordinates.length; i++) {
      for (int j = 0; j < route2.coordinates.length; j++) {
        if (route1.coordinates[i] == route2.coordinates[j]) {
          connections.add(RouteConnection(i, j));
        }
      }
    }

    return connections;
  }

  int _findClosestIndex(List<LatLng> points, LatLng target) {
    int closestIndex = 0;
    double minDist = double.infinity;

    for (int i = 0; i < points.length; i++) {
      final d = const Distance().as(LengthUnit.Meter, target, points[i]);
      if (d < minDist) {
        minDist = d;
        closestIndex = i;
      }
    }

    return closestIndex;
  }

  LatLng _findClosestPoint(List<LatLng> points, LatLng target) {
    return points[_findClosestIndex(points, target)];
  }
}

class RouteSegmentInfo {
  final StoredRoute route;
  final int startIndex;
  final int endIndex;

  RouteSegmentInfo({
    required this.route,
    required this.startIndex,
    required this.endIndex,
  });
}

class RouteWithIndex {
  final StoredRoute route;
  final int index;

  RouteWithIndex(this.route, this.index);
}

class RouteConnection {
  final int startIndex;
  final int endIndex;

  RouteConnection(this.startIndex, this.endIndex);
}