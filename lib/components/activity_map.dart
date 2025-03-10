import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:octoloupe/model/activity_model.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';

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
    List<Marker> mapMarkers = markers.map((marker) {
      return Marker(
        point: LatLng(marker['latitude'], marker['longitude']),
        width: 80,
        height: 80,
        child: Icon(
          Icons.location_pin,
          color: Colors.redAccent[700],
          size: 40,
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
      ],
    );
  }
}