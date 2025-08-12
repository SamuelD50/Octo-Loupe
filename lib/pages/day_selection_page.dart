import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:octoloupe/components/filter_card.dart';
import 'package:octoloupe/components/loading.dart';
import 'package:octoloupe/model/sport_filters_model.dart';
import 'package:octoloupe/model/culture_filters_model.dart';
import 'package:octoloupe/providers/filter_provider.dart';
import 'package:octoloupe/services/sport_filter_service.dart';
import 'package:octoloupe/services/culture_filter_service.dart';
import 'package:provider/provider.dart';

class DaySelectionPage extends StatefulWidget {
  final List<Map<String, String>>? selectedDays;
  final bool isSport;

  const DaySelectionPage({
    super.key,
    this.selectedDays,
    required this.isSport,
  });

  @override
  DaySelectionPageState createState() => DaySelectionPageState();
}

class DaySelectionPageState extends State<DaySelectionPage> {
  late Future<List<SportDay>> sportDaysReceiver;
  late Future<List<CultureDay>> cultureDaysReceiver;
  
  @override
  void initState() {
    super.initState();
    sportDaysReceiver = SportFilterService().getSportDays();
    cultureDaysReceiver = CultureFilterService().getCultureDays();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final readFilterProvider = context.read<FilterProvider>();
      readFilterProvider.setSection(widget.isSport ? 0 : 1);
      if (widget.selectedDays != null) {
        readFilterProvider.setSelectedAges(
          selectedSection: widget.isSport ? 0 : 1,
          selectedAges: widget.selectedDays,
        );
      }
    });
  }

  List<String> daysOrder = [
    'Lundi',
    'Mardi',
    'Mercredi',
    'Jeudi',
    'Vendredi',
    'Samedi',
    'Dimanche'
  ];

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
                  FutureBuilder<List<SportDay>>(
                    future: sportDaysReceiver,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Loading();
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
                      sportDays.sort((a, b) {
                        int indexA = daysOrder.indexOf(a.name);
                        int indexB = daysOrder.indexOf(b.name);
                        return indexA.compareTo(indexB);
                      });

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
                            itemCount: sportDays.length,
                            itemBuilder: (context, index) {
                              final day = sportDays[index];
                              final isSelected = watchFilterProvider.selectedSportDays.any((selected) =>
                                selected.id == day.id);

                              return Semantics(
                                button: true,
                                selected: isSelected,
                                label: day.name,
                                hint: isSelected ?
                                  'Sélectionné, tapez pour désélectionner'
                                  : 'Non sélectionné, tapez pour sélectionner',
                                  child: Focus(
                                    child: FilterCard(
                                      name: day.name,
                                      imageUrl: day.imageUrl,
                                      isSelected: isSelected,
                                      fontSize: fontSize,
                                      onTap: () {
                                        final selectedDays = watchFilterProvider.selectedSportDays
                                          .map((day) => {
                                            'id': day.id!,
                                            'name': day.name,
                                          }).toList();

                                        if (isSelected) {
                                          selectedDays
                                            .removeWhere((selected) => selected['id'] == day.id);
                                        } else {
                                          if (day.id != null) {
                                            selectedDays.add({
                                              'id': day.id!,
                                              'name': day.name,
                                            });
                                          }
                                        }

                                        watchFilterProvider.setSelectedDays(
                                          selectedSection: 0,
                                          selectedDays: selectedDays,
                                        );
                                      },
                                    ),
                                  ),
                              );
                            },
                          ),
                          if (sportDays.isNotEmpty)
                            SizedBox(height: 8),
                          if (sportDays.isNotEmpty)
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
                                final selectedDays = readFilterProvider.selectedSportDays
                                  .map((day) => {
                                    'id': day.id!,
                                    'name': day.name,
                                  }).toList();
                                context.pop(selectedDays);
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
                : FutureBuilder<List<CultureDay>>(
                  future: cultureDaysReceiver,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Loading();
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
                    cultureDays.sort(
                      (a, b) {
                        int indexA = daysOrder.indexOf(a.name);
                        int indexB = daysOrder.indexOf(b.name);
                        return indexA.compareTo(indexB);
                      }
                    );

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
                          itemCount: cultureDays.length,
                          itemBuilder: (context, index) {
                            final day = cultureDays[index];
                            final isSelected = watchFilterProvider.selectedCultureDays.any((selected) =>
                              selected.id == day.id);

                            return Semantics(
                              button: true,
                              selected: isSelected,
                              label: day.name,
                              hint: isSelected ?
                                'Sélectionné, tapez pour désélectionnner'
                                : 'Non sélectionné, tapez pour sélectionner',
                                child: Focus(
                                  child: FilterCard(
                                    name: day.name,
                                    imageUrl: day.imageUrl,
                                    isSelected: isSelected,
                                    fontSize: fontSize,
                                    onTap: () {
                                      final selectedDays = watchFilterProvider.selectedCultureDays
                                        .map((day) => {
                                          'id': day.id!,
                                          'name': day.name,
                                        }).toList();

                                      if (isSelected) {
                                        selectedDays
                                          .removeWhere((selected) => selected['id'] == day.id);
                                      } else {
                                        if (day.id != null) {
                                          selectedDays.add({
                                            'id': day.id!,
                                            'name': day.name,
                                          });
                                        }
                                      }

                                      watchFilterProvider.setSelectedDays(
                                        selectedSection: 1,
                                        selectedDays: selectedDays,
                                      );
                                    },
                                  ),
                                )
                            );
                          },
                        ),
                        if (cultureDays.isNotEmpty)
                          SizedBox(height: 8),
                        if (cultureDays.isNotEmpty)
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
                              final selectedDays = readFilterProvider.selectedCultureDays
                                .map((day) => {
                                  'id': day.id!,
                                  'name': day.name,
                                }).toList();
                              context.pop(selectedDays);
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
