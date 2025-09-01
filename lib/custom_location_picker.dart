import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:simple_location_picker/geocoding_osm_api.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late MapController controller;
  GeoPoint? selectedPoint = GeoPoint(latitude: 27.7172, longitude: 85.3240);
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    controller = MapController(
      initPosition: selectedPoint!,
    );
  }

  void _setSearchSelectedPoint(GeoPoint point) async {
    await controller.moveTo(point);
    setState(() {
      selectedPoint = point;
    });
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
      body: Column(
        children: [
          //Use TypeAheadField here

          TypeAheadField<dynamic>(
            hideOnEmpty: true,
            debounceDuration: const Duration(milliseconds: 700),
            builder: (context, controller, focusNode) {
              return TextFormField(
                focusNode: focusNode,
                controller: controller, // ✅ use the one provided here
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.grey),
                  hintText: "",
                ),
                onEditingComplete: () {
                  // ✅ trigger suggestions when editing completes
                  FocusScope.of(context).unfocus();
                },
              );
            },
            onSelected: (suggestion) {
              final point = GeoPoint(
                  latitude: double.parse(suggestion['lat']),
                  longitude: double.parse(suggestion['lon']));
              _setSearchSelectedPoint(point); // your function to update map
              searchController.text = "";
            },
            itemBuilder: (context, suggestion) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(suggestion['display_name']),
                  ),
                  const Divider(height: 0, color: Colors.grey),
                ],
              );
            },
            transitionBuilder: (context, animation, child) {
              return FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Curves.fastOutSlowIn,
                ),
                child: child,
              );
            },
            suggestionsCallback: (pattern) async {
              if (pattern.isNotEmpty) {
                return await fetchSuggestions(pattern);
              }
              return [];
            },
          ),
          Expanded(
            child: Stack(
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
