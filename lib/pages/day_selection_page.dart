import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:octoloupe/components/filter_card.dart';
import 'package:octoloupe/components/loading.dart';
import 'package:octoloupe/model/sport_filters_model.dart';
import 'package:octoloupe/model/culture_filters_model.dart';
import 'package:octoloupe/services/sport_filter_service.dart';
import 'package:octoloupe/services/culture_filter_service.dart';

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
  late List<Map<String, String>> selectedDays;
  late Future<List<SportDay>> sportDaysReceiver;
  late Future<List<CultureDay>> cultureDaysReceiver;
  

  @override
  void initState() {
    super.initState();
    selectedDays = List.from(widget.selectedDays ?? []);
    sportDaysReceiver = SportFilterService().getSportDays();
    cultureDaysReceiver = CultureFilterService().getCultureDays();
  }

  @override
  Widget build(
    BuildContext context
  ) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth > 325 ? 20.0 : 14.0;

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
                          itemCount: sportDays.length,
                          itemBuilder: (context, index) {
                            final day = sportDays[index];
                            final isSelected = selectedDays.any((selected) =>
                              selected['id'] == day.id);

                            return FilterCard(
                              name: day.name,
                              imageUrl: day.imageUrl,
                              isSelected: isSelected,
                              fontSize: fontSize,
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedDays.removeWhere((selected) =>
                                      selected['id'] == day.id);
                                  } else {
                                    if (day.id != null) {
                                      selectedDays.add({
                                        'id': day.id!,
                                        'name': day.name,
                                      });
                                    }
                                  }
                                });
                              },
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
                          itemCount: cultureDays.length,
                          itemBuilder: (context, index) {
                            final day = cultureDays[index];
                            final isSelected = selectedDays.any((selected) =>
                              selected['id'] == day.id);

                            return FilterCard(
                              name: day.name,
                              imageUrl: day.imageUrl,
                              isSelected: isSelected,
                              fontSize: fontSize,
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedDays.removeWhere((selected) =>
                                      selected['id'] == day.id);
                                  } else {
                                    if (day.id != null) {
                                      selectedDays.add({
                                        'id': day.id!,
                                        'name': day.name,
                                      });
                                    }
                                  }
                                });
                              },
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
