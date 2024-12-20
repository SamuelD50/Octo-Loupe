import 'dart:developer';

import 'package:octoloupe/components/custom_app_bar.dart';
import 'package:octoloupe/components/snackbar.dart';
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
  int _selectedSection = 0;
  
  void _resetFilters() {
    setState(() {
      if (_selectedSection == 0) {
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
                        hintText: 'Je recherche ...',
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
                              final List<String>? categories = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CategorySelectionPage(
                                  selectedCategories: _selectedSection == 0 ? selectedCategoriesSport : selectedCategoriesCulture,
                                  isSport: _selectedSection == 0,
                                )),
                              );
                              if (categories != null) {
                                setState(() {
                                  if (_selectedSection == 0) {
                                    selectedCategoriesSport = categories;
                                  } else {
                                    selectedCategoriesCulture = categories;
                                  }
                                });
                              }
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
                              final List<String>? ages = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AgeSelectionPage(
                                  selectedAges: _selectedSection == 0 ? selectedAgesSport : selectedAgesCulture,
                                  isSport: _selectedSection == 0,
                                )),
                              );
                              if (ages != null) {
                                setState(() {
                                  if (_selectedSection == 0) {
                                    selectedAgesSport = ages;
                                  } else {
                                    selectedAgesCulture = ages;
                                  }
                                });
                              }
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
                              final List<String>? days = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => DaySelectionPage(
                                  selectedDays: _selectedSection == 0 ? selectedDaysSport : selectedDaysCulture,
                                  isSport: _selectedSection == 0,
                                )),
                              );
                              if (days != null) {
                                setState(() {
                                  if (_selectedSection == 0) {
                                    selectedDaysSport = days;
                                  } else {
                                    selectedDaysCulture = days;
                                  }
                                });
                              }
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
                              final List<String>? schedules = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ScheduleSelectionPage(
                                  selectedSchedules: _selectedSection == 0 ? selectedSchedulesSport : selectedSchedulesCulture,
                                  isSport: _selectedSection == 0,
                                )),
                              );
                              if (schedules != null) {
                                setState(() {
                                  if (_selectedSection == 0) {
                                    selectedSchedulesSport = schedules;
                                  } else {
                                    selectedSchedulesCulture = schedules;
                                  }
                                });
                              }
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
                              final List<String>? sectors = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SectorSelectionPage(
                                  selectedSectors: _selectedSection == 0 ? selectedSectorsSport : selectedSectorsCulture,
                                  isSport: _selectedSection == 0,
                                )),
                              );
                              if (sectors != null) {
                                setState(() {
                                  if (_selectedSection == 0) {
                                    selectedSectorsSport = sectors;
                                  } else {
                                    selectedSectorsCulture = sectors;
                                  }
                                });
                              }
                            },
                            isSport: _selectedSection == 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_selectedSection == 0 && selectedCategoriesSport.isNotEmpty) ...[
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
                  if (_selectedSection == 1 && selectedCategoriesCulture.isNotEmpty) ...[
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
                  if (_selectedSection == 0 && selectedAgesSport.isNotEmpty) ...[
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
                  if (_selectedSection == 1 && selectedAgesCulture.isNotEmpty) ...[
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
                  if (_selectedSection == 0 && selectedDaysSport.isNotEmpty) ...[
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
                  if (_selectedSection == 1 && selectedDaysCulture.isNotEmpty) ...[
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
                  if (_selectedSection == 0 && selectedSchedulesSport.isNotEmpty) ...[
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
                  if (_selectedSection == 1 && selectedSchedulesCulture.isNotEmpty) ...[
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
                  if (_selectedSection == 0 && selectedSectorsSport.isNotEmpty) ...[
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
                  if (_selectedSection == 1 && selectedSectorsCulture.isNotEmpty) ...[
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
                              onPressed: () {
                                debugPrint("Bouton rechercher");
                                log('Rechercher');
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
                                /* CustomSnackBar(
                                  message: 'Filtres réinitialisés !',
                                  backgroundColor: Colors.amber,
                                ).showSnackBar(context); */
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
                                log('Rechercher', level: 0);
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
                                /* CustomSnackBar(
                                  message: 'Filtres réinitialisés !',
                                  backgroundColor: Colors.amber,
                                ).showSnackBar(context); */
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
                padding: EdgeInsets.all(10),
                child: Icon(icon, color: Colors.white),
              ),
              SizedBox(width: 15),
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
              SizedBox(width: 15),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF5B59B4),
                ),
                padding: const EdgeInsets.all(10),
                child: Icon(icon, color: Colors.white),
              ),
            ],
          ],
        ),
      ),
    );
  }
}