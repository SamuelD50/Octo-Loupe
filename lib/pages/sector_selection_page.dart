import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:octoloupe/components/filter_card.dart';
import 'package:octoloupe/components/loading.dart';
import 'package:octoloupe/model/sport_filters_model.dart';
import 'package:octoloupe/model/culture_filters_model.dart';
import 'package:octoloupe/providers/filter_provider.dart';
import 'package:octoloupe/services/sport_filter_service.dart';
import 'package:octoloupe/services/culture_filter_service.dart';
import 'package:provider/provider.dart';

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
  late Future<List<SportSector>> sportSectorsReceiver;
  late Future<List<CultureSector>> cultureSectorsReceiver;

  @override
  void initState() {
    super.initState();
    sportSectorsReceiver = SportFilterService().getSportSectors();
    cultureSectorsReceiver = CultureFilterService().getCultureSectors();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final readFilterProvider = context.read<FilterProvider>();
      readFilterProvider.setSection(widget.isSport ? 0 : 1);
      if (widget.selectedSectors != null) {
        readFilterProvider.setSelectedSectors(
          selectedSection: widget.isSport ? 0 : 1,
          selectedSectors: widget.selectedSectors,
        );
      }
    });
  }

  @override
  Widget build(
    BuildContext context
  ) {
        final watchFilterProvider = context.watch<FilterProvider>();

    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth > 325 ? 20.0 : 14.0;
    final crossAxisCount = screenWidth < 250 ? 1 : screenWidth < 600 ? 2 : 3;

    return Stack(
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
                        return const Loading();
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Erreur: ${snapshot.error}')
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('Aucun secteur trouvé')
                        );
                      }

                      final sportSectors = snapshot.data!..sort((a, b) => a.name.compareTo(b.name));

                      return Column(
                        children: [
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(2.0),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount, // Deux colonnes
                              crossAxisSpacing: 2.0,
                              mainAxisSpacing: 2.0,
                            ),
                            itemCount: sportSectors.length,
                            itemBuilder: (context, index) {
                              final sector = sportSectors[index];
                              final isSelected = watchFilterProvider.selectedSportSectors.any((selected) =>
                                selected.id == sector.id);

                              return Semantics(
                                button: true,
                                selected: isSelected,
                                label: sector.name,
                                hint: isSelected ?
                                  'Sélectionné, tapez pour désélectionner'
                                  : 'Non sélectionné, tapez pour sélectionner',
                                  child: Focus(
                                    child: FilterCard(
                                      name: sector.name,
                                      imageUrl: sector.imageUrl,
                                      isSelected: isSelected,
                                      fontSize: fontSize,
                                      onTap: () {
                                        final selectedSectors = watchFilterProvider.selectedSportSectors
                                          .map((sector) => {
                                            'id': sector.id!,
                                            'name': sector.name,
                                          }).toList();
                                        
                                        if (isSelected) {
                                          selectedSectors
                                            .removeWhere((selected) => selected['id'] == sector.id);
                                        } else {
                                          if (sector.id != null) {
                                            selectedSectors.add({
                                              'id': sector.id!,
                                              'name': sector.name,
                                            });
                                          }
                                        }

                                        watchFilterProvider.setSelectedSectors(
                                          selectedSection: 0,
                                          selectedSectors: selectedSectors,
                                        );
                                      },
                                    ),
                                  ),
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
                                final readFilterProvider = context.read<FilterProvider>();
                                final selectedSectors = readFilterProvider.selectedSportSectors
                                  .map((sector) => {
                                    'id': sector.id!,
                                    'name': sector.name
                                  }).toList();
                                context.pop(selectedSectors);
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
                      return const Loading();
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Erreur: ${snapshot.error}')
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('Aucun secteur trouvé')
                      );
                    }

                    final cultureSectors = snapshot.data!..sort((a, b) => a.name.compareTo(b.name));

                    return Column(
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(2.0),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount, // Deux colonnes
                            crossAxisSpacing: 2.0,
                            mainAxisSpacing: 2.0,
                          ),
                          itemCount: cultureSectors.length,
                          itemBuilder: (context, index) {
                            final sector = cultureSectors[index];
                            final isSelected = watchFilterProvider.selectedCultureSectors.any((selected) =>
                              selected.id == sector.id);

                            return Semantics(
                              button: true,
                              selected: isSelected,
                              label: sector.name,
                              hint: isSelected ?
                                'Sélectionné, tapez pour désélectionnner'
                                : 'Non sélectionné, tapez pour sélectionner',
                                child: Focus(
                                  child: FilterCard(
                                    name: sector.name,
                                    imageUrl: sector.imageUrl,
                                    isSelected: isSelected,
                                    fontSize: fontSize,
                                    onTap: () {
                                      final selectedSectors = watchFilterProvider.selectedCultureSectors
                                        .map((sector) => {
                                          'id': sector.id!,
                                          'name': sector.name,
                                        }).toList();

                                      if (isSelected) {
                                        selectedSectors
                                          .removeWhere((selected) => selected['id'] == sector.id);
                                      } else {
                                        if (sector.id != null) {
                                          selectedSectors.add({
                                            'id': sector.id!,
                                            'name': sector.name,
                                          });
                                        }
                                      }

                                      watchFilterProvider.setSelectedSectors(
                                        selectedSection: 1,
                                        selectedSectors: selectedSectors,
                                      );
                                    },
                                  ),
                                ),
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
                              final readFilterProvider = context.read<FilterProvider>();
                              final selectedSectors = readFilterProvider.selectedCultureSectors
                                .map((sector) => {
                                  'id': sector.id!,
                                  'name': sector.name,
                                }).toList();
                              context.pop(selectedSectors);
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
    );
  }
}