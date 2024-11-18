import 'package:octoloupe/components/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'category_selection_page.dart';
import 'age_selection_page.dart';
import 'day_selection_page.dart';
import 'schedule_selection_page.dart';
import 'sector_selection_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  
  void _resetFilters() {
    setState(() {
      if (_selectedIndex == 0) {
      selectedCategoriesSport = [];
      selectedAgesSport = [];
      selectedDaysSport = [];
      selectedSchedulesSport = [];
      selectedSectorsSport = [];
      } else {
        selectedCategoriesCulture = [];
        selectedAgesCulture = [];
        selectedDaysCulture = [];
        selectedSchedulesCulture = [];
        selectedSectorsCulture = [];
      }
    });
  }

 List <String> selectedCategoriesSport = [];
 List <String> selectedAgesSport = [];
 List <String> selectedDaysSport = [];
 List <String> selectedSchedulesSport = [];
 List <String> selectedSectorsSport = [];

 List <String> selectedCategoriesCulture = [];
 List <String> selectedAgesCulture = [];
 List <String> selectedDaysCulture = [];
 List <String> selectedSchedulesCulture = [];
 List <String> selectedSectorsCulture = []; 

  @override
  Widget build(BuildContext context) {
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
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Je trouve mon activité',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // Barre de recherche
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Je recherche ...',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.search),
                      ),
                      onSubmitted: (value) {
                        debugPrint(value);
                      },
                    ),
                  ),
                  ToggleButtons(
                    isSelected: [_selectedIndex == 0, _selectedIndex == 1],
                    onPressed: (int index) {
                      setState(() {
                        _selectedIndex = index;
                        _resetFilters();
                      });
                    },
                    color: Colors.black,
                    selectedColor: Colors.white,
                    fillColor: Color(0xFF5B59B4),
                    borderColor: Color(0xFF5B59B4),
                    selectedBorderColor: Color(0xFF5B59B4),
                    borderRadius: BorderRadius.circular(20.0),
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 1.0),
                        child: Center(child: Text('Sport')),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 1.0),
                        child: Center(child: Text('Culture')),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildCriteriaTile(
                          context,
                          Icons.category,
                          'Par catégorie',
                          () async {
                            final List<String>? categories = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CategorySelectionPage(
                                selectedCategories: _selectedIndex == 0 ? selectedCategoriesSport : selectedCategoriesCulture,
                                isSport: _selectedIndex == 0,
                              )),
                            );
                            if (categories != null) {
                              setState(() {
                                if (_selectedIndex == 0) {
                                  selectedCategoriesSport = categories;
                                } else {
                                  selectedCategoriesCulture = categories;
                                }
                              });
                            }
                          },
                          isSport: _selectedIndex == 0,
                        ),
                        _buildCriteriaTile(
                          context,
                          Icons.accessibility_new,
                          'Par âge',
                          () async {
                            final List<String>? ages = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AgeSelectionPage(
                                selectedAges: _selectedIndex == 0 ? selectedAgesSport : selectedAgesCulture,
                                isSport: _selectedIndex == 0,
                              )),
                            );
                            if (ages != null) {
                              setState(() {
                                if (_selectedIndex == 0) {
                                  selectedAgesSport = ages;
                                } else {
                                  selectedAgesCulture = ages;
                                }
                              });
                            }
                          },
                          isSport: _selectedIndex == 0,
                        ),
                        _buildCriteriaTile(
                          context,
                          Icons.date_range,
                          'Par jour',
                          () async {
                            final List<String>? days = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DaySelectionPage(
                                selectedDays: _selectedIndex == 0 ? selectedDaysSport : selectedDaysCulture,
                                isSport: _selectedIndex == 0,
                              )),
                            );
                            if (days != null) {
                              setState(() {
                                if (_selectedIndex == 0) {
                                  selectedDaysSport = days;
                                } else {
                                  selectedDaysCulture = days;
                                }
                              });
                            }
                          },
                          isSport: _selectedIndex == 0,
                        ),
                        _buildCriteriaTile(
                          context,
                          Icons.access_time,
                          'Par horaire',
                          () async {
                            final List<String>? schedules = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ScheduleSelectionPage(
                                selectedSchedules: _selectedIndex == 0 ? selectedSchedulesSport : selectedSchedulesCulture,
                                isSport: _selectedIndex == 0,
                              )),
                            );
                            if (schedules != null) {
                              setState(() {
                                if (_selectedIndex == 0) {
                                  selectedSchedulesSport = schedules;
                                } else {
                                  selectedSchedulesCulture = schedules;
                                }
                              });
                            }
                          },
                          isSport: _selectedIndex == 0,
                        ),
                        _buildCriteriaTile(
                          context,
                          Icons.apartment_rounded,
                          'Par secteur',
                          () async {
                            final List<String>? sectors = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SectorSelectionPage(
                                selectedSectors: _selectedIndex == 0 ? selectedSectorsSport : selectedSectorsCulture,
                                isSport: _selectedIndex == 0,
                              )),
                            );
                            if (sectors != null) {
                              setState(() {
                                if (_selectedIndex == 0) {
                                  selectedSectorsSport = sectors;
                                } else {
                                  selectedSectorsCulture = sectors;
                                }
                              });
                            }
                          },
                          isSport: _selectedIndex == 0,
                        ),
                      ],
                    ),
                  ),
                  if (_selectedIndex == 0 && selectedCategoriesSport.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 8.0,
                        children: selectedCategoriesSport.map((category) {
                          return Chip(
                            label: Text(category),
                            onDeleted: () {
                              setState(() {
                                selectedCategoriesSport.remove(category);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                  if (_selectedIndex == 1 && selectedCategoriesCulture.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 8.0,
                        children: selectedCategoriesCulture.map((category) {
                          return Chip(
                            label: Text(category),
                            onDeleted: () {
                              setState(() {
                                selectedCategoriesCulture.remove(category);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                  if (_selectedIndex == 0 && selectedAgesSport.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 8.0,
                        children: selectedAgesSport.map((category) {
                          return Chip(
                            label: Text(category),
                            onDeleted: () {
                              setState(() {
                                selectedAgesSport.remove(category);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                  if (_selectedIndex == 1 && selectedAgesCulture.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 8.0,
                        children: selectedAgesCulture.map((category) {
                          return Chip(
                            label: Text(category),
                            onDeleted: () {
                              setState(() {
                                selectedAgesCulture.remove(category);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                  if (_selectedIndex == 0 && selectedDaysSport.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 8.0,
                        children: selectedDaysSport.map((category) {
                          return Chip(
                            label: Text(category),
                            onDeleted: () {
                              setState(() {
                                selectedDaysSport.remove(category);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                  if (_selectedIndex == 1 && selectedDaysCulture.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 8.0,
                        children: selectedDaysCulture.map((category) {
                          return Chip(
                            label: Text(category),
                            onDeleted: () {
                              setState(() {
                                selectedDaysCulture.remove(category);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                  if (_selectedIndex == 0 && selectedSchedulesSport.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 8.0,
                        children: selectedSchedulesSport.map((category) {
                          return Chip(
                            label: Text(category),
                            onDeleted: () {
                              setState(() {
                                selectedSchedulesSport.remove(category);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                  if (_selectedIndex == 1 && selectedSchedulesCulture.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 8.0,
                        children: selectedSchedulesCulture.map((category) {
                          return Chip(
                            label: Text(category),
                            onDeleted: () {
                              setState(() {
                                selectedSchedulesCulture.remove(category);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                  if (_selectedIndex == 0 && selectedSectorsSport.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 8.0,
                        children: selectedSectorsSport.map((category) {
                          return Chip(
                            label: Text(category),
                            onDeleted: () {
                              setState(() {
                                selectedSectorsSport.remove(category);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                  if (_selectedIndex == 1 && selectedSectorsCulture.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 8.0,
                        children: selectedSectorsCulture.map((category) {
                          return Chip(
                            label: Text(category),
                            onDeleted: () {
                              setState(() {
                                selectedSectorsCulture.remove(category);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: ElevatedButton(
                          onPressed: () {
                            debugPrint("Bouton rechercher");
                            /* _resetFilters(); */
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            textStyle: TextStyle(fontSize: 18),
                          ),
                          child: Text('Rechercher'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: ElevatedButton(
                          onPressed: () {
                            _resetFilters();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            textStyle: TextStyle(fontSize: 18),
                          ),
                          child: Text('Réinitialiser'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCriteriaTile(BuildContext context, IconData icon, String label, Future<void> Function() pageBuilder, {required bool isSport}) {
    return GestureDetector(
      onTap: pageBuilder,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: isSport ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            if (isSport) ...[
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF5B59B4),
                ),
                padding: EdgeInsets.all(8),
                child: Icon(icon, color: Colors.white),
              ),
              SizedBox(width: 20),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                  textAlign: TextAlign.left,
                ), 
              ),
            ] else ... [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                  textAlign: TextAlign.right,
                ),
              ),
              SizedBox(width: 20),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF5B59B4),
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(icon, color: Colors.white),
              ),
            ],
          ],
        ),
      ),
    );
  }
}