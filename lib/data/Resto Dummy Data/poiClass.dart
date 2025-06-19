

import 'package:latlong2/latlong.dart';

// Class for Points of Interests
class PoiData {
  final String poiName;
  final String poiAddress;
  final String poiImagePath;
  final LatLng poiCoord;
  final List<String> tags;

  PoiData({required this.poiName, required this.poiAddress, required this.poiImagePath, required this.poiCoord, required this.tags});
}