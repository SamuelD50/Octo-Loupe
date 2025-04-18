import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:octoloupe/components/custom_app_bar.dart';
import 'package:octoloupe/components/filter_card.dart';
import 'package:octoloupe/model/sport_filters_model.dart';
import 'package:octoloupe/model/culture_filters_model.dart';
import 'package:octoloupe/services/sport_filter_service.dart';
import 'package:octoloupe/services/culture_filter_service.dart';

class SectorSelectionPage extends StatefulWidget {
  final List<Map<String, String>>? selectedSectors;
  final bool isSport;

  const SectorSelectionPage({
    super.key,
    this.selectedSectors,
    required this.isSport,
  });

  @override
  SectorSelectionPageState createState() => SectorSelectionPageState();
}

class SectorSelectionPageState extends State<SectorSelectionPage> {
  late List<Map<String, String>> selectedSectors;
  late Future<List<SportSector>> sportSectorsReceiver;
  late Future<List<CultureSector>> cultureSectorsReceiver;

  @override
  void initState() {
    super.initState();
    selectedSectors = List.from(widget.selectedSectors ?? []);
    sportSectorsReceiver = SportFilterService().getSportSectors();
    cultureSectorsReceiver = CultureFilterService().getCultureSectors();
  }

  @override
  Widget build(
    BuildContext context
  ) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth > 325 ?
      20.0 : 14.0;

    return Scaffold(
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 8)
                  ),
                  widget.isSport ?
                  FutureBuilder<List<SportSector>>(
                    future: sportSectorsReceiver,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SpinKitSpinningLines(
                            color: Colors.black,
                            size: 60,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Erreur: ${snapshot.error}')
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('Aucun secteur trouvé')
                        );
                      }

                      final sportSectors = snapshot.data!;

                      sportSectors.sort(
                        (a, b) => a.name.compareTo(b.name)
                      );

                      return Column(
                        children: [
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(2.0),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: MediaQuery.of(context).size.width < 250 ?
                                1 : MediaQuery.of(context).size.width < 600 ?
                                  2 : 3, // Deux colonnes
                              crossAxisSpacing: 2.0,
                              mainAxisSpacing: 2.0,
                            ),
                            itemCount: sportSectors.length,
                            itemBuilder: (context, index) {
                              final sector = sportSectors[index];
                              final isSelected = selectedSectors.any((selected) =>
                                selected['id'] == sector.id);

                              return FilterCard(
                                name: sector.name,
                                imageUrl: sector.imageUrl,
                                isSelected: isSelected,
                                fontSize: fontSize,
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      selectedSectors.removeWhere((selected) =>
                                        selected['id'] == sector.id);
                                    } else {
                                      if (sector.id != null) {
                                        selectedSectors.add({
                                          'id': sector.id!,
                                          'name': sector.name,
                                        });
                                      }
                                    }
                                  });
                                },
                              );
                            },
                          ),
                          if (sportSectors.isNotEmpty)
                            SizedBox(height: 8),
                          if (sportSectors.isNotEmpty)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF5B59B4),
                                foregroundColor: Colors.white,
                                side: BorderSide(color: Color(0xFF5B59B4)),
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context, selectedSectors);
                              },
                              child: Text('Valider',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 8)
                          ),
                        ],
                      );
                    },
                  )
                  : FutureBuilder<List<CultureSector>>(
                    future: cultureSectorsReceiver,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SpinKitSpinningLines(
                            color: Colors.black,
                            size: 60,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Erreur: ${snapshot.error}')
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('Aucun secteur trouvé')
                        );
                      }

                      final cultureSectors = snapshot.data!;

                      cultureSectors.sort(
                        (a, b) => a.name.compareTo(b.name)
                      );

                      return Column(
                        children: [
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(2.0),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: MediaQuery.of(context).size.width < 250 ?
                                1 : MediaQuery.of(context).size.width < 600 ?
                                  2 : 3, // Deux colonnes
                              crossAxisSpacing: 2.0,
                              mainAxisSpacing: 2.0,
                            ),
                            itemCount: cultureSectors.length,
                            itemBuilder: (context, index) {
                              final sector = cultureSectors[index];
                              final isSelected = selectedSectors.any((selected) =>
                                selected['id'] == sector.id);

                              return FilterCard(
                                name: sector.name,
                                imageUrl: sector.imageUrl,
                                isSelected: isSelected,
                                fontSize: fontSize,
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      selectedSectors.removeWhere((selected) =>
                                        selected['id'] == sector.id);
                                    } else {
                                      if (sector.id != null) {
                                        selectedSectors.add({
                                          'id': sector.id!,
                                          'name': sector.name,
                                        });
                                      }
                                    }
                                  });
                                },
                              );
                            },
                          ),
                          if (cultureSectors.isNotEmpty)
                            SizedBox(height: 8),
                          if (cultureSectors.isNotEmpty)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF5B59B4),
                                foregroundColor: Colors.white,
                                side: BorderSide(color: Color(0xFF5B59B4)),
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context, selectedSectors);
                              },
                              child: Text('Valider',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 8)
                          ),
                        ],
                      );
                    },
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