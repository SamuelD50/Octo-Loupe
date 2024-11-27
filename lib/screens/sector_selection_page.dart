import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../components/custom_app_bar.dart';
import 'package:octoloupe/model/sport_filter_model.dart';
import 'package:octoloupe/model/culture_filter_model.dart';
import 'package:octoloupe/services/sport_activity_section.dart';
import 'package:octoloupe/services/culture_activity_section.dart';

class SectorSelectionPage extends StatefulWidget {
  final List<String> selectedSectors;
  final bool isSport;

  const SectorSelectionPage({
    super.key,
    required this.selectedSectors,
    required this.isSport,
  });

  @override
  SectorSelectionPageState createState() => SectorSelectionPageState();
}

class SectorSelectionPageState extends State<SectorSelectionPage> {
  late List<String> selectedSectors;
  late Future<List<SportSector>> sportSectorsFunction;
  late Future<List<CultureSector>> cultureSectorsFunction;

  @override
  void initState() {
    super.initState();
    selectedSectors = List.from(widget.selectedSectors);
    sportSectorsFunction = SportService().getSportSectors();
    cultureSectorsFunction = CultureService().getCultureSectors();
  }

/*   final List<Map<String, String>> sportSectors = [
    {"name": "Equeurdreville-Haineville", "image": "assets/images/ballon.jpg"},
    {"name": "Cherbourg-Centre", "image": "assets/images/nautique.jpg"},
    {"name": "Tourlaville", "image": "assets/images/combat.jpg"},
    {"name": "Querqueville", "image": "assets/images/athlétisme.jpg"},
  ];

  final List<Map<String, String>> cultureSectors = [
    {"name": "Equeurdreville-Haineville", "image": "assets/images/ballon.jpg"},
    {"name": "Cherbourg-Centre", "image": "assets/images/nautique.jpg"},
    {"name": "Tourlaville", "image": "assets/images/combat.jpg"},
    {"name": "Querqueville", "image": "assets/images/athlétisme.jpg"},
  ]; */

  @override
  Widget build(BuildContext context) {
    /* final sectors = widget.isSport ? sportSectors : cultureSectors; */

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
                  FutureBuilder<List<SportSector>>(
                    future: sportSectorsFunction,
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
                        return const Center(child: Text('Aucun secteur trouvé'));
                      }

                      final sportSectors = snapshot.data!;

                      return GridView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Deux colonnes
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: sportSectors.length,
                        itemBuilder: (context, index) {
                          final sectorName = sportSectors[index].name;
                          final isSelected = selectedSectors.contains(sectorName);

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedSectors.remove(sectorName);
                                  debugPrint('Désélectionné: $sectorName');
                                } else {
                                  selectedSectors.add(sectorName);
                                  debugPrint('Sélectionné: $sectorName');
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
                                        sportSectors[index].image,
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
                                          sectorName,
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
                  : FutureBuilder<List<CultureSector>>(
                    future: cultureSectorsFunction,
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
                        return const Center(child: Text('Aucun secteur trouvé'));
                      }

                      final cultureSectors = snapshot.data!;

                      return GridView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Deux colonnes
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: cultureSectors.length,
                        itemBuilder: (context, index) {
                          final sectorName = cultureSectors[index].name;
                          final isSelected = selectedSectors.contains(sectorName);

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selectedSectors.remove(sectorName);
                                  debugPrint('Désélectionné: $sectorName');
                                } else {
                                  selectedSectors.add(sectorName);
                                  debugPrint('Sélectionné: $sectorName');
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
                                        cultureSectors[index].image,
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
                                          sectorName,
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
                        Navigator.pop(context, selectedSectors);
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