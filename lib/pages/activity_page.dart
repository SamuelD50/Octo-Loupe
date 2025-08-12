import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:octoloupe/model/activity_model.dart';
import 'package:octoloupe/components/activity_card.dart';
import 'package:octoloupe/components/activity_map.dart';
import 'package:octoloupe/providers/activities_provider.dart';
import 'package:octoloupe/providers/activity_map_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// Show activities after the user has completed their filtering

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  ActivityPageState createState() => ActivityPageState();
}

class ActivityPageState extends State<ActivityPage> {
  bool isLoading = false;
  late String activityId;
  Map<String, dynamic>? selectedActivity;
  final ScrollController _scrollController = ScrollController();

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      debugPrint('Could not launch');
    }
  }

  List<Map<String, dynamic>> markers = [];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }
    
  @override
  Widget build(
    BuildContext context
  ) {
    final watchActivitiesProvider = context.watch<ActivitiesProvider>();
    final filteredActivities = watchActivitiesProvider.filteredActivities;

    return watchActivitiesProvider.isLoading ?
      Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white24,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Center(
                child: SpinKitSpinningLines(
                  color: Colors.white,
                  size: 60,
                ),
              ),
            ),
          ),
        ],
      ) :
      Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
          SingleChildScrollView(
            controller: _scrollController,
            child: watchActivitiesProvider.selectedActivity != null ?
              _buildDetailActivity(context, watchActivitiesProvider.selectedActivity!) :
              _buildListActivities(filteredActivities),
          ),
        ],
      );
  }

    /* List of activities after filtering in HomePage */
    Widget _buildListActivities(
      List<Map<String, dynamic>> filteredActivities,
    ) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /* Map with markers to see location activity  */
          if (filteredActivities.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.98,
                height: 400,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        offset: Offset(4, 4),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: ActivityMap(
                      markers: filteredActivities.map((filteredActivity) {
                        Place place = Place.fromMap(filteredActivity['place'] ?? {});
                        return {
                          'latitude': place.latitude,
                          'longitude': place.longitude,
                          'discipline': filteredActivity['discipline'],
                        };
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ...filteredActivities.map((filteredActivity) {
            Place place = Place.fromMap(filteredActivity['place'] ?? {});
            List<Schedule> schedules = (filteredActivity['schedules'] as List?)
              ?.map((schedule) => Schedule.fromMap(schedule as Map<String, dynamic>))
              .toList() ?? [];
            List<Pricing> pricings = (filteredActivity['pricings'] as List?)
              ?.map((pricing) => Pricing.fromMap(pricing as Map<String, String>))
              .toList() ?? [];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.98,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        offset: Offset(4, 4),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: ActivityCard(
                    imageUrl: filteredActivity['imageUrl'] ?? '',
                    discipline: filteredActivity['discipline'],
                    place: place,
                    schedules: schedules,
                    pricings: pricings,
                    onTap: () {
                      final readActivitiesProvider = context.read<ActivitiesProvider>();
                      readActivitiesProvider.setSelectedActivity(filteredActivity);

                      final readActivityMapProvider = context.read<ActivityMapProvider>();
                      readActivityMapProvider.clearSelection();

                      _scrollController.jumpTo(0);
                    },
                  ),
                ),
              ),
            ); 
          }),
        ],
      );
    }

    /* Details of activity after being selected from list */
    _buildDetailActivity(
      BuildContext context,
      Map<String, dynamic> selectedActivity,
    ) {
      activityId = selectedActivity['activityId'];
      String discipline = selectedActivity['discipline'];
      List<String>? information = selectedActivity['information']?.cast<String>();
      String imageUrl = selectedActivity['imageUrl'];
      Place place = Place.fromMap(selectedActivity['place']);
      Contact? contact = Contact.fromMap(selectedActivity['contact']) ;
      List<Schedule> schedules = (selectedActivity['schedules'] as List?)
        ?.map((schedule) => Schedule.fromMap(schedule as Map<String, dynamic>))
        .toList() ?? [];
      List<Pricing> pricings = (selectedActivity['pricings'] as List?)
        ?.map((pricing) => Pricing.fromMap(pricing as Map<String, String>))
        .toList() ?? [];

      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 32),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFF5B59B4),
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;

                    return Image.asset(
                      'assets/images/ActivityByDefault.webp',
                      fit: BoxFit.cover,
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/ActivityByDefault.webp',
                      fit: BoxFit.cover,
                    );
                  }
                )
              )
            )
          ),
          SizedBox(height: 15),
          Text(
            discipline,
            style: TextStyle(
              fontFamily: 'Satisfy-Regular',
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5B59B4),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 15),
          if (information != null && information.isNotEmpty)
            Text(
              information.join('\n'),
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          if (information != null && information.isNotEmpty)
            SizedBox(height: 15),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.98,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    offset: Offset(4, 4),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Card(
                elevation: 4.0,
                color: const Color(0xFF5B59B4),
                shadowColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Lieu',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${place.titleAddress}\n${place.streetAddress}\n${place.postalCode} ${place.city}',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ),      
            ),
          ),
          SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.98,
              height: 400,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(4, 4),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: ActivityMap(
                    markers: [
                      {
                        'latitude': place.latitude,
                        'longitude': place.longitude,
                        'discipline': discipline,
                      },
                    ].toList(),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.98,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    offset: Offset(4, 4),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Card(
                elevation: 4.0,
                color: const Color(0xFF5B59B4),
                shadowColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Prix',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      ...pricings.map((pricing) {
                        return Text(
                          '${pricing.profile} : ${pricing.pricing}',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                          softWrap: true,
                          textAlign: TextAlign.center,
                        );
                      }),
                    ],
                  ),
                ),
              ),      
            ),
          ),
          SizedBox(height: 5),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.98,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    offset: Offset(4, 4),
                    blurRadius: 6,
                  ),
                ],
              ),  
              child: Card(
                elevation: 4.0,
                color: const Color(0xFF5B59B4),
                shadowColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Horaires',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      ...schedules.map((schedule) {
                        return Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.center,
                          children: [
                            Text(
                              '${schedule.day} : ',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                              softWrap: true,
                              textAlign: TextAlign.center,
                            ),
                            ...schedule.timeSlots.map((timeSlot) {
                              if (timeSlot.startHour?.isNotEmpty == true && timeSlot.endHour?.isNotEmpty == true) {
                                return Text(
                                  'De ${timeSlot.startHour} à ${timeSlot.endHour} ',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                );
                              } else if (timeSlot.startHour?.isNotEmpty == true && timeSlot.endHour?.isEmpty == true) {
                                return Text(
                                  'À partir de ${timeSlot.startHour} ',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                );
                              } else if (timeSlot.startHour?.isEmpty == true && timeSlot.endHour?.isNotEmpty == true) {
                                return Text(
                                  'Jusqu\'à ${timeSlot.endHour} ',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                  ),
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                );
                              } else {
                                return SizedBox.shrink();
                              }
                            }),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.98,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    offset: Offset(4, 4),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Card(
                elevation: 4.0,
                color: const Color(0xFF5B59B4),
                shadowColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Contact',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        contact.structureName,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ),
                      if (contact.email?.isNotEmpty ?? false)
                        Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.center,
                          children: [
                            Text(
                              'Email : ',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _launchUrl('mailto:${contact.email}');
                              },
                              child: Text(
                                'Email: ${contact.email}',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white,
                                ),
                                softWrap: true,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      if (contact.phoneNumber?.isNotEmpty ?? false)
                        Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.center,
                          children: [
                            Text(
                              'Téléphone : ',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _launchUrl('tel:${contact.phoneNumber}');
                              },
                              child: Text(
                                '${contact.phoneNumber}',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white,
                                ),
                                softWrap: true,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      if (contact.webSite?.isNotEmpty ?? false)
                        Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.center,
                          children: [
                            Text(
                              'Site web : ',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                              softWrap: true,
                              textAlign: TextAlign.center,
                            ),
                            GestureDetector(
                              onTap: () {
                                _launchUrl(contact.webSite!);
                              },
                              child: Text(
                                '${contact.webSite}',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF5B59B4),
              foregroundColor: Colors.white,
              side: BorderSide(
                color: Color(0xFF5B59B4),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            onPressed: () {
              final readActivitiesProvider = context.read<ActivitiesProvider>();
              readActivitiesProvider.clearSelectedActivity();

              final readActivityMapProvider = context.read<ActivityMapProvider>();
              readActivityMapProvider.clearSelection();

              _scrollController.jumpTo(0);
            },
            child: Text('Retour à la liste',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 32),
          ),
        ],
      );
    }
  }