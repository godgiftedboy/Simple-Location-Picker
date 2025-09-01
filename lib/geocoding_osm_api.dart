import 'package:dio/dio.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

final Dio dio = Dio();

Future<String> getAddressFromOSM(GeoPoint point) async {
  final url =
      'https://nominatim.openstreetmap.org/reverse?format=json&lat=${point.latitude}&lon=${point.longitude}&zoom=18&addressdetails=1';

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
      final data = response.data;
      final address = data['display_name'] ?? 'Unknown place';
      return address;
    } else {
      return 'Unknown place';
    }
  } catch (e) {
    return 'Unknown place';
  }
}
