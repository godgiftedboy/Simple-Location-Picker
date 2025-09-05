import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:simple_location_picker/custom_location_picker.dart';
import 'package:simple_location_picker/geocoding_osm_api.dart';

class LocationSelectPage extends StatefulWidget {
  const LocationSelectPage({super.key});

  @override
  State<LocationSelectPage> createState() => _LocationSelectPageState();
}

class _LocationSelectPageState extends State<LocationSelectPage> {
  LatLng? selectedPoint;
  String? selectedAddress;

  Future<void> _pickLocation() async {
    final LatLng? point = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LocationPickerScreen(
          selectedPoint: selectedPoint,
        ),
      ),
    );

    if (point != null) {
      setState(() {
        selectedPoint = point;
        selectedAddress = "Loading address...";
      });

      final address = await getAddressFromOSM(point);

      setState(() {
        selectedAddress = address;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Location")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: _pickLocation,
              icon: const Icon(Icons.location_on),
              label: const Text("Pick Location"),
            ),
            const SizedBox(height: 20),
            if (selectedPoint != null)
              Text(
                "Coordinates:\nLat: ${selectedPoint!.latitude}, Lon: ${selectedPoint!.longitude}",
                style: const TextStyle(fontSize: 16),
              ),
            const SizedBox(height: 10),
            if (selectedAddress != null)
              Text(
                "Address:\n$selectedAddress",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
