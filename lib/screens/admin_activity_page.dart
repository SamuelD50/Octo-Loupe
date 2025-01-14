import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:octoloupe/components/custom_app_bar.dart';
import 'package:octoloupe/components/snackbar.dart';
import 'package:octoloupe/screens/admin_interface_page.dart';
import 'package:octoloupe/services/culture_filter_service.dart';
import 'package:octoloupe/services/sport_filter_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:octoloupe/CRUD/activities_crud.dart';
import 'package:octoloupe/model/activity_model.dart';

class AdminActivityPage extends StatefulWidget {
  const AdminActivityPage({super.key});

  @override
  AdminActivityPageState createState() => AdminActivityPageState();
}

enum ActivityMode { adding, editing, deleting }

class AdminActivityPageState extends State<AdminActivityPage> {
  ActivityMode _currentMode = ActivityMode.adding;
  final _addActivityKey = GlobalKey<FormState>();
  final _editActivityKey = GlobalKey<FormState>();
  final _deleteActivityKey = GlobalKey<FormState>();
  int selectedSection = 0;
  String selectedFilter = '';
  List<dynamic> subFilters = [];
  List<dynamic> selectedSubFilters = [];
  List<Map<String, String>> selectedSubFiltersByCategories = [];
  List<Map<String, String>> selectedSubFiltersByAges = [];
  List<Map<String, String>> selectedSubFiltersByDays = [];
  List<Map<String, String>> selectedSubFiltersBySchedules = [];
  List<Map<String, String>> selectedSubFiltersBySectors = [];
  bool isLoading = false;
  bool isAdding = false;
  bool isEditing = false;
  bool isDeleting = false;

  TextEditingController disciplineController = TextEditingController();
  TextEditingController startHourController = TextEditingController();
  TextEditingController endHourController = TextEditingController();

  Future<void> createNewActivity({required BuildContext context}) async {
    String discipline = disciplineController.text.trim();
    String startHour = startHourController.text.trim();
    String endHour = endHourController.text.trim();

    try {
      setState(() {
        isLoading = true;
      });

      await ActivitiesCRUD.createActivity(
        discipline: discipline,
        categories: selectedSubFiltersByCategories,
        ages: selectedSubFiltersByAges,
        days: selectedSubFiltersByDays,
        schedules: selectedSubFiltersBySchedules,
        sectors: selectedSubFiltersBySectors,
      );

      setState(() {
        isLoading = false;
      });

      if (context.mounted) {
        CustomSnackBar(
          message: 'Activité créée',
          backgroundColor: Colors.green,
        ).showSnackBar(context);
      }
    } catch (e) {
      debugPrint('Error creating activity: $e');

      setState(() {
        isLoading = false;
      });

      if (context.mounted) {
        CustomSnackBar(
          message: 'Echec de la création de l\'activité',
          backgroundColor: Colors.red,
        ).showSnackBar(context);
      }
    }
  }

  Future<void> readActivities() async {
    try {
      setState(() {
        isLoading = true;
      });

      await ActivitiesCRUD.getActivities(
        
      );

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching activity: $e');

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateActivity({required BuildContext context}) async {
    String discipline = disciplineController.text.trim();

    try {
      setState(() {
        isLoading = true;
      });

      await ActivitiesCRUD.updateActivity(
        discipline: discipline,
        categories: selectedSubFiltersByCategories,
        ages: selectedSubFiltersByAges,
        days: selectedSubFiltersByDays,
        schedules: selectedSubFiltersBySchedules,
        sectors: selectedSubFiltersBySectors,
      );

      setState(() {
        isLoading = false;
      });

      if (context.mounted) {
        CustomSnackBar(
          message: 'Activité modifiée',
          backgroundColor: Colors.green,
        ).showSnackBar(context);
      }
    } catch (e) {
      debugPrint('Error updating activity: $e');

      setState(() {
        isLoading = false;
      });

      if (context.mounted) {
        CustomSnackBar(
          message: 'Echec de la modification de l\'activité',
          backgroundColor: Colors.red,
        ).showSnackBar(context);
      }
    }
  }

  Future<void> deleteActivity({required BuildContext context}) async {
    try {
      setState(() {
        isLoading = true;
      });

      await ActivitiesCRUD.deleteActivity();

      setState(() {
        isLoading = false;
      });

      if (context.mounted) {
        CustomSnackBar(
          message: 'Activité supprimée',
          backgroundColor: Colors.green,
        ).showSnackBar(context);
      }
    } catch (e) {
      debugPrint('Error deleting activity: $e');

      setState(() {
        isLoading = false;
      });

      if (context.mounted) {
        CustomSnackBar(
          message: 'Echec de la suppression de l\'activité',
          backgroundColor: Colors.red,
        ).showSnackBar(context);
      }
    }
  }

  Future<List<dynamic>> readSubFilters() async {
    setState(() {
      isLoading = true;
    });

    try {
      if (selectedSection == 0) {
        if (selectedFilter == 'Par catégorie') {
          subFilters = await SportService().getSportCategories();
        } else if (selectedFilter == 'Par âge') {
          subFilters = await SportService().getSportAges();
        } else if (selectedFilter == 'Par jour') {
          subFilters = await SportService().getSportDays();
        } else if (selectedFilter == 'Par horaire') {
          subFilters = await SportService().getSportSchedules();
        } else if (selectedFilter == 'Par secteur') {
          subFilters = await SportService().getSportSectors();
        }
      } else {
        if (selectedFilter == 'Par catégorie') {
          subFilters = await CultureService().getCultureCategories();
        } else if (selectedFilter == 'Par âge') {
          subFilters = await CultureService().getCultureAges();
        } else if (selectedFilter == 'Par jour') {
          subFilters = await CultureService().getCultureDays();
        } else if (selectedFilter == 'Par horaire') {
          subFilters = await CultureService().getCultureSchedules();
        } else if (selectedFilter == 'Par secteur') {
          subFilters = await CultureService().getCultureSectors();
        }
      }

      if (!subFilters.any((subFilter) => subFilter.id == selectedSubFilters)) {
        setState(() {
          selectedSubFilters = [];
        });
      }
    } catch (e) {
      debugPrint('Error reading sub-filters: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }

    return subFilters;
  }

  List<dynamic> sortSubFilters(List<dynamic> subFilters, String selectedFilter) {
    switch (selectedFilter) {
      case 'Par catégorie':
        subFilters.sort((a,b) => a.name.compareTo(b.name));
        break;

      case 'Par âge':
        subFilters.sort((a, b) {
          int minAgeA = _getMinAgeFromAgeRange(a.name);
          int minAgeB = _getMinAgeFromAgeRange(b.name);
          return minAgeA.compareTo(minAgeB);
        });
        break;

      case 'Par horaire':
        subFilters.sort((a, b) {
          int startTimeA = _getStartTimeFromSchedule(a.name);
          int startTimeB = _getStartTimeFromSchedule(b.name);
          return startTimeA.compareTo(startTimeB);
        });
        break;

      case 'Par jour':
        subFilters.sort((a, b) {
          return _getDayIndex(a.name).compareTo(_getDayIndex(b.name));
        });
        break;

      case 'Par secteur':
      subFilters.sort((a, b) => a.name.compareTo(b.name));
      break;

      default:
        subFilters.sort((a, b) => a.name.compareTo(b.name));
    }

    return subFilters;
  }

  int _getMinAgeFromAgeRange(String ageRange) {
    RegExp regExp = RegExp(r'(\d+)(?=[\s\-])');
    Match? match = regExp.firstMatch(ageRange);
    if (match != null) {
      return int.parse(match.group(1)!);
    }
    return 99;
  }

  int _getStartTimeFromSchedule(String schedule) {
    RegExp regExp = RegExp(r'(\d+)h');
    Match? match = regExp.firstMatch(schedule);
    if (match != null) {
      return int.parse(match.group(1)!);
    }
    return 99;
  }

  int _getDayIndex(String day) {
    Map<String, int> dayOrder = {
      'Lundi': 0,
      'Mardi': 1,
      'Mercredi': 2,
      'Jeudi': 3,
      'Vendredi': 4,
      'Samedi': 5,
      'Dimanche': 6,
    };

    return dayOrder[day] ?? 99;
  }

  @override
  void initState() {
    super.initState();
    selectedFilter = 'Par catégorie';
    readSubFilters();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? 
      Scaffold(
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
                child: Center(
                  child: SpinKitSpinningLines(
                    color: Colors.white,
                    size: 60,
                  ),
                )
              )
            )
          ]
        )
      )
    : Scaffold(
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
                      'Gérer les activités de l\'application',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children : [
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
                          setState(() {
                            _currentMode = ActivityMode.adding;
                            readSubFilters();
                          });
                        },
                        child: Icon(Icons.add, size: 30, color: Colors.white),
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
                          setState(() {
                            _currentMode = ActivityMode.editing;
                            readSubFilters();
                          });
                        },
                        child: Icon(Icons.edit, size: 30, color: Colors.white),
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
                          setState(() {
                            _currentMode = ActivityMode.deleting;
                            readSubFilters();
                          });
                        },
                        child: Icon(Icons.remove, size: 30, color: Colors.white),
                      ),
                    ], 
                  ),
                  SizedBox(height: 16),

                  if (_currentMode == ActivityMode.adding) _buildAddActivity(context),
                  if (_currentMode == ActivityMode.editing) _buildEditActivity(context),
                  if (_currentMode == ActivityMode.deleting) _buildDeleteActivity(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddActivity(BuildContext context) {
    return Form(
      key: _addActivityKey,
      child: Column(
        children: [
          ToggleButtons(
            isSelected: [selectedSection == 0, selectedSection == 1],
            onPressed: (int section) {
              setState(() {
                selectedSection = section;
                selectedSubFiltersByCategories = [];
                selectedSubFiltersByAges = [];
                selectedSubFiltersByDays = [];
                selectedSubFiltersBySchedules = [];
                selectedSubFiltersBySectors = [];
                readSubFilters();
              });
            },
            color: Colors.black,
            selectedColor: Colors.white,
            fillColor: Color(0xFF5B59B4),
            borderColor: Color(0xFF5B59B4),
            selectedBorderColor: Color(0xFF5B59B4),
            borderRadius: BorderRadius.circular(20),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 1.0),
                child: Center(
                  child: Text('Sport')
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 1.0),
                child: Center(
                  child: Text('Culture')
                ),
              ),
            ],  
          ),
          const SizedBox(height: 16),
          DropdownButton<String>(
            value: selectedFilter,
            onChanged: (String? newValue) {
              setState(() {
                selectedFilter = newValue!;
                subFilters = [];
                readSubFilters();
              });
            },
            items: ['Par catégorie', 'Par âge', 'Par jour', 'Par horaire', 'Par secteur']
              .map((String filter) {
                return DropdownMenuItem<String>(
                  value: filter,
                  child: Text(filter),
                );
              }).toList(),
          ),
          const SizedBox(height: 16),
          DropdownButton<String>(
            value: selectedSubFilters.isEmpty && subFilters.isNotEmpty ? subFilters[0].id : selectedSubFilters[0],
            onChanged: (String? newValue) {
              setState(() {
                var selectedSubFilter = subFilters.firstWhere((item) => item.id == newValue);
                var subFilterMap = {'id': selectedSubFilter.id.toString(), 'name': selectedSubFilter.name.toString()};

                if (selectedFilter == 'Par catégorie') {
                  if (!selectedSubFiltersByCategories.any((item) => item['id'] == newValue)) {
                    selectedSubFiltersByCategories.add(subFilterMap);
                  }
                }
                if (selectedFilter == 'Par âge') {
                  if (!selectedSubFiltersByAges.any((item) => item['id'] == newValue)) {
                    selectedSubFiltersByAges.add(subFilterMap);
                  }
                }
                if (selectedFilter == 'Par jour') {
                  if (!selectedSubFiltersByDays.any((item) => item['id'] == newValue)) {
                    selectedSubFiltersByDays.add(subFilterMap);
                  }
                }
                if (selectedFilter == 'Par horaire') {
                  if (!selectedSubFiltersBySchedules.any((item) => item['id'] == newValue)) {
                    selectedSubFiltersBySchedules.add(subFilterMap);
                  }
                }
                if (selectedFilter == 'Par secteur') {
                  if (!selectedSubFiltersBySectors.any((item) => item['id'] == newValue)) {
                    selectedSubFiltersBySectors.add(subFilterMap);
                  }
                }
              });
            },
            items: sortSubFilters(subFilters, selectedFilter).map((subFilter) {
              return DropdownMenuItem<String>(
                value: subFilter.id,
                child: Text(subFilter.name),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Text(
            'Par catégorie :',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          Wrap(
            spacing: 8.0,
            children: selectedSubFiltersByCategories.map((subFilter) {
              debugPrint('selectedSubFiltersByCategories 1: $selectedSubFiltersByCategories');
              return Chip(
                label: Text(subFilter['name']!),
                deleteIcon: Icon(Icons.close),
                onDeleted: () {
                  setState(() {
                    selectedSubFiltersByCategories.removeWhere((item) => item['id'] == subFilter['id']);
                  });
                },
              );
            }).toList(),
          ),
          Text(
            'Par âge :',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          Wrap(
            spacing: 8.0,
            children: selectedSubFiltersByAges.map((subFilter) {
              return Chip(
                label: Text(subFilter['name']!),
                deleteIcon: Icon(Icons.close),
                onDeleted: () {
                  setState(() {
                    selectedSubFiltersByAges.removeWhere((item) => item['id'] == subFilter['id']);
                  });
                },
              );
            }).toList(),
          ),
          Text(
            'Par jour :',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          Wrap(
            spacing: 8.0,
            children: selectedSubFiltersByDays.map((subFilter) {
              return Chip(
                label: Text(subFilter['name']!),
                deleteIcon: Icon(Icons.close),
                onDeleted: () {
                  setState(() {
                    selectedSubFiltersByDays.removeWhere((item) => item['id'] == subFilter['id']);
                  });
                },
              );
            }).toList(),
          ),
          Text(
            'Par horaire :',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          Wrap(
            spacing: 8.0,
            children: selectedSubFiltersBySchedules.map((subFilter) {
              return Chip(
                label: Text(subFilter['name']!),
                deleteIcon: Icon(Icons.close),
                onDeleted: () {
                  setState(() {
                    selectedSubFiltersBySchedules.removeWhere((item) => item['id'] == subFilter['id']);
                  });
                },
              );
            }).toList(),
          ),
          Text(
            'Par secteur :',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          Wrap(
            spacing: 8.0,
            children: selectedSubFiltersBySectors.map((subFilter) {
              return Chip(
                label: Text(subFilter['name']!),
                deleteIcon: Icon(Icons.close),
                onDeleted: () {
                  setState(() {
                    selectedSubFiltersBySectors.removeWhere((item) => item['id'] == subFilter['id']);
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: disciplineController,
            decoration: const InputDecoration(
              labelText: 'Discipline',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer un nom de discipline';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: startHourController,
            decoration: const InputDecoration(
              labelText: 'Horaire de début',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer un horaire de début';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: endHourController,
            decoration: const InputDecoration(
              labelText: 'Horaire de fin',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer un horaire de fin';
              }
              return null;
            },
          ),

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
              if (_addActivityKey.currentState!.validate()) {
                createNewActivity(
                  context: context,
                );
                disciplineController.clear();
              }
            },
            child: Text('Ajouter l\'activité'),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 32),
          ),
        ],
      ),
    );
  }


  Widget _buildEditActivity(BuildContext context) {
    return Form(
      key: _editActivityKey,
      child: Column(
        children: [
          ToggleButtons(
            isSelected: [selectedSection == 0, selectedSection == 1],
            onPressed: (int section) {
              setState(() {
                selectedSection = section;
                readSubFilters();
              });
            },
            color: Colors.black,
            selectedColor: Colors.white,
            fillColor: Color(0xFF5B59B4),
            borderColor: Color(0xFF5B59B4),
            selectedBorderColor: Color(0xFF5B59B4),
            borderRadius: BorderRadius.circular(20),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 1.0),
                child: Center(
                  child: Text('Sport')
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 1.0),
                child: Center(
                  child: Text('Culture')
                ),
              ),
            ],  
          ),
          const SizedBox(height: 16),
          DropdownButton<String>(
            value: selectedFilter,
            onChanged: (String? newValue) {
              setState(() {
                selectedFilter = newValue!;
                subFilters = [];
                readSubFilters();
              });
            },
            items: ['Par catégorie', 'Par âge', 'Par jour', 'Par horaire', 'Par secteur']
              .map((String filter) {
                return DropdownMenuItem<String>(
                  value: filter,
                  child: Text(filter),
                );
              }).toList(),
          ),
          const SizedBox(height: 16),
          DropdownButton<String>(
            value: selectedSubFilters.isEmpty && subFilters.isNotEmpty ? subFilters[0].id : selectedSubFilters,
            onChanged: (String? newValue) {
              setState(() {
                var selectedSubFilters = subFilters.firstWhere((subFilter) => subFilter.id == newValue);
                selectedSubFilters = [newValue!];
                if (selectedSubFilters.contains(newValue)) {
                  selectedSubFilters.remove(newValue);
                } else {
                  selectedSubFilters.add(newValue);
                }
              });
            },
            items: sortSubFilters(subFilters, selectedFilter).map((subFilter) {
              return DropdownMenuItem<String>(
                value: subFilter.id,
                child: Text(subFilter.name),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
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
              if (_editActivityKey.currentState!.validate()) {
                updateActivity(
                  context: context,
                );
              }
            },
            child: Text('Modifier l\'activité'),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 32),
          ),
        ],)
    );
  }

  Widget _buildDeleteActivity(BuildContext context) {
    return Form(
      key: _deleteActivityKey,
      child: Column(
        children: [
          ToggleButtons(
            isSelected: [selectedSection == 0, selectedSection == 1],
            onPressed: (int section) {
              setState(() {
                selectedSection = section;
                readSubFilters();
              });
            },
            color: Colors.black,
            selectedColor: Colors.white,
            fillColor: Color(0xFF5B59B4),
            borderColor: Color(0xFF5B59B4),
            selectedBorderColor: Color(0xFF5B59B4),
            borderRadius: BorderRadius.circular(20),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 1.0),
                child: Center(
                  child: Text('Sport')
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 1.0),
                child: Center(
                  child: Text('Culture')
                ),
              ),
            ],  
          ),
          const SizedBox(height: 16),
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
              if (_deleteActivityKey.currentState!.validate()) {
                deleteActivity(
                  context: context,
                );
              }
            },
            child: Text('Supprimer l\'activité'),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 32),
          ),
        ],
      )
    );
  }
}