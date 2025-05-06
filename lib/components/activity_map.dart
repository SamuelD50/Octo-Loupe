import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';

class ActivityMap extends StatefulWidget {
  final List<Map<String, dynamic>> markers;
  
  const ActivityMap({
    super.key,
    required this.markers,
  });

  @override
  ActivityMapState createState() => ActivityMapState();
}

class ActivityMapState extends State<ActivityMap> {
  late final List<Map<String, dynamic>> markers;
  LatLng? selectedMarkerPosition;
  String? selectedDiscipline;
  
  @override
  void initState() {
    super.initState();
    markers = widget.markers;
  }

  @override
  Widget build(
    BuildContext context
  ) {
    List<Marker> mapMarkers = markers.map((marker) {
      return Marker(
        point: LatLng(marker['latitude'], marker['longitude']),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () {
            setState(() {
              selectedMarkerPosition = LatLng(marker['latitude'], marker['longitude']);
              selectedDiscipline = marker['discipline'];
            });
            _showMarkerDetails(marker['discipline']);
          },
          child: Icon(
            Icons.location_pin,
            color: Colors.redAccent[700],
            size: 40,
          ),
        ),
      );
    }).toList();

    double totalLatitude = 0.0;
    double totalLongitude = 0.0;

    for (var marker in markers) {
      totalLatitude += marker['latitude'];
      totalLongitude += marker['longitude'];
    }

    double averageLatitude = totalLatitude / markers.length;
    double averageLongitude = totalLongitude / markers.length;

    return FlutterMap(
      mapController: MapController(),
      options: MapOptions(
        initialCenter: LatLng(averageLatitude, averageLongitude),
        initialZoom: 13.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.octoloupe.android',
          tileProvider: CancellableNetworkTileProvider(),
        ),
        MarkerLayer(
          markers: mapMarkers,
        ),
        if (selectedDiscipline != null)
          Positioned(
            bottom: 5,
            left: 5,
            right: 5,
            child: _showMarkerDetails(selectedDiscipline!),
          ),
      ],
    );
  }
  Widget _showMarkerDetails(String discipline) {
    return SizedBox(
      child: Card(
        elevation: 4.0,
        color: const Color(0xFF5B59B4),
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                discipline,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap:() {
                  setState(() {
                    selectedDiscipline = null;
                  });
                },
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}