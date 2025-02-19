import 'package:flutter/material.dart';
// Components
import 'package:octoloupe/components/custom_app_bar.dart';
import 'package:octoloupe/components/snackbar.dart';
// Models
import 'package:octoloupe/model/sport_filters_model.dart';
import 'package:octoloupe/model/culture_filters_model.dart';
import 'package:octoloupe/model/activity_model.dart';
// Pages
import 'package:octoloupe/screens/category_selection_page.dart';
import 'package:octoloupe/screens/age_selection_page.dart';
import 'package:octoloupe/screens/day_selection_page.dart';
import 'package:octoloupe/screens/schedule_selection_page.dart';
import 'package:octoloupe/screens/sector_selection_page.dart';
import 'package:octoloupe/screens/activity_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedSection = 0;
  
  void _resetFilters() {
    setState(() {
      if (_selectedSection == 0) {
        selectedSportCategories = [];
        selectedSportAges = [];
        selectedSportDays = [];
        selectedSportSchedules = [];
        selectedSportSectors = [];
      } else {
        selectedCultureCategories = [];
        selectedCultureAges = [];
        selectedCultureDays = [];
        selectedCultureSchedules = [];
        selectedCultureSectors = [];
      }
    });
  }

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

  Map<String, List<Map<String, String>>> filters = {};

  void collectFilters() {
    filters.clear();
    
    if (_selectedSection == 0) {
      if (selectedSportCategories.isNotEmpty) {
        filters['categories'] = selectedSportCategories.map((e) => {'id': e.id!, 'name': e.name}).toList();
      }
      if (selectedSportAges.isNotEmpty) {
        filters['ages'] = selectedSportAges.map((e) => {'id': e.id!, 'name': e.name}).toList();
      }
      if (selectedSportDays.isNotEmpty) {
        filters['days'] = selectedSportDays.map((e) => {'id': e.id!, 'name': e.name}).toList();
      }
      if (selectedSportSchedules.isNotEmpty) {
        filters['schedules'] = selectedSportSchedules.map((e) => {'id': e.id!, 'name': e.name}).toList();
      }
      if (selectedSportSectors.isNotEmpty) {
        filters['sectors'] = selectedSportSectors.map((e) => {'id': e.id!, 'name': e.name}).toList();
      }
    } else {
      if (selectedCultureCategories.isNotEmpty) {
        filters['categories'] = selectedCultureCategories.map((e) => {'id': e.id!, 'name': e.name}).toList();
      }
      if (selectedCultureAges.isNotEmpty) {
        filters['ages'] = selectedCultureAges.map((e) => {'id': e.id!, 'name': e.name}).toList();
      }
      if (selectedCultureDays.isNotEmpty) {
        filters['days'] = selectedCultureDays.map((e) => {'id': e.id!, 'name': e.name}).toList();
      }
      if (selectedCultureSchedules.isNotEmpty) {
        filters['schedules'] = selectedCultureSchedules.map((e) => {'id': e.id!, 'name': e.name}).toList();
      }
      if (selectedCultureSectors.isNotEmpty) {
        filters['sectors'] = selectedCultureSectors.map((e) => {'id': e.id!, 'name': e.name}).toList();
      }
    }
  }

  @override
  Widget build(
    BuildContext context
  ) {
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
                  Padding(
                    padding: EdgeInsets.only(top: 32),
                    child: Text(
                      'Je trouve mon activité',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 32),
                  // Barre de recherche
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Je recherche ...',
                        hintText: 'Ex: Running, Peinture, ...',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.search),
                      ),
                      onSubmitted: (value) {
                        debugPrint(value);
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      EdgeInsetsGeometry padding;

                      if (constraints.maxWidth < 325) {
                        padding = EdgeInsets.symmetric(horizontal: 30.0, vertical: 1.0);
                      } else {
                        padding = EdgeInsets.symmetric(horizontal: 40.0, vertical: 1.0);
                      }

                      return ToggleButtons(
                        isSelected: [_selectedSection == 0, _selectedSection == 1],
                        onPressed: (int section) {
                          setState(() {
                            _selectedSection = section;
                            _resetFilters();
                          });
                        },
                        color: Colors.black,
                        selectedColor: Colors.white,
                        fillColor: Color(0xFF5B59B4),
                        borderColor: Color(0xFF5B59B4),
                        selectedBorderColor: Color(0xFF5B59B4),
                        borderRadius: BorderRadius.circular(20.0),
                        direction: constraints.maxWidth < 325 ?
                          Axis.vertical
                          : Axis.horizontal,
                        children: [
                          Container(
                            padding: padding,
                            child: Center(child: Text('Sport')),
                          ),
                          Container(
                            padding: padding,
                            child: Center(child: Text('Culture')),
                          ),
                        ],
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: _buildCriteriaTile(
                            context,
                            Icons.category,
                            'Par catégorie',
                            () async {
                              final List<Map<String, String>> selectedCategories = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CategorySelectionPage(
                                    selectedCategories: _selectedSection == 0 ?
                                      selectedSportCategories.map((category) => {
                                        'id': category.id ?? '',
                                        'name': category.name,
                                      }).toList()
                                    : selectedCultureCategories.map((category) => {
                                      'id': category.id ?? '',
                                      'name': category.name,
                                    }).toList(),
                                    isSport: _selectedSection == 0,
                                  )
                                ),
                              );
                              setState(() {
                                if (_selectedSection == 0) {
                                  selectedSportCategories = selectedCategories.map((category) => SportCategory.fromMap(category)).toList();
                                } else {
                                  selectedCultureCategories = selectedCategories.map((category) => CultureCategory.fromMap(category)).toList();
                                }
                              });
                            },
                            isSport: _selectedSection == 0,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: _buildCriteriaTile(
                            context,
                            Icons.accessibility_new,
                            'Par âge',
                            () async {
                              final List<Map<String, String>> selectedAges = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AgeSelectionPage(
                                    selectedAges: _selectedSection == 0 ?
                                      selectedSportAges.map((age) => {
                                        'id': age.id ?? '',
                                        'name': age.name,
                                      }).toList()
                                    : selectedCultureAges.map((age) => {
                                        'id': age.id ?? '',
                                        'name': age.name,
                                      }).toList(),
                                    isSport: _selectedSection == 0,
                                  )
                                ),
                              );
                              setState(() {
                                if (_selectedSection == 0) {
                                  selectedSportAges = selectedAges.map((age) => SportAge.fromMap(age)).toList();
                                } else {
                                  selectedCultureAges = selectedAges.map((age) => CultureAge.fromMap(age)).toList();
                                }
                              });
                            },
                            isSport: _selectedSection == 0,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: _buildCriteriaTile(
                            context,
                            Icons.date_range,
                            'Par jour',
                            () async {
                              final List<Map<String, String>> selectedDays = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DaySelectionPage(
                                    selectedDays: _selectedSection == 0 ?
                                      selectedSportDays.map((day) => {
                                        'id': day.id ?? '',
                                        'name': day.name,
                                      }).toList()
                                    : selectedCultureDays.map((day) => {
                                        'id': day.id ?? '',
                                        'name': day.name,
                                      }).toList(),
                                  isSport: _selectedSection == 0,
                                  )
                                ),
                              );
                              setState(() {
                                if (_selectedSection == 0) {
                                  selectedSportDays = selectedDays.map((day) => SportDay.fromMap(day)).toList();
                                } else {
                                  selectedCultureDays = selectedDays.map((day) => CultureDay.fromMap(day)).toList();
                                }
                              });
                            },
                            isSport: _selectedSection == 0,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: _buildCriteriaTile(
                            context,
                            Icons.access_time,
                            'Par horaire',
                            () async {
                              final List<Map<String, String>> selectedSchedules = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ScheduleSelectionPage(
                                    selectedSchedules: _selectedSection == 0 ?
                                      selectedSportSchedules.map((schedule) => {
                                        'id': schedule.id ?? '',
                                        'name': schedule.name,
                                      }).toList()
                                    : selectedCultureSchedules.map((schedule) => {
                                        'id': schedule.id ?? '',
                                        'name': schedule.name,
                                      }).toList(),
                                    isSport: _selectedSection == 0,
                                  )
                                ),
                              );
                              setState(() {
                                if (_selectedSection == 0) {
                                  selectedSportSchedules = selectedSchedules.map((schedule) => SportSchedule.fromMap(schedule)).toList();
                                } else {
                                  selectedCultureSchedules = selectedSchedules.map((schedule) => CultureSchedule.fromMap(schedule)).toList();
                                }
                              });
                            },
                            isSport: _selectedSection == 0,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: _buildCriteriaTile(
                            context,
                            Icons.apartment_rounded,
                            'Par secteur',
                            () async {
                              final List<Map<String, String>> selectedSectors = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SectorSelectionPage(
                                    selectedSectors: _selectedSection == 0 ?
                                      selectedSportSectors.map((sector) => {
                                        'id': sector.id ?? '',
                                        'name': sector.name,
                                      }).toList()
                                    : selectedCultureSectors.map((sector) => {
                                        'id': sector.id ?? '',
                                        'name': sector.name,
                                      }).toList(),
                                    isSport: _selectedSection == 0,
                                  )
                                ),
                              );
                              setState(() {
                                if (_selectedSection == 0) {
                                  selectedSportSectors = selectedSectors.map((sector) => SportSector.fromMap(sector)).toList();
                                } else {
                                  selectedCultureSectors = selectedSectors.map((sector) => CultureSector.fromMap(sector)).toList();
                                }
                              });
                            },
                            isSport: _selectedSection == 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_selectedSection == 0 && selectedSportCategories.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 8.0,
                        children: selectedSportCategories.map((category) {
                          return Chip(
                            label: Text(category.name),
                            onDeleted: () {
                              setState(() {
                                selectedSportCategories.remove(category);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                  if (_selectedSection == 1 && selectedCultureCategories.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 8.0,
                        children: selectedCultureCategories.map((category) {
                          return Chip(
                            label: Text(category.name),
                            onDeleted: () {
                              setState(() {
                                selectedCultureCategories.remove(category);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                  if (_selectedSection == 0 && selectedSportAges.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 8.0,
                        children: selectedSportAges.map((age) {
                          return Chip(
                            label: Text(age.name),
                            onDeleted: () {
                              setState(() {
                                selectedSportAges.remove(age);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                  if (_selectedSection == 1 && selectedCultureAges.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 8.0,
                        children: selectedCultureAges.map((age) {
                          return Chip(
                            label: Text(age.name),
                            onDeleted: () {
                              setState(() {
                                selectedCultureAges.remove(age);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                  if (_selectedSection == 0 && selectedSportDays.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 8.0,
                        children: selectedSportDays.map((day) {
                          return Chip(
                            label: Text(day.name),
                            onDeleted: () {
                              setState(() {
                                selectedSportDays.remove(day);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                  if (_selectedSection == 1 && selectedCultureDays.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 8.0,
                        children: selectedCultureDays.map((day) {
                          return Chip(
                            label: Text(day.name),
                            onDeleted: () {
                              setState(() {
                                selectedCultureDays.remove(day);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                  if (_selectedSection == 0 && selectedSportSchedules.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 8.0,
                        children: selectedSportSchedules.map((schedule) {
                          return Chip(
                            label: Text(schedule.name),
                            onDeleted: () {
                              setState(() {
                                selectedSportSchedules.remove(schedule);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                  if (_selectedSection == 1 && selectedCultureSchedules.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 8.0,
                        children: selectedCultureSchedules.map((schedule) {
                          return Chip(
                            label: Text(schedule.name),
                            onDeleted: () {
                              setState(() {
                                selectedCultureSchedules.remove(schedule);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                  if (_selectedSection == 0 && selectedSportSectors.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 8.0,
                        children: selectedSportSectors.map((sector) {
                          return Chip(
                            label: Text(sector.name),
                            onDeleted: () {
                              setState(() {
                                selectedSportSectors.remove(sector);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                  if (_selectedSection == 1 && selectedCultureSectors.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 8.0,
                        children: selectedCultureSectors.map((sector) {
                          return Chip(
                            label: Text(sector.name),
                            onDeleted: () {
                              setState(() {
                                selectedCultureSectors.remove(sector);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
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
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              onPressed: () async {
                                collectFilters();
                                debugPrint(filters.toString());

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ActivityPage(
                                      filters: filters,
                                    )
                                  )
                                );
                              },
                              child: Text('Rechercher'),
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
                                _resetFilters();
                                CustomSnackBar(
                                  message: 'Filtres réinitialisés !',
                                  backgroundColor: Colors.amber,
                                ).showSnackBar(context);
                              },
                              child: Text('Réinitialiser'),
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
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              onPressed: () {
                                debugPrint("Bouton rechercher");
                              },
                              child: Text('Rechercher'),
                            ),
                            SizedBox(width: 16),
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
                                _resetFilters();
                                CustomSnackBar(
                                  message: 'Filtres réinitialisés !',
                                  backgroundColor: Colors.amber,
                                ).showSnackBar(context);
                              },
                              child: Text('Réinitialiser'),
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
      ),
    );
  }

  Widget _buildCriteriaTile(
    BuildContext context,
    IconData icon,
    String label,
    Future<void> Function() pageBuilder,
    {required bool isSport}
  ) {
    return GestureDetector(
      onTap: pageBuilder,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: isSport ?
            MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            if (isSport) ...[
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF5B59B4),
                ),
                padding: EdgeInsets.all(10),
                child: Icon(
                  icon,
                  color: Colors.white
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18
                  ),
                  textAlign: TextAlign.left,
                ), 
              ),
            ] else ... [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              SizedBox(width: 15),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF5B59B4),
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(
                  icon,
                  color: Colors.white
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}