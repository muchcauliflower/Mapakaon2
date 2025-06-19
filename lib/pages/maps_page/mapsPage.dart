import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapakaon2/data/keys.dart';
import 'package:mapakaon2/pages/maps_page/map_helpers.dart';
import 'package:mapakaon2/pages/maps_page/map_widgets/directionsWidget.dart';
import 'package:mapakaon2/pages/maps_page/map_widgets/map_widgets.dart';
import 'package:mapakaon2/pages/maps_page/routing/routeStorage.dart';
import '../../utils/screenDimensions.dart';

class mapsPage extends StatefulWidget {
  final Function(int) onTabSelected;
  final int currentIndex;

  const mapsPage({
    super.key,
    required this.onTabSelected,
    required this.currentIndex,
  });

  @override
  State<mapsPage> createState() => _mapsPageState();
}

class _mapsPageState extends State<mapsPage> {
  late final MapController _mapController;
  List<List<LatLng>> _routeSegments = [];
  List<LatLng> clickedPoints = [];
  List<StoredRoute> storedRoutes = [];
  List<LatLng> currentRoutePolyline = [];
  bool isAddingMarkers = false;
  static const _apiKey = ORSapiKey;

  // UI Control flags
  bool _showStepByStepList = false;
  bool _showSearchBar = true;
  bool _showCarousel = true;
  bool _showBottomNav = true;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    isAddingMarkers = true;

    MapHelpers.loadDefaultRoutesFromAssets(
      storedRoutes: storedRoutes,
      setState: setState,
    );
  }

  void _onMapTap(LatLng latlng) {
    MapHelpers.handleMapTap(
      latlng: latlng,
      isAddingMarkers: isAddingMarkers,
      debugMode: debugMode,
      clickedPoints: clickedPoints,
      setState: setState,
      storedRoutes: storedRoutes,
      onStepPathReady: (stepPath) {
        debugPrint('📍 Step-by-step polyline has ${stepPath.length} points');
        setState(() {
          currentRoutePolyline = stepPath;
        });
      },
      onError: (msg) => debugPrint(msg),
    );
  }

  void _showDirections() {
    setState(() {
      _showStepByStepList = true;
      _showSearchBar = false;
      _showCarousel = false;
      _showBottomNav = false;
    });
  }

  void _hideDirections() {
    setState(() {
      _showStepByStepList = false;
      _showSearchBar = true;
      _showCarousel = true;
      _showBottomNav = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            // 🌍 Map
            Positioned.fill(
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center: LatLng(10.7202, 122.5621),
                  zoom: 15.0,
                  onTap: (_, latlng) => _onMapTap(latlng),
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://api.mapbox.com/styles/v1/$mapboxStyle/tiles/256/{z}/{x}/{y}@2x?access_token=$mapboxAccessToken',
                    additionalOptions: {
                      'accessToken': mapboxAccessToken,
                    },
                    tileProvider: NetworkTileProvider(),
                  ),
                  PolylineLayer(
                    polylines: [
                      if (currentRoutePolyline.length >= 2)
                        Polyline(
                          points: currentRoutePolyline,
                          strokeWidth: 5.0,
                          color: Colors.redAccent,
                        ),
                      ..._routeSegments.map(
                            (segment) => Polyline(
                          points: segment,
                          strokeWidth: 4.0,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers: clickedPoints.map((point) {
                      return Marker(
                        width: 40.0,
                        height: 40.0,
                        point: point,
                        child: const Icon(Icons.location_pin,
                            color: Colors.red, size: 30),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            if (_showSearchBar) const MapSearchBar(),
            if (_showCarousel) CarouselDisplay(onGetDirections: _showDirections),
            if (_showBottomNav)
              MapBottomNavBar(
                onTabSelected: widget.onTabSelected,
                currentIndex: widget.currentIndex,
              ),

            // 📍 Step-by-step directions
            if (_showStepByStepList)
              DirectionsWidget(onBack: _hideDirections),
          ],
        ),
      ),
    );
  }
}
