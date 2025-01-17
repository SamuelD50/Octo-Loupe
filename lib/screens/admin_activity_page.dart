import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:octoloupe/components/custom_app_bar.dart';
import 'package:octoloupe/components/snackbar.dart';
import 'package:octoloupe/screens/admin_interface_page.dart';
import 'package:octoloupe/services/culture_filter_service.dart';
import 'package:octoloupe/services/sport_filter_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:octoloupe/model/activity_model.dart';
import 'package:octoloupe/services/sport_filter_service.dart';
import 'package:octoloupe/services/culture_filter_service.dart';
import 'package:octoloupe/services/culture_activity_service.dart';
import 'package:octoloupe/services/sport_activity_service.dart';

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
  String activityId = '';
  int selectedSection = 0;
  String selectedFilter = '';
  List<dynamic> subFilters = [];
  List<dynamic> selectedSubFilters = [];
  bool isLoading = false;
  bool isAdding = false;
  bool isEditing = false;
  bool isDeleting = false;
  SportActivityService sportActivityService = SportActivityService();
  CultureActivityService cultureActivityService = CultureActivityService();

  TextEditingController disciplineController = TextEditingController();
  TextEditingController informationController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();
  TextEditingController structureNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController webSiteController = TextEditingController();
  TextEditingController titleAddressController = TextEditingController();
  TextEditingController streetAddressController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController dayController = TextEditingController();
  TextEditingController startHourController = TextEditingController();
  TextEditingController endHourController = TextEditingController();
  TextEditingController profileController = TextEditingController();
  TextEditingController pricingController = TextEditingController();

  List<Map<String, String>> selectedSubFiltersByCategories = [];
  List<Map<String, String>> selectedSubFiltersByAges = [];
  List<Map<String, String>> selectedSubFiltersByDays = [];
  List<Map<String, String>> selectedSubFiltersBySchedules = [];
  List<Map<String, String>> selectedSubFiltersBySectors = [];


  Future<void> createNewActivity({
    required BuildContext context
  }) async {
    String discipline = disciplineController.text.trim();
    String information = informationController.text.trim();
    String imageUrl = imageUrlController.text.trim();
    String structureName = structureNameController.text.trim();
    String email = emailController.text.trim();
    String phoneNumber = phoneNumberController.text.trim();
    String webSite = webSiteController.text.trim();
    String titleAddress = titleAddressController.text.trim();
    String streetAddress = streetAddressController.text.trim();
    int postalCode = int.tryParse(postalCodeController.text.trim()) ?? 50130;
    String city = cityController.text.trim();
    double latitude = double.parse(latitudeController.text.trim());
    double longitude = double.parse(longitudeController.text.trim());
    String day = dayController.text.trim();
    String startHour = startHourController.text.trim();
    String endHour = endHourController.text.trim();
    String profile = profileController.text.trim();
    String pricing = pricingController.text.trim();
    List<Map<String, String>> categoriesId = selectedSubFiltersByCategories.map((item) {
      return {
        'id': item['id'] ?? '',
        'name': item['name'] ?? '',
      };
    }).toList();
    List<Map<String, String>> agesId = selectedSubFiltersByAges.map((item) {
      return {
        'id': item['id'] ?? '',
        'name': item['name'] ?? '',
      };
    }).toList();
    List<Map<String, String>> daysId = selectedSubFiltersByDays.map((item) {
      return {
        'id': item['id'] ?? '',
        'name': item['name'] ?? '',
      };
    }).toList();
    List<Map<String, String>> schedulesId = selectedSubFiltersBySchedules.map((item) {
      return {
        'id': item['id'] ?? '',
        'name': item['name'] ?? '',
      };
    }).toList();
    List<Map<String, String>> sectorsId = selectedSubFiltersBySectors.map((item) {
      return {
        'id': item['id'] ?? '',
        'name': item['name'] ?? '',
      };
    }).toList();

    try {
      setState(() {
        isLoading = true;
      });

      if (selectedSection == 0) {
        await sportActivityService.addSportActivity(
          null,
          discipline,
          information,
          imageUrl,
          structureName,
          email,
          phoneNumber,
          webSite,
          titleAddress,
          streetAddress,
          postalCode,
          city,
          latitude,
          longitude,
          day,
          startHour,
          endHour,
          profile,
          pricing,
          selectedSubFiltersByCategories,
          selectedSubFiltersByAges,
          selectedSubFiltersByDays,
          selectedSubFiltersBySchedules,
          selectedSubFiltersBySectors,
        );
      } else {
        await cultureActivityService.addCultureActivity(
          null,
          discipline,
          information,
          imageUrl,
          structureName,
          email,
          phoneNumber,
          webSite,
          titleAddress,
          streetAddress,
          postalCode,
          city,
          latitude,
          longitude,
          day,
          startHour,
          endHour,
          profile,
          pricing,
          selectedSubFiltersByCategories,
          selectedSubFiltersByAges,
          selectedSubFiltersByDays,
          selectedSubFiltersBySchedules,
          selectedSubFiltersBySectors,
        );
      }
    
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

      if (selectedSection == 0) {
        await sportActivityService.getSportActivities();
      } else {
        await cultureActivityService.getCultureActivities();
      }
    } catch (e) {
      debugPrint('Error fetching activity: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  TextEditingController newDisciplineController = TextEditingController();
  TextEditingController newInformationController = TextEditingController();
  TextEditingController newImageUrlController = TextEditingController();
  TextEditingController newStructureNameController = TextEditingController();
  TextEditingController newEmailController = TextEditingController();
  TextEditingController newPhoneNumberController = TextEditingController();
  TextEditingController newWebSiteController = TextEditingController();
  TextEditingController newTitleAddressController = TextEditingController();
  TextEditingController newStreetAddressController = TextEditingController();
  TextEditingController newPostalCodeController = TextEditingController();
  TextEditingController newCityController = TextEditingController();
  TextEditingController newLatitudeController = TextEditingController();
  TextEditingController newLongitudeController = TextEditingController();
  TextEditingController newDayController = TextEditingController();
  TextEditingController newStartHourController = TextEditingController();
  TextEditingController newEndHourController = TextEditingController();
  TextEditingController newProfileController = TextEditingController();
  TextEditingController newPricingController = TextEditingController();

  List<Map<String, String>> newSelectedSubFiltersByCategories = [];
  List<Map<String, String>> newSelectedSubFiltersByAges = [];
  List<Map<String, String>> newSelectedSubFiltersByDays = [];
  List<Map<String, String>> newSelectedSubFiltersBySchedules = [];
  List<Map<String, String>> newSelectedSubFiltersBySectors = [];

  Future<void> updateActivity({
    required BuildContext context
  }) async {
    String newDiscipline = newDisciplineController.text.trim();
    String newInformation = newInformationController.text.trim();
    String newImageUrl = newImageUrlController.text.trim();
    String newStructureName = newStructureNameController.text.trim();
    String newEmail = newEmailController.text.trim();
    String newPhoneNumber = newPhoneNumberController.text.trim();
    String newWebSite = newWebSiteController.text.trim();
    String newTitleAddress = newTitleAddressController.text.trim();
    String newStreetAddress = newStreetAddressController.text.trim();
    int newPostalCode = int.tryParse(newPostalCodeController.text.trim()) ?? 50130;
    String newCity = newCityController.text.trim();
    double newLatitude = double.parse(newLatitudeController.text.trim());
    double newLongitude = double.parse(newLongitudeController.text.trim());
    String newDay = newDayController.text.trim();
    String newStartHour = newStartHourController.text.trim();
    String newEndHour = newEndHourController.text.trim();
    String newProfile = newProfileController.text.trim();
    String newPricing = newPricingController.text.trim();
    List<Map<String, String>> newCategoriesId = newSelectedSubFiltersByCategories.map((item) {
      return {
        'id': item['id'] ?? '',
        'name': item['name'] ?? '',
      };
    }).toList();
    List<Map<String, String>> newAgesId = newSelectedSubFiltersByAges.map((item) {
      return {
        'id': item['id'] ?? '',
        'name': item['name'] ?? '',
      };
    }).toList();
    List<Map<String, String>> newDaysId = newSelectedSubFiltersByDays.map((item) {
      return {
        'id': item['id'] ?? '',
        'name': item['name'] ?? '',
      };
    }).toList();
    List<Map<String, String>> newSchedulesId = newSelectedSubFiltersBySchedules.map((item) {
      return {
        'id': item['id'] ?? '',
        'name': item['name'] ?? '',
      };
    }).toList();
    List<Map<String, String>> newSectorsId = newSelectedSubFiltersBySectors.map((item) {
      return {
        'id': item['id'] ?? '',
        'name': item['name'] ?? '',
      };
    }).toList();

    try {
      setState(() {
        isLoading = true;
      });

      if (selectedSection == 0) {
        await sportActivityService.updateSportActivity(
          activityId,
          newDiscipline,
          newInformation,
          newImageUrl,
          newStructureName,
          newEmail,
          newPhoneNumber,
          newWebSite,
          newTitleAddress,
          newStreetAddress,
          newPostalCode,
          newCity,
          newLatitude,
          newLongitude,
          newDay,
          newStartHour,
          newEndHour,
          newProfile,
          newPricing,
          newCategoriesId,
          newAgesId,
          newDaysId,
          newSchedulesId,
          newSectorsId,
        );
      } else {
        await cultureActivityService.updateCultureActivity(
          activityId,
          newDiscipline,
          newInformation,
          newImageUrl,
          newStructureName,
          newEmail,
          newPhoneNumber,
          newWebSite,
          newTitleAddress,
          newStreetAddress,
          newPostalCode,
          newCity,
          newLatitude,
          newLongitude,
          newDay,
          newStartHour,
          newEndHour,
          newProfile,
          newPricing,
          newCategoriesId,
          newAgesId,
          newDaysId,
          newSchedulesId,
          newSectorsId,
        );
      }

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

  Future<void> deleteActivity({
    required BuildContext context
  }) async {
    try {
      setState(() {
        isLoading = true;
      });

      if (selectedSection == 0) {
        await sportActivityService.deleteSportActivity(
          activityId,
        );
      } else {
        await cultureActivityService.deleteCultureActivity(
          activityId,
        );
      }

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
          subFilters = await SportFilterService().getSportCategories();
        } else if (selectedFilter == 'Par âge') {
          subFilters = await SportFilterService().getSportAges();
        } else if (selectedFilter == 'Par jour') {
          subFilters = await SportFilterService().getSportDays();
        } else if (selectedFilter == 'Par horaire') {
          subFilters = await SportFilterService().getSportSchedules();
        } else if (selectedFilter == 'Par secteur') {
          subFilters = await SportFilterService().getSportSectors();
        }
      } else {
        if (selectedFilter == 'Par catégorie') {
          subFilters = await CultureFilterService().getCultureCategories();
        } else if (selectedFilter == 'Par âge') {
          subFilters = await CultureFilterService().getCultureAges();
        } else if (selectedFilter == 'Par jour') {
          subFilters = await CultureFilterService().getCultureDays();
        } else if (selectedFilter == 'Par horaire') {
          subFilters = await CultureFilterService().getCultureSchedules();
        } else if (selectedFilter == 'Par secteur') {
          subFilters = await CultureFilterService().getCultureSectors();
        }
      }

      if (!subFilters.any(
        (subFilter) => subFilter.id == selectedSubFilters)
      ) {
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

  List<dynamic> sortSubFilters(
    List<dynamic> subFilters,
    String selectedFilter
  ) {
    switch (selectedFilter) {
      case 'Par catégorie':
        subFilters.sort(
          (a,b) => a.name.compareTo(b.name)
        );
        break;

      case 'Par âge':
        subFilters.sort(
          (a, b) {
            int minAgeA = _getMinAgeFromAgeRange(a.name);
            int minAgeB = _getMinAgeFromAgeRange(b.name);
            return minAgeA.compareTo(minAgeB);
          }
        );
        break;

      case 'Par horaire':
        subFilters.sort(
          (a, b) {
            int startTimeA = _getStartTimeFromSchedule(a.name);
            int startTimeB = _getStartTimeFromSchedule(b.name);
            return startTimeA.compareTo(startTimeB);
          }
        );
        break;

      case 'Par jour':
        subFilters.sort(
          (a, b) {
            return _getDayIndex(a.name).compareTo(_getDayIndex(b.name));
          }
        );
        break;

      case 'Par secteur':
      subFilters.sort(
        (a, b) => a.name.compareTo(b.name)
      );
      break;

      default:
        subFilters.sort(
          (a, b) => a.name.compareTo(b.name)
        );
    }

    return subFilters;
  }

  int _getMinAgeFromAgeRange(
    String ageRange
  ) {
    RegExp regExp = RegExp(r'(\d+)(?=[\s\-])');
    Match? match = regExp.firstMatch(ageRange);
    if (match != null) {
      return int.parse(match.group(1)!);
    }
    return 99;
  }

  int _getStartTimeFromSchedule(
    String schedule
  ) {
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
  Widget build(
    BuildContext context
  ) {
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
                            disciplineController.clear();
                            informationController.clear();
                            imageUrlController.clear();
                            structureNameController.clear();
                            emailController.clear();
                            phoneNumberController.clear();
                            webSiteController.clear();
                            titleAddressController.clear();
                            streetAddressController.clear();
                            postalCodeController.clear();
                            cityController.clear();
                            latitudeController.clear();
                            longitudeController.clear();
                            dayController.clear();
                            startHourController.clear();
                            endHourController.clear();
                            profileController.clear();
                            pricingController.clear();
                            selectedSubFiltersByCategories.clear();
                            selectedSubFiltersByAges.clear();
                            selectedSubFiltersByDays.clear();
                            selectedSubFiltersBySchedules.clear();
                            selectedSubFiltersBySectors.clear();
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

  Widget _buildAddActivity(
    BuildContext context
  ) {
    return Form(
      key: _addActivityKey,
      child: Column(
        children: [
          ToggleButtons(
            isSelected: [selectedSection == 0, selectedSection == 1],
            onPressed: (int section) {
              setState(() {
                selectedSection = section;
                disciplineController.clear();
                informationController.clear();
                imageUrlController.clear();
                structureNameController.clear();
                emailController.clear();
                phoneNumberController.clear();
                webSiteController.clear();
                titleAddressController.clear();
                streetAddressController.clear();
                postalCodeController.clear();
                cityController.clear();
                latitudeController.clear();
                longitudeController.clear();
                dayController.clear();
                startHourController.clear();
                endHourController.clear();
                profileController.clear();
                pricingController.clear();
                selectedSubFiltersByCategories.clear();
                selectedSubFiltersByAges.clear();
                selectedSubFiltersByDays.clear();
                selectedSubFiltersBySchedules.clear();
                selectedSubFiltersBySectors.clear();
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
            items: [
              'Par catégorie',
              'Par âge',
              'Par jour',
              'Par horaire',
              'Par secteur'
            ]
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
                var selectedSubFilter = subFilters.firstWhere(
                  (item) => item.id == newValue
                );
                var subFilterMap = {
                  'id': selectedSubFilter.id.toString(),
                  'name': selectedSubFilter.name.toString()
                };

                if (selectedFilter == 'Par catégorie') {
                  if (!selectedSubFiltersByCategories.any(
                    (item) => item['id'] == newValue)
                  ) {
                    selectedSubFiltersByCategories.add(subFilterMap);
                  }
                }
                if (selectedFilter == 'Par âge') {
                  if (!selectedSubFiltersByAges.any(
                    (item) => item['id'] == newValue)
                  ) {
                    selectedSubFiltersByAges.add(subFilterMap);
                  }
                }
                if (selectedFilter == 'Par jour') {
                  if (!selectedSubFiltersByDays.any(
                    (item) => item['id'] == newValue)
                  ) {
                    selectedSubFiltersByDays.add(subFilterMap);
                  }
                }
                if (selectedFilter == 'Par horaire') {
                  if (!selectedSubFiltersBySchedules.any(
                    (item) => item['id'] == newValue)
                  ) {
                    selectedSubFiltersBySchedules.add(subFilterMap);
                  }
                }
                if (selectedFilter == 'Par secteur') {
                  if (!selectedSubFiltersBySectors.any(
                    (item) => item['id'] == newValue)
                  ) {
                    selectedSubFiltersBySectors.add(subFilterMap);
                  }
                }
              });
            },
            items: sortSubFilters(
              subFilters, selectedFilter
            ).map((subFilter) {
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
                    selectedSubFiltersByCategories.removeWhere(
                      (item) => item['id'] == subFilter['id']
                    );
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
              debugPrint('selectedSubFiltersByAges 1: $selectedSubFiltersByAges');
              return Chip(
                label: Text(subFilter['name']!),
                deleteIcon: Icon(Icons.close),
                onDeleted: () {
                  setState(() {
                    selectedSubFiltersByAges.removeWhere(
                      (item) => item['id'] == subFilter['id']
                    );
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
              debugPrint('selectedSubFiltersByDays 1: $selectedSubFiltersByDays');
              return Chip(
                label: Text(subFilter['name']!),
                deleteIcon: Icon(Icons.close),
                onDeleted: () {
                  setState(() {
                    selectedSubFiltersByDays.removeWhere(
                      (item) => item['id'] == subFilter['id']
                    );
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
              debugPrint('selectedSubFiltersBySchedules 1: $selectedSubFiltersBySchedules');
              return Chip(
                label: Text(subFilter['name']!),
                deleteIcon: Icon(Icons.close),
                onDeleted: () {
                  setState(() {
                    selectedSubFiltersBySchedules.removeWhere(
                      (item) => item['id'] == subFilter['id']
                    );
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
              debugPrint('selectedSubFiltersBySectors 1: $selectedSubFiltersBySectors');
              return Chip(
                label: Text(subFilter['name']!),
                deleteIcon: Icon(Icons.close),
                onDeleted: () {
                  setState(() {
                    selectedSubFiltersBySectors.removeWhere(
                      (item) => item['id'] == subFilter['id']
                    );
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: TextFormField(
            controller: disciplineController,
              decoration: const InputDecoration(
                labelText: 'Discipline',
                hintText: 'Ex: Course à pied',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un nom de discipline';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: TextFormField(
              controller: informationController,
              decoration: const InputDecoration(
                labelText: 'Information',
                hintText: 'Ex: Amenez votre bouteille d\'eau',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer une information';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: TextFormField(
              controller: imageUrlController,
              decoration: const InputDecoration(
                labelText: 'Image Url',
                hintText: 'Ex: https://www.example.com/image.jpg',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer une image url';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          ExpansionTile(
            title: Text(
              'Contact',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextFormField(
                  controller: structureNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom de la structure organisatrice',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un nom de structure';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Ex: abc@exemple.com',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un email';
                    }

                    final regex = RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'
                    );
                    if (!regex.hasMatch(value)) {
                      return 'Veuillez entrer un email valide';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextFormField(
                  controller: phoneNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Numéro de téléphone',
                    hintText: 'Ex: 01 23 45 67 89/+33 1 23 45 67 89',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un numéro de téléphone';
                    }

                    final regex = RegExp(
                      r'^(\+33\s\d{1}\s\d{2}\s\d{2}\s\d{2}\s\d{2}|\d{2}\s\d{2}\s\d{2}\s\d{2}\s\d{2})$'
                    );
                    if (!regex.hasMatch(value)) {
                      return 'Veuillez entrer un numéro de téléphone valide';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextFormField(
                  controller: webSiteController,
                  decoration: const InputDecoration(
                    labelText: 'Site internet',
                    hintText: 'Ex: https://www.example.com',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un site internet';
                    }

                    final regex = RegExp(
                      r'^(https?:\/\/)?(www\.)?([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,6}(\:[0-9]{1,5})?(\/.*)?$'
                    );
                    if (!regex.hasMatch(value)) {
                      return 'Veuillez entrer un site internet valide';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
          ExpansionTile(
            title: Text(
              'Lieu',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextFormField(
                  controller: titleAddressController,
                  decoration: const InputDecoration(
                    labelText: 'Intitulé d\'adresse',
                    hintText: 'Ex: Stade Maurice Postaire',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un intitulé d\'adresse';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextFormField(
                  controller: streetAddressController,
                  decoration: const InputDecoration(
                    labelText: 'N° et/ou nom de rue',
                    hintText: 'Ex: 18 rue Pierre de Coubertin',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un N° et/ou nom de rue';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextFormField(
                  controller: postalCodeController,
                  decoration: const InputDecoration(
                    labelText: 'Code postal',
                    hintText: 'Ex: 50100',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un code postal';
                    }
                    final regex = RegExp(r'^\d{2}\s?\d{3}$');
                    if (!regex.hasMatch(value)) {
                      return 'Veuillez entrer un code postal valide';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextFormField(
                  controller: cityController,
                  decoration: const InputDecoration(
                    labelText: 'Ville',
                    hintText: 'Ex: Cherbourg-en-Cotentin',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer une ville';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextFormField(
                  controller: latitudeController,
                  decoration: const InputDecoration(
                    labelText: 'Latitude Google Maps',
                    hintText: 'Ex: 49.64358701909363',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer une latitude';
                    }
                    final regex = RegExp(r'^-?\d{1,2}(\.\d+)?$');
                    if (!regex.hasMatch(value)) {
                      return 'Veuillez entrer une latitude valide';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextFormField(
                  controller: longitudeController,
                  decoration: const InputDecoration(
                    labelText: 'Longitude Google Maps',
                    hintText: 'Ex: -1.638480195782405',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer une longitude';
                    }
                    final regex = RegExp(r'^-?(\d{1,3}(\.\d+)?|\.\d+)$');
                    if (!regex.hasMatch(value)) {
                      return 'Veuillez entrer une longitude valide';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
          ExpansionTile(
            title: Text(
              'Horaires',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextFormField(
                  controller: dayController,
                  decoration: const InputDecoration(
                    labelText: 'Jour',
                    hintText: 'Ex: Mercredi',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un jour';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextFormField(
                controller: startHourController,
                  decoration: const InputDecoration(
                    labelText: 'Horaire de début',
                    hintText: 'Ex: 10h, 10h30',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un horaire de début';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextFormField(
                  controller: endHourController,
                  decoration: const InputDecoration(
                    labelText: 'Horaire de fin',
                    hintText: 'Ex: 11h, 11h30',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un horaire de fin';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
          ExpansionTile(
            title: Text(
              'Tarifs et profils',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextFormField(
                  controller: profileController,
                  decoration: const InputDecoration(
                    labelText: 'Profil',
                    hintText: 'Ex: Débutants',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un profil';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextFormField(
                  controller: pricingController,
                  decoration: const InputDecoration(
                    labelText: 'Prix',
                    hintText: 'Ex: 10€, 10€50',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un prix';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
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
              if (_addActivityKey.currentState!.validate()) {
                createNewActivity(
                  context: context,
                );
                disciplineController.clear();
                informationController.clear();
                imageUrlController.clear();
                structureNameController.clear();
                emailController.clear();
                phoneNumberController.clear();
                webSiteController.clear();
                titleAddressController.clear();
                streetAddressController.clear();
                postalCodeController.clear();
                cityController.clear();
                latitudeController.clear();
                longitudeController.clear();
                dayController.clear();
                startHourController.clear();
                endHourController.clear();
                profileController.clear();
                pricingController.clear();
                selectedSubFiltersByCategories.clear();
                selectedSubFiltersByAges.clear();
                selectedSubFiltersByDays.clear();
                selectedSubFiltersBySchedules.clear();
                selectedSubFiltersBySectors.clear();
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


  Widget _buildEditActivity(
    BuildContext context
  ) {
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
            items: [
              'Par catégorie',
              'Par âge',
              'Par jour',
              'Par horaire',
              'Par secteur'
            ]
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
                var selectedSubFilters = subFilters.firstWhere(
                  (subFilter) => subFilter.id == newValue
                );
                selectedSubFilters = [newValue!];
                if (selectedSubFilters.contains(newValue)) {
                  selectedSubFilters.remove(newValue);
                } else {
                  selectedSubFilters.add(newValue);
                }
              });
            },
            items: sortSubFilters(
              subFilters, selectedFilter
            ).map((subFilter) {
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

  Widget _buildDeleteActivity(
    BuildContext context
  ) {
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