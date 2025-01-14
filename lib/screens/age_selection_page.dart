import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../components/custom_app_bar.dart';
import 'package:octoloupe/model/sport_filters_model.dart';
import 'package:octoloupe/model/culture_filters_model.dart';
import 'package:octoloupe/services/sport_filter_service.dart';
import 'package:octoloupe/services/culture_filter_service.dart';

class AgeSelectionPage extends StatefulWidget {
  final List<String> selectedAges;
  final bool isSport;

  const AgeSelectionPage({
    super.key,
    required this.selectedAges,
    required this.isSport,
  });

  @override
  AgeSelectionPageState createState() => AgeSelectionPageState();
}

class AgeSelectionPageState extends State<AgeSelectionPage> {
  late List<String> selectedAges;
  late Future<List<SportAge>> sportAgesFunction;
  late Future<List<CultureAge>> cultureAgesFunction;

  @override
  void initState() {
    super.initState();
    selectedAges = List.from(widget.selectedAges);
    sportAgesFunction = SportFilterService().getSportAges();
    cultureAgesFunction = CultureFilterService().getCultureAges();
  }

  List<T> sortAges<T>(List<T> ages) {
    int? getMinAge(String ageRange) {
      final startAge = ageRange.split('-');
      
      if (startAge.length == 1) {
        return null;
      }
      return int.tryParse(startAge[0].split(' ')[0]);
    }

    ages.sort((a, b) {
      String nameA = a is SportAge ? a.name : (a is CultureAge ? a.name : '');
      String nameB = b is SportAge ? b.name : (b is CultureAge ? b.name : '');
      int? minAgeA = getMinAge(nameA);
      int? minAgeB = getMinAge(nameB);
      if (minAgeA == null && minAgeB != null) return 1;
      if (minAgeB == null && minAgeA != null) return -1;
      return (minAgeA ?? 0).compareTo(minAgeB ?? 0);
    });

    return ages;
  }

  /* final List<Map<String, String>> sportAges = [
    {"name": "3-7 ans", "image": "assets/images/ballon.jpg"},
    {"name": "8-11 ans", "image": "assets/images/nautique.jpg"},
    {"name": "12-17 ans", "image": "assets/images/combat.jpg"},
    {"name": "18 ans et +", "image": "assets/images/athlétisme.jpg"},
  ];

  final List<Map<String, String>> cultureAges = [
    {"name": "3-7 ans", "image": "assets/images/ballon.jpg"},
    {"name": "8-11 ans", "image": "assets/images/nautique.jpg"},
    {"name": "12-17 ans", "image": "assets/images/combat.jpg"},
    {"name": "18 ans et +", "image": "assets/images/athlétisme.jpg"},
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
                  FutureBuilder<List<SportAge>>(
                    future: sportAgesFunction,
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
                        return const Center(child: Text('Aucun âge trouvé'));
                      }

                      final sportAges = snapshot.data!;

                      final sortedAges = sortAges(sportAges);

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
                        itemCount: sortedAges.length,
                        itemBuilder: (context, index) {
                          final ageName = sortedAges[index].name;
                          final isSelected = selectedAges.contains(ageName);

                        return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedAges.remove(ageName);
                                  debugPrint('Désélectionné: $ageName');
                                } else {
                                  selectedAges.add(ageName);
                                  debugPrint('Sélectionné: $ageName');
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
                                        sortedAges[index].imageUrl,
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
                                          ageName,
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
                  : FutureBuilder<List<CultureAge>>(
                    future: cultureAgesFunction,
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
                        return const Center(child: Text('Aucune âge trouvé'));
                      }

                      final cultureAges = snapshot.data!;

                      final sortedAges = sortAges(cultureAges);

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
                        itemCount: sortedAges.length,
                        itemBuilder: (context, index) {
                          final ageName = sortedAges[index].name;
                          final isSelected = selectedAges.contains(ageName);

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedAges.remove(ageName);
                                  debugPrint('Désélectionné: $ageName');
                                } else {
                                  selectedAges.add(ageName);
                                  debugPrint('Sélectionné: $ageName');
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
                                        sortedAges[index].imageUrl,
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
                                          ageName,
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
                      Navigator.pop(context, selectedAges);
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