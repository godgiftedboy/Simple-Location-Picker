import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late MapController controller;
  GeoPoint? selectedPoint = GeoPoint(latitude: 27.7172, longitude: 85.3240);

  @override
  void initState() {
    super.initState();
    controller = MapController(
      initPosition: selectedPoint!,
    );
  }

  void _updateSelectedPoint(Region region) {
    final center = region.center;
    setState(() {
      selectedPoint = center;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick Location"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              if (selectedPoint != null) {
                Navigator.pop(context, selectedPoint);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Please select a location")),
                );
              }
            },
          )
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          OSMFlutter(
            controller: controller,
            osmOption: OSMOption(
              zoomOption: const ZoomOption(initZoom: 12),
              userLocationMarker: UserLocationMaker(
                personMarker: const MarkerIcon(
                  icon: Icon(Icons.person_pin_circle,
                      color: Colors.blue, size: 64),
                ),
                directionArrowMarker: const MarkerIcon(
                  icon: Icon(Icons.double_arrow, size: 48),
                ),
              ),
              roadConfiguration: const RoadOption(
                roadColor: Colors.blue,
              ),
            ),
            onMapMoved: (region) => _updateSelectedPoint(region),
          ),

          // Fixed marker at the center
          const IgnorePointer(
            child: Icon(
              Icons.location_on,
              size: 50,
              color: Colors.red,
            ),
          ),
        ],
      ),
      floatingActionButton: selectedPoint != null
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.pop(context, selectedPoint),
              label: const Text("Confirm"),
              icon: const Icon(Icons.check),
            )
          : null,
    );
  }
}
