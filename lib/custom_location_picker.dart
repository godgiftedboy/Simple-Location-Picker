import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flmap;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:simple_location_picker/geocoding_osm_api.dart';

class LocationPickerScreen extends StatefulWidget {
  final ll.LatLng? selectedPoint;
  const LocationPickerScreen({
    super.key,
    this.selectedPoint,
  });

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  // flutter_map controller
  late flmap.MapController controller;
  late ll.LatLng? selectedPoint;

  // ✅ replaced GeoPoint with ll.LatLng

  TextEditingController searchController = TextEditingController();
  double _currentZoom = 12.0;

  @override
  void initState() {
    super.initState();
    selectedPoint = widget.selectedPoint ?? const ll.LatLng(27.7172, 85.3240);

    controller = flmap.MapController();
  }

  void _setSearchSelectedPoint(ll.LatLng point) async {
    controller.move(point, _currentZoom);
    setState(() {
      selectedPoint = point;
    });
  }

  void _updateSelectedPoint(ll.LatLng center) {
    setState(() {
      selectedPoint = center;
    });
  }

  @override
  Widget build(BuildContext context) {
    final initialCenter = selectedPoint ?? const ll.LatLng(27.7172, 85.3240);

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
          TypeAheadField<dynamic>(
            hideOnEmpty: true,
            debounceDuration: const Duration(milliseconds: 700),
            builder: (context, controllerTF, focusNode) {
              return TextFormField(
                focusNode: focusNode,
                controller: controllerTF,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10.0),
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.grey),
                  hintText: "",
                ),
                onEditingComplete: () {
                  FocusScope.of(context).unfocus();
                },
              );
            },
            onSelected: (suggestion) {
              final point = ll.LatLng(
                double.parse(suggestion['lat']),
                double.parse(suggestion['lon']),
              );
              _setSearchSelectedPoint(point);
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
                flmap.FlutterMap(
                  mapController: controller,
                  options: flmap.MapOptions(
                    initialCenter: initialCenter,
                    initialZoom: _currentZoom,
                    onPositionChanged: (position, hasGesture) {
                      setState(() {
                        _currentZoom = position.zoom;
                      });
                      _updateSelectedPoint(position.center);
                    },
                  ),
                  children: [
                    flmap.TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName:
                          'com.example.simple_location_picker',
                    ),
                    flmap.MarkerLayer(markers: [
                      flmap.Marker(
                        point: selectedPoint ?? initialCenter,
                        width: 50,
                        height: 50,
                        child: const IgnorePointer(
                          child: Icon(
                            Icons.location_on,
                            size: 50,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ]),
                  ],
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
