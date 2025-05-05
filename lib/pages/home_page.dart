import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// Components
import 'package:octoloupe/components/custom_app_bar.dart';
import 'package:octoloupe/components/custom_navbar.dart';
import 'package:octoloupe/components/snackbar.dart';
// Models
import 'package:octoloupe/model/sport_filters_model.dart';
import 'package:octoloupe/model/culture_filters_model.dart';
// Services
import 'package:octoloupe/services/culture_activity_service.dart';
import 'package:octoloupe/services/notification_service.dart';
import 'package:octoloupe/services/sport_activity_service.dart';
// Pages
import 'package:octoloupe/pages/category_selection_page.dart';
import 'package:octoloupe/pages/age_selection_page.dart';
import 'package:octoloupe/pages/day_selection_page.dart';
import 'package:octoloupe/pages/schedule_selection_page.dart';
import 'package:octoloupe/pages/sector_selection_page.dart';
import 'package:octoloupe/pages/activity_page.dart';

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

  // Collect filters to search for matching activities
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

  //List of all activities
  List<Map<String, dynamic>> activities = [];
  SportActivityService sportActivityService = SportActivityService();
  CultureActivityService cultureActivityService = CultureActivityService();
  bool isLoading = false;

  //Get activities
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

  //List of activities after filtering
  List<Map<String, dynamic>> filteredActivities = [];

  Future<List<Map<String, dynamic>>> sortActivities({
    required List<Map<String, dynamic>> activities,
    Map<String, List<Map<String, String>>>? filters,
    List<String>? keywords,
  }) async {

    //Filter activities by categories, ages, days, schedules and sectors
    List<Map<String, String>> categories = [];
    List<Map<String, String>> ages = [];
    List<Map<String, String>> days = [];
    List<Map<String, String>> schedules = [];
    List<Map<String, String>> sectors = [];

    if (filters != null) {
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

      if (matchesCategory && matchesAge && matchesDay && matchesSchedule && matchesSector) {
        filteredActivities.add(activity);
      }
    }
  
    //Filter activities by keywords
    if (keywords != null && keywords.isNotEmpty) {
      filteredActivities = filteredActivities.where((activity) {
        List<RegExp> regExps = keywords.map((keyword) {
          return RegExp(r'\b' + RegExp.escape(keyword.toLowerCase()) + r'\b');
        }).toList();

        String discipline = activity['discipline'] ?? '';
        List<String>? information = activity['information'] ?? [];
        String structureName = activity['contact']['structureName'] ?? '';
        String email = activity['contact']['email'] ?? '';
        String phoneNumber = activity['contact']['phoneNumber'] ?? '';
        String webSite = activity['contact']['webSite'] ?? '';
        String titleAddress = activity['place']['titleAddress'] ?? '';
        String streetAddress = activity['place']['streetAddress'] ?? '';
        String postalCode = activity['place']['postalCode']?.toString() ?? '';
        String city = activity['place']['city'] ?? '';

        bool matchesSchedule = activity['schedules']?.any((schedule) {
          String day = schedule['day'] ?? '';
          List<Map<String, dynamic>> timeSlots = schedule['timeSlots'] ?? [];

          bool matchesDay = regExps.any((regExp) => day.toLowerCase().contains(regExp));
          bool matchesTimeSlots = timeSlots.any((timeSlot) {
            String startHour = timeSlot['startHour'] ?? '';
            String endHour = timeSlot['endHour'] ?? '';
            return regExps.any((regExp) =>
              startHour.toLowerCase().contains(regExp) ||
              endHour.toLowerCase().contains(regExp)
            );
          });

          return matchesDay || matchesTimeSlots;
        }) ?? false;

        bool matchesPricing = activity['pricings']?.any((pricing) {
          String profile = pricing['profile'] ?? '';
          String pricingValue = pricing['pricing'] ?? '';
          return regExps.any((regExp) =>
            profile.toLowerCase().contains(regExp) ||
            pricingValue.toLowerCase().contains(regExp));
        }) ?? false;
        
        bool matchesKeywords = regExps.every((regExp) {
          return discipline.toLowerCase().contains(regExp) ||
          (information != null ? information.join(' ') : '').toLowerCase().contains(regExp) ||
          structureName.toLowerCase().contains(regExp) ||
          email.toLowerCase().contains(regExp) ||
          phoneNumber.toLowerCase().contains(regExp) ||
          webSite.toLowerCase().contains(regExp) ||
          titleAddress.toLowerCase().contains(regExp) ||
          streetAddress.toLowerCase().contains(regExp) ||
          postalCode.toLowerCase().contains(regExp) ||
          city.toLowerCase().contains(regExp) ||
          matchesSchedule ||
          matchesPricing;
        });

        return matchesKeywords;
      }).toList();
    }
    
    return filteredActivities;
  }

  final keywordsController = TextEditingController();

  //Get all activities before filtering by keyword
  Future<void> readAllActivities() async {
    try {
      setState(() {
        isLoading = true;
      });

      List<Map<String, dynamic>> sportActivities = (await sportActivityService.getSportActivities())
        .map((item) => (item).toMap())
        .toList();

      List<Map<String, dynamic>> cultureActivities = (await cultureActivityService.getCultureActivities())
        .map((item) => (item).toMap())
        .toList();

      activities = [...sportActivities, ...cultureActivities];

      await Future.delayed(Duration(milliseconds: 25));

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching activities: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    /* readActivities(); */
    NotificationService().initNotification();
  }

  @override
  Widget build(
    BuildContext context
  ) {
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
                              
                            await readAllActivities();

                            List<String> keywords = searchQuery.split(' ').map((e) => e.trim()).toList();

                            List<Map<String, dynamic>> filteredActivities = await sortActivities(
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
                    EdgeInsetsGeometry padding;

                    if (constraints.maxWidth < 325) {
                      padding = EdgeInsets.symmetric(horizontal: 30.0, vertical: 1.0);
                    } else {
                      padding = EdgeInsets.symmetric(horizontal: 30.0, vertical: 1.0);
                    }

                    return ToggleButtons(
                      isSelected: [_selectedSection == 0, _selectedSection == 1],
                      onPressed: (int section) {
                        setState(() {
                          _selectedSection = section;
                          _resetFilters();
                          readActivities();
                        });
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
                          final List<Map<String, String>>? selectedCategories = await context.push(
                            '/home/categories',
                            extra: {
                              'isSport': _selectedSection == 0,
                              'selectedCategories': _selectedSection == 0 ?
                                selectedSportCategories.map((category) => {
                                  'id': category.id ?? '',
                                  'name': category.name,
                                }).toList()
                                : selectedCultureCategories.map((category) => {
                                  'id': category.id ?? '',
                                  'name': category.name,
                                }).toList(),
                            }
                          );

                          setState(() {
                            if (selectedCategories != null) {
                              if (_selectedSection == 0) {
                                selectedSportCategories = selectedCategories
                                  .map((category) => SportCategory.fromMap(category))
                                  .toList();
                              } else {
                                selectedCultureCategories = selectedCategories
                                  .map((category) => CultureCategory.fromMap(category))
                                  .toList();
                              }
                            }
                          });
                        },
                        isSport: _selectedSection == 0,
                      ),
                      //Filter button by ages
                      _buildCriteriaTile(
                        context,
                        Icons.accessibility_new,
                        'Par âge',
                        () async {
                          final List<Map<String, String>>? selectedAges = await context.push(
                            '/home/ages',
                            extra: {
                              'isSport': _selectedSection == 0,
                              'selectedAges': _selectedSection == 0 ?
                                selectedSportAges.map((age) => {
                                  'id': age.id ?? '',
                                  'name': age.name,
                                }).toList()
                                : selectedCultureAges.map((age) => {
                                  'id': age.id ?? '',
                                  'name': age.name,
                                }).toList(),
                            }
                          );
                            
                          setState(() {
                            if (selectedAges != null) {
                              if (_selectedSection == 0) {
                                selectedSportAges = selectedAges
                                  .map((age) => SportAge.fromMap(age))
                                  .toList();
                              } else {
                                selectedCultureAges = selectedAges
                                  .map((age) => CultureAge.fromMap(age))
                                  .toList();
                              }
                            }
                          });
                        },
                        isSport: _selectedSection == 0,
                      ),
                      //Filter button by days
                      _buildCriteriaTile(
                        context,
                        Icons.date_range,
                        'Par jour',
                        () async {
                          final List<Map<String, String>>? selectedDays = await context.push(
                            '/home/days',
                            extra: {
                              'isSport': _selectedSection == 0,
                              'selectedDays': _selectedSection == 0 ?
                                selectedSportDays.map((day) => {
                                  'id': day.id ?? '',
                                  'name': day.name,
                                }).toList()
                                : selectedCultureDays.map((day) => {
                                  'id': day.id ?? '',
                                  'name': day.name,
                                }).toList(),
                            }
                          );

                          setState(() {
                            if (selectedDays != null) {
                              if (_selectedSection == 0) {
                                selectedSportDays = selectedDays
                                  .map((day) => SportDay.fromMap(day))
                                  .toList();
                              } else {
                                selectedCultureDays = selectedDays
                                  .map((day) => CultureDay.fromMap(day))
                                  .toList();
                              }
                            }
                          });
                        },
                        isSport: _selectedSection == 0,
                      ),
                      //Filter button by schedules
                      _buildCriteriaTile(
                        context,
                        Icons.access_time,
                        'Par horaire',
                        () async {
                          final List<Map<String, String>>? selectedSchedules = await context.push(
                            '/home/schedules',
                            extra: {
                              'isSport': _selectedSection == 0,
                              'selectedSchedules': _selectedSection == 0 ?
                                selectedSportSchedules.map((schedule) => {
                                  'id': schedule.id ?? '',
                                  'name': schedule.name,
                                }).toList()
                                : selectedCultureSchedules.map((schedule) => {
                                  'id': schedule.id ?? '',
                                  'name': schedule.name,
                                }).toList(),
                            }
                          );

                          setState(() {
                            if (selectedSchedules != null) {
                              if (_selectedSection == 0) {
                                selectedSportSchedules = selectedSchedules
                                  .map((schedule) => SportSchedule.fromMap(schedule))
                                  .toList();
                              } else {
                                selectedCultureSchedules = selectedSchedules
                                  .map((schedule) => CultureSchedule.fromMap(schedule))
                                  .toList();
                              }
                            }
                          });
                        },
                        isSport: _selectedSection == 0,
                      ),
                      //Filter button by sectors
                      _buildCriteriaTile(
                        context,
                        Icons.apartment_rounded,
                        'Par secteur',
                        () async {
                          final List<Map<String, String>>? selectedSectors = await context.push(
                            '/home/sectors',
                            extra: {
                              'isSport': _selectedSection == 0,
                              'selectedSectors': _selectedSection == 0 ?
                                selectedSportSectors.map((sector) => {
                                  'id': sector.id ?? '',
                                  'name': sector.name,
                                }).toList()
                                : selectedCultureSectors.map((sector) => {
                                  'id': sector.id ?? '',
                                  'name': sector.name,
                                }).toList(),
                            }
                          );
                            
                          setState(() {
                            if (selectedSectors != null) {
                              if (_selectedSection == 0) {
                                selectedSportSectors = selectedSectors
                                  .map((sector) => SportSector.fromMap(sector))
                                  .toList();
                              } else {
                                selectedCultureSectors = selectedSectors
                                  .map((sector) => CultureSector.fromMap(sector))
                                  .toList();
                              }
                            }
                          });
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

                              collectFilters();
                              await readActivities();
                              
                              filteredActivities = await sortActivities(
                                filters: filters,
                                activities: activities,
                              );

                              if (filteredActivities.isNotEmpty) {
                                setState(() {
                                  filteredActivities = filteredActivities;
                                });
                                
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

                              _resetFilters();
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
                              _resetFilters();
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
                              filteredActivities.clear();

                              collectFilters();
                              readActivities();

                              filteredActivities = await sortActivities(
                                filters: filters,
                                activities: activities
                              );

                              if (filteredActivities.isNotEmpty) {
                                setState(() {
                                  filteredActivities = filteredActivities;
                                });

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

                              _resetFilters();
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
                              _resetFilters();
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