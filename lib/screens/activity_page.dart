import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:octoloupe/components/custom_app_bar.dart';
import 'package:octoloupe/model/activity_model.dart';
import 'package:octoloupe/components/activity_card.dart';
import 'package:octoloupe/components/activity_map.dart';
import 'package:octoloupe/services/culture_activity_service.dart';
import 'package:octoloupe/services/sport_activity_service.dart';


class ActivityPage extends StatefulWidget {
  List<Map<String, dynamic>> filteredActivities;
  ActivityPage({super.key, required this.filteredActivities});

  @override
  ActivityPageState createState() => ActivityPageState();
}

class ActivityPageState extends State<ActivityPage> {
  bool isLoading = false;
  final int _selectedSection = 0;
  List<Map<String, dynamic>> activities = [];
    SportActivityService sportActivityService = SportActivityService();
  CultureActivityService cultureActivityService = CultureActivityService();
  List<Map<String, dynamic>> filteredActivities = [];
  late String activityId;
  Map<String, dynamic>? selectedActivity;

  Future<void> readActivities() async {
    try {
      setState(() {
        isLoading = true;
      });

      if (_selectedSection == 0) {
        activities = (await sportActivityService.getSportActivities())
          .map((item) => (item).toMap())
          .toList();
      } else {
        activities = (await cultureActivityService.getCultureActivities())
          .map((item) => (item).toMap())
          .toList();
      }

      await Future.delayed(Duration(milliseconds: 25));

      setState(() {
        isLoading = false;
      });
    
    } catch (e) {
      debugPrint('Error fetching activity: $e');
    }
  }

  List<Map<String, dynamic>> markers = [];

  @override
  void initState() {
    super.initState();
    filteredActivities = widget.filteredActivities;
    debugPrint('FilteredActivities in ActivityPage: ${widget.filteredActivities.toString()}');
    /* readActivities(); */
  }
    
  @override
  Widget build(
    BuildContext context
  ) {
    return isLoading?
      Scaffold(
        appBar: const CustomAppBar(),
        body: Stack(
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
        ),
      ) :
      Scaffold(
        appBar: const CustomAppBar(),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white24,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: selectedActivity != null && selectedActivity!.isNotEmpty ?
                  _buildDetailActivity() :
                  _buildListActivities(),
              ),
            )
          ],
        )
      );
    }

    Widget _buildListActivities() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (filteredActivities.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
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
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.98,
                  height: 300,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: ActivityMap(
                      markers: filteredActivities.map((filteredActivity) {
                        Place place = Place.fromMap(filteredActivity['place'] ?? {});
                        return {
                          'latitude': place.latitude,
                          'longitude': place.longitude,
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
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.98,
                  child: ActivityCard(
                    imageUrl: filteredActivity['imageUrl'] ?? '',
                    discipline: filteredActivity['discipline'],
                    place: place,
                    schedules: schedules,
                    pricings: pricings,
                    onTap: () {
                      setState(() {
                        selectedActivity = filteredActivity;
                        /* activityId = selectedActivity!['activityId']; */
                        debugPrint('SelectedActivity: $selectedActivity');
                      });
                    },
                  ),
                ),
              ),
            ); 
          }),
        ],
      );
    }

    _buildDetailActivity() {
      activityId = selectedActivity!['activityId'];
      String discipline = selectedActivity!['discipline'];
      List<String>? information = selectedActivity?['information']?.cast<String>();
      String? imageUrl = selectedActivity?['imageUrl'] ?? '';
      Place place = Place.fromMap(selectedActivity!['place']);
      Contact contact = Contact.fromMap(selectedActivity!['contact'] ?? {});
      List<Schedule> schedules = (selectedActivity!['schedules'] as List?)
        ?.map((schedule) => Schedule.fromMap(schedule as Map<String, dynamic>))
        .toList() ?? [];
      List<Pricing> pricings = (selectedActivity!['pricings'] as List?)
        ?.map((pricing) => Pricing.fromMap(pricing as Map<String, String>))
        .toList() ?? [];

      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (imageUrl != null && imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF5B59B4),
                    width: 4,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          if (imageUrl != null && imageUrl.isNotEmpty)
            SizedBox(height: 25),
          Text(
            discipline,
            style: TextStyle(
              fontFamily: 'Satisfy-Regular',
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5B59B4),
            ),
          ),
          SizedBox(height: 5),
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
          Text(
            'Lieu: ${place.titleAddress}\n${place.streetAddress}\n${place.postalCode} ${place.city}',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 15),
          ...pricings.map((pricing) {
            return Text(
              'Prix: ${pricing.profile} : ${pricing.pricing}',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            );
          }),
          SizedBox(height: 15),
          ...schedules.map((schedule) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Horaire: ${schedule.day}',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                ...schedule.timeSlots.map((timeSlot) {
                  if (timeSlot.startHour?.isNotEmpty == true && timeSlot.endHour?.isNotEmpty == true) {
                    return Text(
                      'De ${timeSlot.startHour} à ${timeSlot.endHour}',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    );
                  } else if (timeSlot.startHour?.isNotEmpty == true && timeSlot.endHour?.isEmpty == true) {
                    return Text(
                      'À partir de ${timeSlot.startHour}',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    );
                  } else if (timeSlot.startHour?.isEmpty == true && timeSlot.endHour?.isNotEmpty == true) {
                    return Text(
                      'Jusqu\'à ${timeSlot.endHour}',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                }),
              ],
            );
          }),
          SizedBox(height: 15),
          Text(
            'Contact: ${contact.structureName}',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          if (contact.email?.isNotEmpty ?? false)
            Text(
              'Email: ${contact.email}',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          if (contact.phoneNumber?.isNotEmpty ?? false)
            Text(
              'Téléphone: ${contact.phoneNumber}',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
          if (contact.webSite?.isNotEmpty ?? false)
            Text(
              'Site web: ${contact.webSite}',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black,
              ),
            ),
        ],
      );
    }


 /*  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          SearchAnchor(
            builder: (BuildContext context, SearchController controller) {
              return SearchBar(
                controller: controller,
                padding: const WidgetStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0)),
                onTap: () {
                  controller.openView();
                },
                onChanged: (_) {
                  controller.openView();
                },
                leading: const Icon(Icons.search),
              );
            },
            suggestionsBuilder: (BuildContext context, SearchController controller) {
              return List<ListTile>.generate(5, (int index) {
                final String item = 'Item $index';
                return ListTile(
                  title: Text(item),
                  onTap: () {
                    controller.closeView(item);
                  },
                );
              });
            },
          ),

          const SizedBox(height: 10),

          ActivityCard(),
        
          const Card(
            child: ListTile(
              leading: Icon(Icons.notifications_sharp),
              title: Text('Notification 1'),
              subtitle: Text('This is a notification'),
            ),
          ),
          const Card(
            child: ListTile(
              leading: Icon(Icons.notifications_sharp),
              title: Text('Notification 2'),
              subtitle: Text('This is a notification'),
            ),
          ),
        ],
      ),
    );
  }*/
}