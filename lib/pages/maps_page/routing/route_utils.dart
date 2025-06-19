import 'dart:convert';
import 'dart:io';
import 'package:mapakaon2/pages/maps_page/routing/routeStorage.dart';
import 'package:path_provider/path_provider.dart';


Future<String> _getRouteFilePath() async {
  final directory = await getApplicationDocumentsDirectory();
  return '${directory.path}/saved_routes.json';
}

Future<void> saveRoutesToFile(List<StoredRoute> routes) async {
  final filePath = await _getRouteFilePath();
  final file = File(filePath);
  final jsonData = jsonEncode(routes.map((e) => e.toJson()).toList());
  await file.writeAsString(jsonData);
}

Future<List<StoredRoute>> loadRoutesFromFile() async {
  final filePath = await _getRouteFilePath();
  final file = File(filePath);
  if (!await file.exists()) return [];
  final contents = await file.readAsString();
  final List<dynamic> jsonData = jsonDecode(contents);
  return jsonData.map((e) => StoredRoute.fromJson(e)).toList();
}
