import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:octoloupe/CRUD/user_crud.dart';
import 'package:octoloupe/components/snackbar.dart';
import 'package:octoloupe/model/culture_filters_model.dart';
import 'package:octoloupe/model/sport_filters_model.dart';

import '../model/user_model.dart';

class UserNotificationsPage extends StatefulWidget {
  const UserNotificationsPage({super.key});

  @override
  UserNotificationsPageState createState() => UserNotificationsPageState();
}

class UserNotificationsPageState extends State<UserNotificationsPage> {
  int _selectedSection = 0;
  Filters? filtersSport;
  Filters? filtersCulture;
  UserModel? user;

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

  void applyFilters() {
    if (_selectedSection == 0) {
      selectedSportCategories = (filtersSport?.categoriesId ?? [])
        .map((e) => SportCategory.fromMap(e))
        .toList();

      selectedSportAges = (filtersSport?.agesId ?? [])
        .map((e) => SportAge.fromMap(e))
        .toList();

      selectedSportDays = (filtersSport?.daysId ?? [])
        .map((e) => SportDay.fromMap(e))
        .toList();

      selectedSportSchedules = (filtersSport?.schedulesId ?? [])
        .map((e) => SportSchedule.fromMap(e))
        .toList();

      selectedSportSectors = (filtersSport?.sectorsId ?? [])
        .map((e) => SportSector.fromMap(e))
        .toList();
    } else {
      selectedCultureCategories = (filtersCulture?.categoriesId ?? [])
        .map((e) => CultureCategory.fromMap(e))
        .toList();

      selectedCultureAges = (filtersCulture?.agesId ?? [])
        .map((e) => CultureAge.fromMap(e))
        .toList();

      selectedCultureDays = (filtersCulture?.daysId ?? [])
        .map((e) => CultureDay.fromMap(e))
        .toList();

      selectedCultureSchedules = (filtersCulture?.schedulesId ?? [])
        .map((e) => CultureSchedule.fromMap(e))
        .toList();

      selectedCultureSectors = (filtersCulture?.sectorsId ?? [])
        .map((e) => CultureSector.fromMap(e))
        .toList();

    }
  }

  Future<void> _loadCurrentUser() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    debugPrint('uid: $uid');
    final userData = await UserCRUD().getUser(uid);
    debugPrint('userData: ${userData?.toMap()}');

    if (userData != null) {
      setState(() {
        user = userData;
        filtersSport = user!.filtersSport;
        filtersCulture = user!.filtersCulture;
      });

      debugPrint('L144 filtersSport: ${filtersSport?.toMap()}');
      debugPrint('L145 filtersCulture: ${filtersCulture?.toMap()}');

      applyFilters();

      /* refaire le chemin inverse de collectFilters pour redistribuer */
    } else {
      CustomSnackBar(
        backgroundColor: Colors.red,
        message: 'Aucun utilisateur trouvé',
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
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
                    'Notifications par centres d\'intérêt',
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
                          applyFilters();
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

                              final interests = Filters(
                                categoriesId: filters['categories'] ?? [],
                                agesId: filters['ages'] ?? [],
                                daysId: filters['days'] ?? [],
                                schedulesId: filters['schedules'] ?? [],
                                sectorsId: filters['sectors'] ?? [],
                              );

                              setState(() {
                                if (_selectedSection == 0) {
                                  filtersSport = interests;
                                } else {
                                  filtersCulture = interests;
                                }
                              });

                              final updatedUser = UserModel(
                                uid: user!.uid,
                                email: user!.email,
                                firstName: user!.firstName,
                                name: user!.name,
                                role: user!.role,
                                filtersSport: _selectedSection == 0 ? filtersSport : null,
                                filtersCulture: _selectedSection == 1 ? filtersCulture : null,
                              );

                              try {
                                UserCRUD userCRUD = UserCRUD();
                                await userCRUD.updateUser(user!.uid, updatedUser);
                                debugPrint("User updated successfully");
                              } catch (e) {
                                debugPrint('Error updating user');
                              }
                            },
                            child: Text('S\'abonner',
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

                              collectFilters();
                              debugPrint('Filters: $filters');

                              /* _resetFilters();
                              filters.clear(); */
                            },
                            child: Text('S\'abonner',
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
          )
        )
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