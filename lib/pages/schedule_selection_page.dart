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

class ScheduleSelectionPage extends StatefulWidget {
  final List<Map<String, String>>? selectedSchedules;
  final bool isSport;

  const ScheduleSelectionPage({
    super.key,
    this.selectedSchedules,
    required this.isSport,
  });

  @override
  ScheduleSelectionPageState createState() => ScheduleSelectionPageState();
}

class ScheduleSelectionPageState extends State<ScheduleSelectionPage> {
  late Future<List<SportSchedule>> sportSchedulesReceiver;
  late Future<List<CultureSchedule>> cultureSchedulesReceiver;

  @override
  void initState() {
    super.initState();
    sportSchedulesReceiver = SportFilterService().getSportSchedules();
    cultureSchedulesReceiver = CultureFilterService().getCultureSchedules();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final readFilterProvider = context.read<FilterProvider>();
      readFilterProvider.setSection(widget.isSport ? 0 : 1);
      if (widget.selectedSchedules != null) {
        readFilterProvider.setSelectedSchedules(
          selectedSection: widget.isSport ? 0 : 1,
          selectedSchedules: widget.selectedSchedules,
        );
      }
    });
  }

  List<T> sortSchedules<T>(
    List<T> schedules
  ) {
    int getStartTime(String timeRange) {
      int startHour = int.parse(
        timeRange.split('-')[0].split('h')[0]
      );
      return startHour;
    }

    schedules.sort((a, b) {
      String nameA = a is SportSchedule ?
        a.name : (a is CultureSchedule ?
          a.name : ''
        );
      String nameB = b is SportSchedule ?
        b.name : (b is CultureSchedule ?
          b.name : ''
        );

      int startTimeA = getStartTime(nameA);
      int startTimeB = getStartTime(nameB);
      return startTimeA.compareTo(startTimeB);
    });
    return schedules;
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
                  FutureBuilder<List<SportSchedule>>(
                    future: sportSchedulesReceiver,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Loading();
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Erreur: ${snapshot.error}')
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('Aucun horaire trouvé')
                        );
                      }

                      final sportSchedules = snapshot.data!;
                      final sortedSchedules = sortSchedules(sportSchedules);

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
                            itemCount: sortedSchedules.length,
                            itemBuilder: (context, index) {
                              final schedule = sortedSchedules[index];
                              final isSelected = watchFilterProvider.selectedSportSchedules.any((selected) =>
                                selected.id == schedule.id);

                              return Semantics(
                                button: true,
                                selected: isSelected,
                                label: schedule.name,
                                hint: isSelected ?
                                  'Sélectionné, tapez pour désélectionner'
                                  : 'Non sélectionné, tapez pour sélectionner',
                                  child: Focus(
                                    child: FilterCard(
                                      name: schedule.name,
                                      imageUrl: schedule.imageUrl,
                                      isSelected: isSelected,
                                      fontSize: fontSize,
                                      onTap: () {
                                        final selectedSchedules = watchFilterProvider.selectedSportSchedules
                                          .map((schedule) => {
                                            'id': schedule.id!,
                                            'name': schedule.name,
                                          }).toList();

                                        if (isSelected) {
                                          selectedSchedules
                                            .removeWhere((selected) => selected['id'] == schedule.id);
                                        } else {
                                          if (schedule.id != null) {
                                            selectedSchedules.add({
                                              'id': schedule.id!,
                                              'name': schedule.name,
                                            });
                                          }
                                        }

                                        watchFilterProvider.setSelectedSchedules(
                                          selectedSection: 0,
                                          selectedSchedules: selectedSchedules,
                                        );
                                      },
                                    ),
                                  ),
                              );
                            },
                          ),
                          if (sportSchedules.isNotEmpty)
                            SizedBox(height: 8),
                          if (sportSchedules.isNotEmpty)
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
                                final selectedSchedules = readFilterProvider.selectedSportSchedules
                                  .map((schedule) => {
                                    'id': schedule.id!,
                                    'name': schedule.name
                                  }).toList();
                                context.pop(selectedSchedules);
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
                : FutureBuilder<List<CultureSchedule>>(
                  future: cultureSchedulesReceiver,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Loading();
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Erreur: ${snapshot.error}')
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('Aucun horaire trouvé')
                      );
                    }

                    final cultureSchedules = snapshot.data!;
                    final sortedSchedules = sortSchedules(cultureSchedules);

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
                          itemCount: sortedSchedules.length,
                          itemBuilder: (context, index) {
                            final schedule = sortedSchedules[index];
                            final isSelected = watchFilterProvider.selectedCultureSchedules.any((selected) =>
                              selected.id == schedule.id);

                            return Semantics(
                              button: true,
                              selected: isSelected,
                              label: schedule.name,
                              hint: isSelected ?
                                'Sélectionné, tapez pour désélectionnner'
                                : 'Non sélectionné, tapez pour sélectionner',
                                child: Focus(
                                  child: FilterCard(
                                    name: schedule.name,
                                    imageUrl: schedule.imageUrl,
                                    isSelected: isSelected,
                                    fontSize: fontSize,
                                    onTap: () {
                                      final selectedSchedules = watchFilterProvider.selectedCultureSchedules
                                        .map((schedule) => {
                                          'id': schedule.id!,
                                          'name': schedule.name,
                                        }).toList();

                                      if (isSelected) {
                                        selectedSchedules
                                          .removeWhere((selected) => selected['id'] == schedule.id);
                                      } else {
                                        if (schedule.id != null) {
                                          selectedSchedules.add({
                                            'id': schedule.id!,
                                            'name': schedule.name,
                                          });
                                        }
                                      }
                                      
                                      watchFilterProvider.setSelectedSchedules(
                                        selectedSection: 1,
                                        selectedSchedules: selectedSchedules,
                                      );
                                    },
                                  ),
                                )
                            );
                          },
                        ),
                        if (cultureSchedules.isNotEmpty)
                          SizedBox(height: 8),
                        if (cultureSchedules.isNotEmpty)
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
                              final selectedSchedules = readFilterProvider.selectedCultureSchedules
                                .map((schedule) => {
                                  'id': schedule.id!,
                                  'name': schedule.name,
                                }).toList();
                              context.pop(selectedSchedules);
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