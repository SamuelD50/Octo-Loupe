import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../components/custom_app_bar.dart';
import 'package:octoloupe/model/sport_filters_model.dart';
import 'package:octoloupe/model/culture_filters_model.dart';
import 'package:octoloupe/services/sport_service.dart';
import 'package:octoloupe/services/culture_service.dart';

class ScheduleSelectionPage extends StatefulWidget {
  final List<String> selectedSchedules;
  final bool isSport;

  const ScheduleSelectionPage({
    super.key,
    required this.selectedSchedules,
    required this.isSport,
  });

  @override
  ScheduleSelectionPageState createState() => ScheduleSelectionPageState();
}

class ScheduleSelectionPageState extends State<ScheduleSelectionPage> {
  late List<String> selectedSchedules;
  late Future<List<SportSchedule>> sportSchedulesFunction;
  late Future<List<CultureSchedule>> cultureSchedulesFunction;

  @override
  void initState() {
    super.initState();
    selectedSchedules = List.from(widget.selectedSchedules);
    sportSchedulesFunction = SportService().getSportSchedules();
    cultureSchedulesFunction = CultureService().getCultureSchedules();
  }

  List<T> sortSchedules<T>(List<T> schedules) {
    int getStartTime(String timeRange) {
      int startHour = int.parse(timeRange.split('-')[0].split('h')[0]);
      return startHour;
    }

    schedules.sort((a, b) {
      String nameA = a is SportSchedule ? a.name : (a is CultureSchedule ? a.name : '');
      String nameB = b is SportSchedule ? b.name : (b is CultureSchedule ? b.name : '');

      int startTimeA = getStartTime(nameA);
      int startTimeB = getStartTime(nameB);
      return startTimeA.compareTo(startTimeB);
    });
    return schedules;
  }

  /* final List<Map<String, String>> sportSchedules = [
    {"name": "8h-12h", "image": "assets/images/ballon.jpg"},
    {"name": "12h-14h", "image": "assets/images/nautique.jpg"},
    {"name": "14h-17h", "image": "assets/images/combat.jpg"},
    {"name": "17h-22h", "image": "assets/images/athlétisme.jpg"},
  ];

  final List<Map<String, String>> cultureSchedules = [
    {"name": "8h-12h", "image": "assets/images/ballon.jpg"},
    {"name": "12h-14h", "image": "assets/images/nautique.jpg"},
    {"name": "14h-17h", "image": "assets/images/combat.jpg"},
    {"name": "17h-22h", "image": "assets/images/athlétisme.jpg"},
  ]; */

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth > 325 ? 20.0 : 14.0;

    return Scaffold(
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
                  widget.isSport ?
                  FutureBuilder<List<SportSchedule>>(
                    future: sportSchedulesFunction,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SpinKitSpinningLines(
                            color: Colors.white,
                            size: 60,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Erreur: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('Aucun horaire trouvé'));
                      }

                      final sportSchedules = snapshot.data!;

                      final sortedSchedules = sortSchedules(sportSchedules);

                      return GridView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: MediaQuery.of(context).size.width < 250 ?
                          1 : MediaQuery.of(context).size.width < 600 ?
                          2 : 3, // Deux colonnes
                          crossAxisSpacing: 12.0,
                          mainAxisSpacing: 12.0,
                        ),
                        itemCount: sortedSchedules.length,
                        itemBuilder: (context, index) {
                          final scheduleName = sortedSchedules[index].name;
                          final isSelected = selectedSchedules.contains(scheduleName);

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedSchedules.remove(scheduleName);
                                  debugPrint('Désélectionné: $scheduleName');
                                } else {
                                  selectedSchedules.add(scheduleName);
                                  debugPrint('Sélectionné: $scheduleName');
                                }
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.blueAccent : Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: isSelected
                                  ? []
                                  : [
                                      BoxShadow(
                                        color: Colors.black54,
                                        offset: Offset(2, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                              ),
                              child: Card(
                                elevation: isSelected ? 2 : 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.network(
                                        sortedSchedules[index].imageUrl,
                                        fit:BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Center(
                                        child: Text(
                                          scheduleName,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: fontSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )
                  : FutureBuilder<List<CultureSchedule>>(
                    future: cultureSchedulesFunction,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SpinKitSpinningLines(
                            color: Colors.white,
                            size: 60,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Erreur: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('Aucun horaire trouvé'));
                      }

                      final cultureSchedules = snapshot.data!;

                      final sortedSchedules = sortSchedules(cultureSchedules);

                      return GridView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: MediaQuery.of(context).size.width < 250 ?
                          1 : MediaQuery.of(context).size.width < 600 ?
                          2 : 3, // Deux colonnes
                          crossAxisSpacing: 12.0,
                          mainAxisSpacing: 12.0,
                        ),
                        itemCount: sortedSchedules.length,
                        itemBuilder: (context, index) {
                          final scheduleName = sortedSchedules[index].name;
                          final isSelected = selectedSchedules.contains(scheduleName);

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedSchedules.remove(scheduleName);
                                  debugPrint('Désélectionné: $scheduleName');
                                } else {
                                  selectedSchedules.add(scheduleName);
                                  debugPrint('Sélectionné: $scheduleName');
                                }
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.blueAccent : Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: isSelected
                                  ? []
                                  : [
                                      BoxShadow(
                                        color: Colors.black54,
                                        offset: Offset(2, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                              ),
                              child: Card(
                                elevation: isSelected ? 2 : 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.network(
                                        sortedSchedules[index].imageUrl,
                                        fit:BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Center(
                                        child: Text(
                                          scheduleName,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: fontSize,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF5B59B4),
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Color(0xFF5B59B4)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context, selectedSchedules);
                    },
                    child: Text('Valider'),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}