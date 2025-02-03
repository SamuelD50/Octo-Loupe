import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:octoloupe/components/custom_app_bar.dart';
import 'package:octoloupe/model/sport_filters_model.dart';
import 'package:octoloupe/model/culture_filters_model.dart';
import 'package:octoloupe/services/sport_filter_service.dart';
import 'package:octoloupe/services/culture_filter_service.dart';

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
    sportDaysFunction = SportFilterService().getSportDays();
    cultureDaysFunction = CultureFilterService().getCultureDays();
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
  Widget build(
    BuildContext context
  ) {
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
                        return Center(
                          child: Text('Erreur: ${snapshot.error}')
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('Aucun jour trouvé')
                        );
                      }

                      final sportDays = snapshot.data!;

                      List<String> daysOrder = [
                        'Lundi',
                        'Mardi',
                        'Mercredi',
                        'Jeudi',
                        'Vendredi',
                        'Samedi',
                        'Dimanche'
                      ];

                      sportDays.sort((a, b) {
                        int indexA = daysOrder.indexOf(a.name);
                        int indexB = daysOrder.indexOf(b.name);
                        return indexA.compareTo(indexB);
                      });

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
                                color: isSelected ?
                                  Colors.blueAccent : Colors.transparent,
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
                                        sportDays[index].imageUrl,
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
                                          dayName,
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
                        return Center(
                          child: Text('Erreur: ${snapshot.error}')
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('Aucune jour trouvé')
                        );
                      }

                      final cultureDays = snapshot.data!;

                      List<String> daysOrder = [
                        'Lundi',
                        'Mardi',
                        'Mercredi',
                        'Jeudi',
                        'Vendredi',
                        'Samedi',
                        'Dimanche'
                      ];

                      cultureDays.sort(
                        (a, b) {
                          int indexA = daysOrder.indexOf(a.name);
                          int indexB = daysOrder.indexOf(b.name);
                          return indexA.compareTo(indexB);
                        }
                      );

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
                                color: isSelected ?
                                  Colors.blueAccent : Colors.transparent,
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
                                elevation: isSelected ?
                                  2 : 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.network(
                                        cultureDays[index].imageUrl,
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
                                          dayName,
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
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context, selectedDays);
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
