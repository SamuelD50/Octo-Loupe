import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:octoloupe/providers/activity_map_provider.dart';
import 'package:provider/provider.dart';

// This component is used to show the geographic location of each activity on a map

class ActivityMap extends StatelessWidget {
  final List<Map<String, dynamic>> markers;
  
  const ActivityMap({
    super.key,
    required this.markers,
  });

  @override
  Widget build(
    BuildContext context
  ) {
    final readActivityMapProvider = context.read<ActivityMapProvider>();
    final watchActivityMapProvider = context.watch<ActivityMapProvider>();

    List<Marker> mapMarkers = markers.map((marker) {
      return Marker(
        point: LatLng(marker['latitude'], marker['longitude']),
        width: 80,
        height: 80,
        child: Semantics(
          label: 'Marqueur géographique pour ${marker['discipline']}',
          button: true,
          child: GestureDetector(
            onTap: () {
              readActivityMapProvider.selectMarker(
                LatLng(marker['latitude'], marker['longitude']),
                marker['discipline'],
              );
            },
            child: Icon(
              Icons.location_pin,
              color: Colors.redAccent[700],
              size: 40,
            ),
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
        if (watchActivityMapProvider.selectedDiscipline != null)
          Positioned(
            bottom: 5,
            left: 5,
            right: 5,
            child: _MarkerDetails(
              discipline: watchActivityMapProvider.selectedDiscipline!,
              onClose: () => readActivityMapProvider.clearSelection(),  
            ),
          ),
      ],
    );
  }
}

class _MarkerDetails extends StatelessWidget {
  final String discipline;
  final VoidCallback onClose;

  const _MarkerDetails({
    required this.discipline,
    required this.onClose,
  });

  @override
  Widget build(
    BuildContext context
  ) {
    return Semantics(
      label: 'Emplacement géographique de $discipline',
      child: Card(
        elevation: 4.0,
        color: const Color(0xFF5B59B4),
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
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
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 25,
                ),
                onPressed: onClose,
                tooltip: 'Fermer',
              ),
            ],
          ),
        ),
      )
    );
  }
}