/* import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:octoloupe/model/activity_model.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';

class MapCard extends StatelessWidget {
  const MapCard({super.key, required this.activities});

  final List<ActivityModel> activities;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: MapController(),
      options: MapOptions(
        initialCenter: LatLng(49.61443010609209, -1.5994695422704903),
        initialZoom: 10,
      ),
      children: [
        TileLayer(
          /* tileProvider: CancellableTileProvider(), */
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.app',
        ),
        RichAttributionWidget(
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
            ),
          ],
        ),
        MarkerLayer(
          markers: activities.map((activity) {
            return Marker(
              point: LatLng(activity.place.latitude, activity.place.longitude),
              width: 80,
              height: 80,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/icons/Localisation.png', height: 40),
                  SizedBox(height: 5),
                  Text(
                    activity.place.title,
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}


/* import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class _MapCard extends State {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(-33.86, 151.20);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller
  }
  const MapCard({Key? key}) : super(key: key); // Ajout du paramètre key

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, // Hauteur de la carte
      child: WebView(
        initialUrl: 'https://www.google.com/maps/@-33.86,151.20,11z', // URL de la carte
        javascriptMode: JavascriptMode.unrestricted, // Mode JavaScript
      ),
    );
  }
} */ */