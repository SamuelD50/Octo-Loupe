import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../components/custom_app_bar.dart';
import 'package:octoloupe/model/sport_filter_model.dart';
import 'package:octoloupe/model/culture_filter_model.dart';
import 'package:octoloupe/services/sport_activity_section.dart';
import 'package:octoloupe/services/culture_activity_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DaySelectionPage extends StatefulWidget {
  final List<String> selectedDays;
  final bool isSport;

  const DaySelectionPage({
    super.key,
    required this.selectedDays,
    required this.isSport,
  });

  @override
  DaySelectionPageState createState() => DaySelectionPageState();
}

class DaySelectionPageState extends State<DaySelectionPage> {
  late List<String> selectedDays;
  late Future<List<SportDay>> sportDaysFunction;
  late Future<List<CultureDay>> cultureDaysFunction;
  

  @override
  void initState() {
    super.initState();
    selectedDays = List.from(widget.selectedDays);
    sportDaysFunction = SportService().getSportDays();
    cultureDaysFunction = CultureService().getCultureDays();
  }

  /* final List<Map<String, String>> sportDays =[
    {"name": "Lundi", "image": "assets/images/ballon.jpg"},
    {"name": "Mardi", "image": "assets/images/nautique.jpg"},
    {"name": "Mercredi", "image": "assets/images/combat.jpg"},
    {"name": "Jeudi", "image": "assets/images/athlétisme.jpg"},
    {"name": "Vendredi", "image": "assets/images/raquette.jpg"},
    {"name": "Samedi", "image": "assets/images/collectif.jpg"},
    {"name": "Dimanche", "image": "assets/images/individuel.jpg"},
  ];

  final List<Map<String, String>> cultureDays =[
    {"name": "Lundi", "image": "assets/images/ballon.jpg"},
    {"name": "Mardi", "image": "assets/images/nautique.jpg"},
    {"name": "Mercredi", "image": "assets/images/combat.jpg"},
    {"name": "Jeudi", "image": "assets/images/athlétisme.jpg"},
    {"name": "Vendredi", "image": "assets/images/raquette.jpg"},
    {"name": "Samedi", "image": "assets/images/collectif.jpg"},
    {"name": "Dimanche", "image": "assets/images/individuel.jpg"},
  ]; */

  @override
  Widget build(BuildContext context) {
   /*  final days = widget.isSport ? sportDays : cultureDays; */

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
                  FutureBuilder<List<SportDay>>(
                    future: sportDaysFunction,
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
                        return const Center(child: Text('Aucun jour trouvé'));
                      }

                      final sportDays = snapshot.data!;

                      return GridView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Deux colonnes
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: sportDays.length,
                        itemBuilder: (context, index) {
                          final dayName = sportDays[index].name;
                          final isSelected = selectedDays.contains(dayName);

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedDays.remove(dayName);
                                  debugPrint('Désélectionné: $dayName');
                                } else {
                                  selectedDays.add(dayName);
                                  debugPrint('Sélectionné: $dayName');
                                }
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.blueAccent : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
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
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        sportDays[index].image,
                                        fit:BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      color: Colors.black54,
                                      child: Center(
                                        child: Text(
                                          dayName,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
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
                  : FutureBuilder<List<CultureDay>>(
                    future: cultureDaysFunction,
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
                        return const Center(child: Text('Aucune jour trouvé'));
                      }

                      final cultureDays = snapshot.data!;

                      return GridView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Deux colonnes
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: cultureDays.length,
                        itemBuilder: (context, index) {
                          final dayName = cultureDays[index].name;
                          final isSelected = selectedDays.contains(dayName);

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedDays.remove(dayName);
                                  debugPrint('Désélectionné: $dayName');
                                } else {
                                  selectedDays.add(dayName);
                                  debugPrint('Sélectionné: $dayName');
                                }
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.blueAccent : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
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
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        cultureDays[index].image,
                                        fit:BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      color: Colors.black54,
                                      child: Center(
                                        child: Text(
                                          dayName,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
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
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, selectedDays);
                      },
                      child: Text('Valider'),
                    ),
                  ),  
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
