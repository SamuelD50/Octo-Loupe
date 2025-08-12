import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// Components
import 'package:octoloupe/components/snackbar.dart';
// Models
import 'package:octoloupe/model/sport_filters_model.dart';
import 'package:octoloupe/model/culture_filters_model.dart';
import 'package:octoloupe/providers/activities_provider.dart';
import 'package:octoloupe/providers/filter_provider.dart';
// Services
import 'package:octoloupe/services/culture_activity_service.dart';
import 'package:octoloupe/services/sport_activity_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final int _selectedSection = 0;
  bool isLoading = false;

  List<SportCategory> selectedSportCategories = [];
  List<SportAge> selectedSportAges = [];
  List<SportDay> selectedSportDays = [];
  List<SportSchedule> selectedSportSchedules = [];
  List<SportSector> selectedSportSectors = [];

  List<CultureCategory> selectedCultureCategories = [];
  List<CultureAge> selectedCultureAges = [];
  List<CultureDay> selectedCultureDays = [];
  List<CultureSchedule> selectedCultureSchedules = [];
  List<CultureSector> selectedCultureSectors = []; 

  //List of all activities
  List<Map<String, dynamic>> activities = [];

  final keywordsController = TextEditingController();

  List<Map<String, dynamic>> filteredActivities = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(
    BuildContext context
  ) {
    final readFilterProvider = context.read<FilterProvider>();
    final watchFilterProvider = context.watch<FilterProvider>();

    final readActivitiesProvider = context.read<ActivitiesProvider>();
    final watchActivitiesProvider = context.watch<ActivitiesProvider>();
    
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
                  padding: EdgeInsets.only(top: 32),
                  child: Text(
                    'Je trouve mon activité',
                    style: TextStyle(
                      fontFamily: 'Satisfy-Regular',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 32),
                // Barre de recherche
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: keywordsController,
                          decoration: InputDecoration(
                            labelText: 'Je recherche ...',
                            hintText: 'Ex: Running, Peinture, ...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF5B59B4),
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Color(0xFF5B59B4)
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        onPressed: () async {
                          filteredActivities.clear();
                          String searchQuery = keywordsController.text.trim();
                          debugPrint('searchQuery: $searchQuery');

                          if (searchQuery.isNotEmpty) {
                            await readActivitiesProvider.readAllActivities();
                            final activities = readActivitiesProvider.activities;

                            List<String> keywords = searchQuery.split(' ').map((e) => e.trim()).toList();

                            List<Map<String, dynamic>> filteredActivities = await readActivitiesProvider.sortActivities(
                              keywords: keywords,
                              activities: activities,
                            );

                            if (filteredActivities.isNotEmpty) {
                              if (context.mounted) {
                                context.push(
                                  '/home/results',
                                  extra: {
                                    'filteredActivities': filteredActivities,
                                  }
                                );
                              }
                            } else {
                              CustomSnackBar(
                                message: 'Aucune activité trouvée !',
                                backgroundColor: Colors.red,
                              ).showSnackBar(context);
                            }
                          }
                          keywordsController.clear();
                          filteredActivities.clear();
                        },
                        child: Icon(
                          Icons.search,
                          size: 24,
                        )
                      )
                    ],
                  )
                ),
                SizedBox(height: 16),
                //Sport or Culture section
                LayoutBuilder(
                  builder: (context, constraints) {
                    final selectedSection = watchFilterProvider.selectedSection;

                    EdgeInsetsGeometry padding;

                    if (constraints.maxWidth < 325) {
                      padding = EdgeInsets.symmetric(horizontal: 30.0, vertical: 1.0);
                    } else {
                      padding = EdgeInsets.symmetric(horizontal: 30.0, vertical: 1.0);
                    }

                    return ToggleButtons(
                      isSelected: [
                        selectedSection == 0,
                        selectedSection == 1,
                      ],
                      onPressed: (int section) async {
                        readFilterProvider.setSection(section);
                        readFilterProvider.resetFilters();
                        await readActivitiesProvider.readActivities(context);
                      },
                      color: Colors.black,
                      selectedColor: Colors.white,
                      fillColor: Color(0xFF5B59B4),
                      borderColor: Color(0xFF5B59B4),
                      selectedBorderColor: Color(0xFF5B59B4),
                      borderRadius: BorderRadius.circular(30.0),
                      direction: constraints.maxWidth < 325 ?
                        Axis.vertical
                        : Axis.horizontal,
                      children: [
                        Container(
                          padding: padding,
                          child: Center(
                            child: Text(
                              'Sport',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: padding,
                          child: Center(
                            child: Text(
                              'Culture',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                    //Filter button by categories
                      _buildCriteriaTile(
                        context,
                        Icons.category,
                        'Par catégorie',
                        () async {
                          final selectedSection = readFilterProvider.selectedSection;
                          final List<Map<String, String>>? selectedCategories = await context.push(
                            '/home/categories',
                            extra: {
                              'isSport': selectedSection == 0,
                              'selectedCategories': selectedSection == 0 ?
                                readFilterProvider.selectedSportCategories
                                  .map((category) => {
                                    'id': category.id ?? '',
                                    'name': category.name,
                                  }).toList()
                                : readFilterProvider.selectedCultureCategories
                                  .map((category) => {
                                    'id': category.id ?? '',
                                    'name': category.name,
                                  }).toList(),
                            }
                          );

                          readFilterProvider.setSelectedCategories(
                            selectedSection: selectedSection,
                            selectedCategories: selectedCategories,
                          );
                        },
                        isSport: _selectedSection == 0,
                      ),
                      //Filter button by ages
                      _buildCriteriaTile(
                        context,
                        Icons.accessibility_new,
                        'Par âge',
                        () async {
                          final selectedSection = readFilterProvider.selectedSection;
                          final List<Map<String, String>>? selectedAges = await context.push(
                            '/home/ages',
                            extra: {
                              'isSport': selectedSection == 0,
                              'selectedAges': selectedSection == 0 ?
                                readFilterProvider.selectedSportAges
                                  .map((age) => {
                                    'id': age.id ?? '',
                                    'name': age.name,
                                  }).toList()
                                : readFilterProvider.selectedCultureAges
                                  .map((age) => {
                                    'id': age.id ?? '',
                                    'name': age.name,
                                  }).toList(),
                            }
                          );
                            
                          readFilterProvider.setSelectedAges(
                            selectedSection: selectedSection,
                            selectedAges: selectedAges,
                          );
                        },
                        isSport: _selectedSection == 0,
                      ),
                      //Filter button by days
                      _buildCriteriaTile(
                        context,
                        Icons.date_range,
                        'Par jour',
                        () async {
                          final selectedSection = readFilterProvider.selectedSection;
                          final List<Map<String, String>>? selectedDays = await context.push(
                            '/home/days',
                            extra: {
                              'isSport': selectedSection == 0,
                              'selectedDays': selectedSection == 0 ?
                                readFilterProvider.selectedSportDays
                                  .map((day) => {
                                    'id': day.id ?? '',
                                    'name': day.name,
                                  }).toList()
                                : readFilterProvider.selectedCultureDays
                                  .map((day) => {
                                    'id': day.id ?? '',
                                    'name': day.name,
                                  }).toList(),
                            }
                          );

                          readFilterProvider.setSelectedDays(
                            selectedSection: selectedSection,
                            selectedDays: selectedDays,
                          );
                        },
                        isSport: _selectedSection == 0,
                      ),
                      //Filter button by schedules
                      _buildCriteriaTile(
                        context,
                        Icons.access_time,
                        'Par horaire',
                        () async {
                          final selectedSection = readFilterProvider.selectedSection;
                          final List<Map<String, String>>? selectedSchedules = await context.push(
                            '/home/schedules',
                            extra: {
                              'isSport': selectedSection == 0,
                              'selectedSchedules': selectedSection == 0 ?
                                readFilterProvider.selectedSportSchedules
                                  .map((schedule) => {
                                    'id': schedule.id ?? '',
                                    'name': schedule.name,
                                  }).toList()
                                : readFilterProvider.selectedCultureSchedules
                                  .map((schedule) => {
                                    'id': schedule.id ?? '',
                                    'name': schedule.name,
                                  }).toList(),
                            }
                          );

                          readFilterProvider.setSelectedSchedules(
                            selectedSection: selectedSection,
                            selectedSchedules: selectedSchedules,
                          );
                        },
                        isSport: _selectedSection == 0,
                      ),
                      //Filter button by sectors
                      _buildCriteriaTile(
                        context,
                        Icons.apartment_rounded,
                        'Par secteur',
                        () async {
                          final selectedSection = readFilterProvider.selectedSection;
                          final List<Map<String, String>>? selectedSectors = await context.push(
                            '/home/sectors',
                            extra: {
                              'isSport': selectedSection == 0,
                              'selectedSectors': selectedSection == 0 ?
                                readFilterProvider.selectedSportSectors
                                  .map((sector) => {
                                    'id': sector.id ?? '',
                                    'name': sector.name,
                                  }).toList()
                                : readFilterProvider.selectedCultureSectors
                                  .map((sector) => {
                                    'id': sector.id ?? '',
                                    'name': sector.name,
                                  }).toList(),
                            }
                          );
                            
                          readFilterProvider.setSelectedSectors(
                            selectedSection: selectedSection,
                            selectedSectors: selectedSectors,
                          );
                        },
                        isSport: _selectedSection == 0,
                      ),
                    ],
                  ),
                ),
                //Buttons to search for activities or reset filters (Row/Column)
                LayoutBuilder(
                  builder: (context, constraints) {
                    return constraints.maxWidth > 325 ?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                            onPressed: () async {
                              final filters = readFilterProvider.collectFilters();
                              await readActivitiesProvider.readActivities(context);
                              final activities = readActivitiesProvider.activities;
                              
                              final filteredActivities = await readActivitiesProvider.sortActivities(
                                filters: filters,
                                activities: activities,
                              );

                              if (filteredActivities.isNotEmpty) {
                                readActivitiesProvider.setFilteredActivities(filteredActivities);
                                readActivitiesProvider.clearSelectedActivity();

                                if (context.mounted) {
                                  context.push(
                                    '/home/results',
                                  );
                                }
                              } else {
                                CustomSnackBar(
                                  message: 'Aucune activité trouvée !',
                                  backgroundColor: Colors.red,
                                ).showSnackBar(context);
                              }

                              readFilterProvider.resetFilters();
                              filters.clear();
                            },
                            child: Text('Rechercher',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 32),
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
                              readFilterProvider.resetFilters();

                              CustomSnackBar(
                                message: 'Filtres réinitialisés !',
                                backgroundColor: Colors.amber,
                              ).showSnackBar(context);
                            },
                            child: Text('Réinitialiser',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ) :
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                            onPressed: () async {
                              final filters = readFilterProvider.collectFilters();
                              await readActivitiesProvider.readActivities(context);
                              final activities = readActivitiesProvider.activities;
                              
                              final filteredActivities = await readActivitiesProvider.sortActivities(
                                filters: filters,
                                activities: activities,
                              );

                              if (filteredActivities.isNotEmpty) {
                                readActivitiesProvider.setFilteredActivities(filteredActivities);
                                readActivitiesProvider.clearSelectedActivity();

                                if (context.mounted) {
                                  context.push(
                                    '/home/results',
                                  );
                                }
                              } else {
                                CustomSnackBar(
                                  message: 'Aucune activité trouvée !',
                                  backgroundColor: Colors.red,
                                ).showSnackBar(context);
                              }

                              readFilterProvider.resetFilters();
                              filters.clear();
                            },
                            child: Text('Rechercher',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
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
                              readFilterProvider.resetFilters();
                              
                              CustomSnackBar(
                                message: 'Filtres réinitialisés !',
                                backgroundColor: Colors.amber,
                              ).showSnackBar(context);
                            },
                            child: Text('Réinitialiser',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
                  }
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  //Widget buttons to filters
  Widget _buildCriteriaTile(
    BuildContext context,
    IconData icon,
    String label,
    Future<void> Function() pageBuilder,
    {required bool isSport}
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: BorderSide(
                color: Color(0xFF5B59B4),
                width: 2,
              )
            ),
            padding: EdgeInsets.zero,
          ),
          onPressed: () {
            pageBuilder();
          },
          child: Row(
            children: [
              //Sport section organization
              if (isSport) ...[
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF5B59B4),
                  ),
                  child: Icon(
                    icon,
                    size: 24,
                    color: Colors.white
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ] else ...[
                //Culture section organization
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 15),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF5B59B4),
                  ),
                  child: Icon(
                    icon,
                    size: 24,
                    color: Colors.white
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}