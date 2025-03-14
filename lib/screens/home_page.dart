import 'package:flutter/material.dart';
// Components
import 'package:octoloupe/components/custom_app_bar.dart';
import 'package:octoloupe/components/snackbar.dart';
// Models
import 'package:octoloupe/model/sport_filters_model.dart';
import 'package:octoloupe/model/culture_filters_model.dart';
// Services
import 'package:octoloupe/services/culture_activity_service.dart';
import 'package:octoloupe/services/sport_activity_service.dart';
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

  List<Map<String, dynamic>> activities = [];
  SportActivityService sportActivityService = SportActivityService();
  CultureActivityService cultureActivityService = CultureActivityService();
  bool isLoading = false;

  Future<void> readActivities() async {
    try {
      setState(() {
        isLoading = true;
      });

      if (_selectedSection == 0) {
        activities = (await sportActivityService.getSportActivities())
          .map((item) => (item).toMap())
          .toList();
      } else {
        activities = (await cultureActivityService.getCultureActivities())
          .map((item) => (item).toMap())
          .toList();
      }

      await Future.delayed(Duration(milliseconds: 25));

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching activity: $e');
    }
  }

  List<Map<String, dynamic>> filteredActivities = [];

  Future<List<Map<String, dynamic>>> sortActivities(
    Map<String, List<Map<String, String>>> filters,
    List<Map<String, dynamic>> activities,
  ) async {
    List<Map<String, String>> categories = [];
    List<Map<String, String>> ages = [];
    List<Map<String, String>> days = [];
    List<Map<String, String>> schedules = [];
    List<Map<String, String>> sectors = [];

    if (filters.containsKey('categories')) {
      debugPrint('categories');
      categories = filters['categories']!.map((category) {
        return {
          'id': category['id']!,
          'name': category['name']!,
        };
      }).toList();
    }
    
    if (filters.containsKey('ages')) {
      debugPrint('ages');
      ages = filters['ages']!.map((age) {
        return {
          'id': age['id']!,
          'name': age['name']!,
        };
      }).toList();
    }

    if (filters.containsKey('days')) {
      debugPrint('days');
      days = filters['days']!.map((day) {
        return {
          'id': day['id']!,
          'name': day['name']!,
        };
      }).toList();
    }

    if (filters.containsKey('schedules')) {
      debugPrint('schedules');
      schedules = filters['schedules']!.map((schedule) {
        return {
          'id': schedule['id']!,
          'name': schedule['name']!,
        };
      }).toList();
    }

    if (filters.containsKey('sectors')) {
      debugPrint('sectors');
      sectors = filters['sectors']!.map((sector) {
        return {
          'id': sector['id']!,
          'name': sector['name']!,
        };
      }).toList();
    }

    List<Map<String, dynamic>> filteredActivities = [];

    for (var activity in activities) {
      List<Map<String, dynamic>> categoriesId = (activity['filters']?['categoriesId'] as List?)
        ?.map((categoryId) {
          return {
            'id': categoryId['id'] ?? '',
            'name': categoryId['name'] ?? '',
          };
        }).toList() ?? [];

      List<Map<String, dynamic>> agesId = (activity['filters']?['agesId'] as List?)
        ?.map((ageId) {
          return {
            'id': ageId['id'] ?? '',
            'name': ageId['name'] ?? '',
          };
        }).toList() ?? [];

      List<Map<String, dynamic>> daysId = (activity['filters']?['daysId'] as List?)
        ?.map((dayId) {
          return {
            'id': dayId['id'] ?? '',
            'name': dayId['name'] ?? '',
          };
        }).toList() ?? [];

      List<Map<String, dynamic>> schedulesId = (activity['filters']?['schedulesId'] as List?)
        ?.map((scheduleId) {
          return {
            'id': scheduleId['id'] ?? '',
            'name': scheduleId['name'] ?? '',
          };
        }).toList() ?? [];

      List<Map<String, dynamic>> sectorsId = (activity['filters']?['sectorsId'] as List?)
        ?.map((sectorId) {
          return {
            'id': sectorId['id'] ?? '',
            'name': sectorId['name'] ?? '',
          };
        }).toList() ?? [];

      /* bool matchesCategory = categoriesId.any((categoryId) {
        return categories.any((category) {
          return category['id']!.compareTo(categoryId['id']) == 0;
        });
      });

      bool matchesAge = agesId.any((ageId) {
        return ages.any((age) {
          return age['id']!.compareTo(ageId['id']) == 0;
        });
      });

      bool matchesDay = daysId.any((dayId) {
        return days.any((day) {
          return day['id']!.compareTo(dayId['id']) == 0;
        });
      });

      bool matchesSchedule = schedulesId.any((scheduleId) {
        return schedules.any((schedule) {
          return schedule['id']!.compareTo(scheduleId['id']) == 0;
        });
      });

      bool matchesSector = sectorsId.any((sectorId) {
        return sectors.any((sector) {
          return sector['id']!.compareTo(sectorId['id']) == 0;
        });
      });

      if (matchesCategory || matchesAge || matchesDay || matchesSchedule || matchesSector) {
        filteredActivities.add(activity);
      } */

       bool matchesCategory = categories.isEmpty || categories.every((category) {
            return categoriesId.any((categoryId) {
                return category['id'] == categoryId['id'];
            });
        });

        bool matchesAge = ages.isEmpty || ages.every((age) {
            return agesId.any((ageId) {
                return age['id'] == ageId['id'];
            });
        });

        bool matchesDay = days.isEmpty || days.every((day) {
            return daysId.any((dayId) {
                return day['id'] == dayId['id'];
            });
        });

        bool matchesSchedule = schedules.isEmpty || schedules.every((schedule) {
            return schedulesId.any((scheduleId) {
                return schedule['id'] == scheduleId['id'];
            });
        });

        bool matchesSector = sectors.isEmpty || sectors.every((sector) {
            return sectorsId.any((sectorId) {
                return sector['id'] == sectorId['id'];
            });
        });

        // Si l'activité correspond à **tous les critères sélectionnés**, même si certains sont vides
        if (matchesCategory && matchesAge && matchesDay && matchesSchedule && matchesSector) {
            filteredActivities.add(activity);
        }
    }
    
    return filteredActivities;
  }

  @override
  void initState() {
    super.initState();
    readActivities();
  }

  @override
  Widget build(
    BuildContext context
  ) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          TextButton(
            onPressed: () {
              debugPrint('Pressed');
              throw Exception();
            },
            child: const Text("Throw Exception from Emulator"),
          ),
          Container(
            decoration: BoxDecoration(
              /* color: Colors.white24, */
              image: DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1509849809433-36d5c609f0ee?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTJ8fGVjdW1lJTIwbWVyfGVufDB8fDB8fHww'),
                fit: BoxFit.cover,
                opacity: 0.5,
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
                        color: Colors.black,
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
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: [
                        _buildCriteriaTile(
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
                        _buildCriteriaTile(
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
                        _buildCriteriaTile(
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
                        _buildCriteriaTile(
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
                        _buildCriteriaTile(
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
                                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              onPressed: () async {
                                collectFilters();
                                debugPrint('Filters: ${filters.toString()}');
                                readActivities();
                                debugPrint('Activities: $activities');
                                
                                List<Map<String, dynamic>> filteredActivities = await sortActivities(filters, activities);

                                if (filteredActivities.isNotEmpty) {
                                  setState(() {
                                    this.filteredActivities = filteredActivities;
                                  });

                                  debugPrint('FilteredActivities: ${filteredActivities.toString()}');
                                  
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ActivityPage(
                                        filteredActivities: filteredActivities,
                                      )
                                    )
                                  );
                                }
                              },
                              child: Text('Rechercher',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            SizedBox(width: 32),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF5B59B4),
                                foregroundColor: Colors.white,
                                side: BorderSide(color: Color(0xFF5B59B4)),
                                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
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
                              child: Text('Réinitialiser',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
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
                                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              onPressed: () async {
                                collectFilters();
                                debugPrint('Filters: ${filters.toString()}');
                                readActivities();
                                debugPrint('Activities: $activities');
                                
                                List<Map<String, dynamic>> filteredActivities = await sortActivities(filters, activities);

                                if (filteredActivities.isNotEmpty) {
                                  setState(() {
                                    this.filteredActivities = filteredActivities;
                                  });

                                  debugPrint('FilteredActivities: ${filteredActivities.toString()}');
                                  
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ActivityPage(
                                        filteredActivities: filteredActivities,
                                      )
                                    )
                                  );
                                }
                              },
                              child: Text('Rechercher',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF5B59B4),
                                foregroundColor: Colors.white,
                                side: BorderSide(color: Color(0xFF5B59B4)),
                                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
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
                              child: Text('Réinitialiser',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
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