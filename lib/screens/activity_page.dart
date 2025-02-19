import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:octoloupe/components/custom_app_bar.dart';
import 'package:octoloupe/model/activity_model.dart';
import 'package:octoloupe/components/activity_card.dart';
import 'package:octoloupe/components/activity_map.dart';
import 'package:octoloupe/services/culture_activity_service.dart';
import 'package:octoloupe/services/sport_activity_service.dart';

class ActivityPage extends StatefulWidget {
  final Map<String, List<Map<String, String>>> filters;
  const ActivityPage({super.key, required this.filters});

  @override
  ActivityPageState createState() => ActivityPageState();
}

class ActivityPageState extends State<ActivityPage> {
  bool isLoading = false;
  int selectedSection = 0;
  List<Map<String, dynamic>> activities = [];
  List<Map<String, dynamic>> filteredActivities = [];
  SportActivityService sportActivityService = SportActivityService();
  CultureActivityService cultureActivityService = CultureActivityService();

  @override
  void initState() {
    super.initState();
    readActivities();
  }

  Future<void> readActivities() async {
    try {
      setState(() {
        isLoading = true;
      });

      if (selectedSection == 0) {
        activities = (await sportActivityService.getSportActivities())
          .map((item) => (item).toMap())
          .toList();
      } else {
        activities = (await cultureActivityService.getCultureActivities())
          .map((item) => (item).toMap())
          .toList();
      }
      
      filterActivities();

      await Future.delayed(Duration(milliseconds: 25));

      setState(() {
        isLoading = false;
      });
    
    } catch (e) {
      debugPrint('Error fetching activity: $e');
    }
  }

 void filterActivities() {
  filteredActivities = activities.where((activity) {
    bool matchesCategory = (widget.filters['categories']?.isEmpty ?? true) ||
      widget.filters['categories']!.any((category) =>
        (activity['filters']?['categoryId'] as List?)
          ?.any((item) => item['id'] == category['id']) ?? false);
    bool matchesAge = (widget.filters['ages']?.isEmpty ?? true) ||
      widget.filters['ages']!.any((age) =>
        (activity['filters']?['ageId'] as List?)
          ?.any((item) => item['id'] == age['id']) ?? false);
    bool matchesDay = (widget.filters['days']?.isEmpty ?? true) ||
      widget.filters['days']!.any((day) =>
        (activity['filters']?['dayId'] as List?)
          ?.any((item) => item['id'] == day['id']) ?? false);
    bool matchesSchedule = (widget.filters['schedules']?.isEmpty ?? true) ||
      widget.filters['schedules']!.any((schedule) =>
        (activity['filters']?['scheduleId'] as List?)
          ?.any((item) => item['id'] == schedule['id']) ?? false);
    bool matchesSector = (widget.filters['sectors']?.isEmpty ?? true) ||
      widget.filters['sectors']!.any((sector) =>
        (activity['filters']?['sectorId'] as List?)
          ?.any((item) => item['id'] == sector['id']) ?? false);
      return matchesCategory || matchesAge || matchesDay || matchesSchedule || matchesSector;
  }).toList();
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
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    Color(0xFF5D71FF),
                    Color(0xFFF365C7),
                  ],
                ),
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
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    Color(0xFF5D71FF),
                    Color(0xFFF365C7),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ...filteredActivities.map((filteredActivity) {
                      Place place = Place.fromMap(filteredActivity['place'] ?? {});
                      List<Schedule> schedules = (filteredActivity['schedules'] as List?)
                        ?.map((schedule) => Schedule.fromMap(schedule as Map<String, dynamic>))
                        .toList() ?? [];
                      List<Pricing> pricings = (filteredActivity['pricings'] as List?)
                        ?.map((pricing) => Pricing.fromMap(pricing as Map<String, String>))
                        .toList() ?? [];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: ActivityCard(
                              imageUrl: filteredActivity['imageUrl'] ?? '',
                              discipline: filteredActivity['discipline'] ?? '',
                              place: place,
                              schedules: schedules,
                              pricings: pricings,
                              onTap: () {

                              },
                            ),
                          ),
                        ),
                      ); 
                    }).toList(),
                  ],
                ),
              ),
            )
          ],
        )
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