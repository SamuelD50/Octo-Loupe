import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:octoloupe/model/activity_model.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';

class ActivityMap extends StatelessWidget {
  final String titleAddress;
  final String streetAddress;
  final String postalCode;
  final String city;
  final double latitude;
  final double longitude;
  
  const ActivityMap({
    super.key,
    required this.titleAddress,
    required this.streetAddress,
    required this.postalCode,
    required this.city,
    required this.latitude,
    required this.longitude,
  });

  /* List<dynamic> activities = []; */

  @override
  Widget build(
    BuildContext context
  ) {
    debugPrint('titleAddress ActivityMap: $titleAddress');
    debugPrint('streetAddress ActivityMap: $streetAddress');
    debugPrint('postalCode ActivityMap: $postalCode');
    debugPrint('city ActivityMap: $city');
    debugPrint('latitude ActivityMap: $latitude');
    debugPrint('longitude ActivityMap: $longitude');

    return FlutterMap(
      mapController: MapController(),
      options: MapOptions(
        initialCenter: LatLng(49.61443010609209, -1.5994695422704903),
        initialZoom: 13.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.octoloupe.android',
          tileProvider: CancellableNetworkTileProvider(),
        ),
        SimpleAttributionWidget(
          source: Text('OpenStreetMap contributors'),
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(latitude, longitude),
              width: 80,
              height: 80,
              child: Icon(Icons.location_on, size: 40),
            )
          ],)
      ],
    );
  }
}

  
    /* return FlutterMap(
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
          markers: [
            Marker(
              point: LatLng(latitude, longitude),
              width: 80,
              height: 80,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/icons/Localisation.png', height: 40),
                  SizedBox(height: 5),
                  Text(
                    '$titleAddress, $streetAddress, $postalCode, $city',
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
} */


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
} */