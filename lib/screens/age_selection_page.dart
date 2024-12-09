import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../components/custom_app_bar.dart';
import 'package:octoloupe/model/sport_filter_model.dart';
import 'package:octoloupe/model/culture_filter_model.dart';
import 'package:octoloupe/services/sport_activity_section.dart';
import 'package:octoloupe/services/culture_activity_section.dart';

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
    sportAgesFunction = SportService().getSportAges();
    cultureAgesFunction = CultureService().getCultureAges();
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
    /* final ages = widget.isSport ? sportAges : cultureAges; */
    
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

                      sportAges.sort((a, b) => a.name.compareTo(b.name));

                      return GridView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Deux colonnes
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: sportAges.length,
                        itemBuilder: (context, index) {
                          final ageName = sportAges[index].name;
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
                                      child: Image.network(
                                        sportAges[index].imageUrl,
                                        fit:BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          ageName,
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

                      cultureAges.sort((a, b) => a.name.compareTo(b.name));

                      return GridView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Deux colonnes
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: cultureAges.length,
                        itemBuilder: (context, index) {
                          final ageName = cultureAges[index].name;
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
                                      child: Image.network(
                                        cultureAges[index].imageUrl,
                                        fit:BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          ageName,
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
                  SizedBox(width: 32),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF5B59B4),
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Color(0xFF5B59B4)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context, selectedAges);
                    },
                    child: Text('Valider'),
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