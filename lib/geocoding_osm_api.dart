import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // for kDebugMode
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// Create Dio instance with PrettyDioLogger
final Dio dio = Dio()
  ..interceptors.add(
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    ),
  );

/// Fetch suggestions from Nominatim (search API)
Future<List<Map<String, dynamic>>> fetchSuggestions(String query) async {
  final url =
      'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1';

  try {
    final response = await dio.get(
      url,
      options: Options(
        headers: {
          'User-Agent': 'FlutterApp', // Nominatim requires a User-Agent
        },
      ),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data);
    } else {
      return [];
    }
  } catch (e) {
    debugPrint("fetchSuggestions error: $e");
    return [];
  }
}

/// Get address from coordinates using Nominatim (reverse API)
Future<String> getAddressFromOSM(GeoPoint point) async {
  final url =
      'https://nominatim.openstreetmap.org/reverse?format=json&lat=${point.latitude}&lon=${point.longitude}&zoom=18&addressdetails=1';

  try {
    final response = await dio.get(
      url,
      options: Options(
        headers: {
          'User-Agent': 'FlutterApp', // Required header
        },
      ),
    );

    if (response.statusCode == 200) {
      final data = response.data;
      return data['display_name'] ?? 'Unknown place';
    } else {
      return 'Unknown place';
    }
  } catch (e) {
    debugPrint("getAddressFromOSM error: $e");
    return 'Unknown place';
  }
}
