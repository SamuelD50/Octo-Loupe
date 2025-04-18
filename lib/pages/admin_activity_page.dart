import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:octoloupe/components/activity_card.dart';
import 'package:octoloupe/components/custom_app_bar.dart';
import 'package:octoloupe/components/snackbar.dart';
import 'package:octoloupe/model/activity_model.dart';
import 'package:octoloupe/services/culture_filter_service.dart';
import 'package:octoloupe/services/sport_filter_service.dart';
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
  List<Map<String, dynamic>> subFilters = [];
  List<Map<String, dynamic>> activities = [];
  List<dynamic> selectedSubFilters = [];
  bool isLoading = false;
  bool isAdding = false;
  bool isEditing = false;
  bool isDeleting = false;
  SportActivityService sportActivityService = SportActivityService();
  CultureActivityService cultureActivityService = CultureActivityService();

  TextEditingController disciplineController = TextEditingController();
  List<TextEditingController> informationControllers = [];
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
  List<TextEditingController> dayControllers = [];
  List<List<TextEditingController>> startHourControllersPerDay = [];
  List<List<TextEditingController>> endHourControllersPerDay = [];
  List<TextEditingController> profileControllers = [];
  List<TextEditingController> pricingControllers = [];
  List<Map<String, String>> selectedSubFiltersByCategories = [];
  List<Map<String, String>> selectedSubFiltersByAges = [];
  List<Map<String, String>> selectedSubFiltersByDays = [];
  List<Map<String, String>> selectedSubFiltersBySchedules = [];
  List<Map<String, String>> selectedSubFiltersBySectors = [];
  
  Future<void> createNewActivity({
    required BuildContext context
  }) async {
    String discipline = disciplineController.text.trim();
    List<String>? information = [];
    for (int i = 0; i < informationControllers.length; i++) {
      String informations = informationControllers[i].text.trim();
      if (informations.isNotEmpty) {
        information.add(informations);
      }
    }
    String? imageUrl = imageUrlController.text.trim();
    String structureName = structureNameController.text.trim();
    String? email = emailController.text.trim();
    String? phoneNumber = phoneNumberController.text.trim();
    String? webSite = webSiteController.text.trim();
    String titleAddress = titleAddressController.text.trim();
    String streetAddress = streetAddressController.text.trim();
    int postalCode = int.parse(postalCodeController.text.trim());
    String city = cityController.text.trim();
    double latitude = double.parse(latitudeController.text.trim());
    double longitude = double.parse(longitudeController.text.trim());
    List<Schedule> schedules = [];
    for (int d = 0; d < dayControllers.length; d++) {
      String day = dayControllers[d].text.trim();
      List<TimeSlot> timeSlots = [];
      for (int t = 0; t < startHourControllersPerDay[d].length; t++) {
        String? startHour = startHourControllersPerDay[d][t].text.trim();
        String? endHour = endHourControllersPerDay[d][t].text.trim();
        timeSlots.add(TimeSlot(startHour: startHour, endHour: endHour));
      }
      schedules.add(Schedule(day: day, timeSlots: timeSlots));
    }
    List<Pricing> pricings = [];
    for (int i = 0; i < profileControllers.length; i++) {
      String profile = profileControllers[i].text.trim();
      String pricing = pricingControllers[i].text.trim();
      pricings.add(Pricing(
        profile: profile,
        pricing: pricing,
      ));
    }
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
          information.isNotEmpty? information : [],
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
          schedules,
          pricings,
          categoriesId,
          agesId,
          daysId,
          schedulesId,
          sectorsId,
        );
      } else {
        await cultureActivityService.addCultureActivity(
          null,
          discipline,
          information.isNotEmpty ? information : [],
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
          schedules,
          pricings,
          categoriesId,
          agesId,
          daysId,
          schedulesId,
          sectorsId,
        );
      }

      await Future.delayed(Duration(milliseconds: 25));
    
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
        activities = (await sportActivityService.getSportActivities())
          .map((item) => (item).toMap())
          .toList();
      } else {
        activities = (await cultureActivityService.getCultureActivities())
          .map((item) => (item).toMap())
          .toList();
      }

      debugPrint('ReadActivities: $activities');
      
      await Future.delayed(Duration(milliseconds: 25));

      setState(() {
        isLoading = false;
      });
    
    } catch (e) {
      debugPrint('Error fetching activity: $e');
    }
  }

  TextEditingController newDisciplineController = TextEditingController();
  List<TextEditingController> newInformationControllers = [];
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
  List<TextEditingController> newDayControllers = [];
  List<List<TextEditingController>> newStartHourControllersPerDay = [];
  List<List<TextEditingController>> newEndHourControllersPerDay = [];
  List<TextEditingController> newProfileControllers = [];
  List<TextEditingController> newPricingControllers = [];
  List<Map<String, String>> newSelectedSubFiltersByCategories = [];
  List<Map<String, String>> newSelectedSubFiltersByAges = [];
  List<Map<String, String>> newSelectedSubFiltersByDays = [];
  List<Map<String, String>> newSelectedSubFiltersBySchedules = [];
  List<Map<String, String>> newSelectedSubFiltersBySectors = [];

  Future<void> updateActivity({
    required BuildContext context
  }) async {
    String newDiscipline = newDisciplineController.text.trim();
    List<String>? newInformation = [];
    for (int i = 0; i < newInformationControllers.length; i++) {
      String newInformations = newInformationControllers[i].text.trim();
      if (newInformations.isNotEmpty) {
        newInformation.add(newInformations);
      }
    }
    String? newImageUrl = newImageUrlController.text.trim();
    String newStructureName = newStructureNameController.text.trim();
    String? newEmail = newEmailController.text.trim();
    String? newPhoneNumber = newPhoneNumberController.text.trim();
    String? newWebSite = newWebSiteController.text.trim();
    String newTitleAddress = newTitleAddressController.text.trim();
    String newStreetAddress = newStreetAddressController.text.trim();
    int newPostalCode = int.parse(newPostalCodeController.text.trim());
    String newCity = newCityController.text.trim();
    double newLatitude = double.parse(newLatitudeController.text.trim());
    double newLongitude = double.parse(newLongitudeController.text.trim());
    List<Schedule> newSchedules = [];
    for (int d = 0; d < newDayControllers.length; d++) {
      String newDay = newDayControllers[d].text.trim();
      List<TimeSlot> newTimeSlots = [];
      for (int t = 0; t < newStartHourControllersPerDay[d].length; t++) {
        String? newStartHour = newStartHourControllersPerDay[d][t].text.trim();
        String? newEndHour = newEndHourControllersPerDay[d][t].text.trim();
        newTimeSlots.add(TimeSlot(startHour: newStartHour, endHour: newEndHour));
      }
      newSchedules.add(Schedule(day: newDay, timeSlots: newTimeSlots));
    }
    List<Pricing> newPricings = [];
    for (int i = 0; i < newProfileControllers.length; i++) {
      String newProfile = newProfileControllers[i].text.trim();
      String newPricing = newPricingControllers[i].text.trim();
      newPricings.add(Pricing(
        profile: newProfile,
        pricing: newPricing,
      ));
    }
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
          newInformation.isNotEmpty? newInformation : [],
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
          newSchedules,
          newPricings,
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
          newInformation.isNotEmpty ? newInformation : [],
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
          newSchedules,
          newPricings,
          newCategoriesId,
          newAgesId,
          newDaysId,
          newSchedulesId,
          newSectorsId,
        );
      }

      await Future.delayed(Duration(milliseconds: 25));

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

  List<String> selectedActivityIds = [];

  Future<void> deleteActivities({
    required BuildContext context,
    required List<String> activityIds,
  }) async {
    try {
      setState(() {
        isLoading = true;
      });

      if (activityIds.isNotEmpty) {
        if (selectedSection == 0) {
          await sportActivityService.deleteSportActivities(
            activityIds,
          );
        } else {
          await cultureActivityService.deleteCultureActivities(
            activityIds,
          );
        }

        await Future.delayed(Duration(milliseconds: 25));

        setState(() {
          isLoading = false;
        });

        if (context.mounted) {
          CustomSnackBar(
            message: 'Activité(s) supprimée(s)',
            backgroundColor: Colors.green,
          ).showSnackBar(context);
        }
      } else {
        if (context.mounted) {
          CustomSnackBar(
            message: 'Veuillez sélectionner au moins une activité à supprimer',
            backgroundColor: Colors.red,
          ).showSnackBar(context);
        }
      }
    } catch (e) {
      debugPrint('Error deleting activity(ies): $e');

      setState(() {
        isLoading = false;
      });

      if (context.mounted) {
        CustomSnackBar(
          message: 'Echec de la suppression de(s) l\'activité(s)',
          backgroundColor: Colors.red,
        ).showSnackBar(context);
      }
    }
  }

  Future<List<Map<String, dynamic>>> readSubFilters() async {
    setState(() {
      isLoading = true;
    });

    try {
      if (selectedSection == 0) {
        if (selectedFilter == 'Par catégorie') {
          subFilters = (await SportFilterService().getSportCategories())
            .map((item) => (item).toMap())
            .toList();
        } else if (selectedFilter == 'Par âge') {
          subFilters = (await SportFilterService().getSportAges())
            .map((item) => (item).toMap())
            .toList();
        } else if (selectedFilter == 'Par jour') {
          subFilters = (await SportFilterService().getSportDays())
            .map((item) => (item).toMap())
            .toList();
        } else if (selectedFilter == 'Par horaire') {
          subFilters = (await SportFilterService().getSportSchedules())
            .map((item) => (item).toMap())
            .toList();
        } else if (selectedFilter == 'Par secteur') {
          subFilters = (await SportFilterService().getSportSectors())
            .map((item) => (item).toMap())
            .toList();
        }
      } else {
        if (selectedFilter == 'Par catégorie') {
          subFilters = (await CultureFilterService().getCultureCategories())
            .map((item) => (item).toMap())
            .toList();
        } else if (selectedFilter == 'Par âge') {
          subFilters = (await CultureFilterService().getCultureAges())
            .map((item) => (item).toMap())
            .toList();
        } else if (selectedFilter == 'Par jour') {
          subFilters = (await CultureFilterService().getCultureDays())
            .map((item) => (item).toMap())
            .toList();
        } else if (selectedFilter == 'Par horaire') {
          subFilters = (await CultureFilterService().getCultureSchedules())
            .map((item) => (item).toMap())
            .toList();
        } else if (selectedFilter == 'Par secteur') {
          subFilters = (await CultureFilterService().getCultureSectors())
            .map((item) => (item).toMap())
            .toList();
        }
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

  Future<void> updateSelectedSubFilters() async {
    List<String> filters = [
      'Par catégorie',
      'Par âge',
      'Par jour',
      'Par horaire',
      'Par secteur'
    ];

    setState(() {
      isLoading = true;
    });

    try {
      for (String filter in filters) {
        selectedFilter = filter;
        List<Map<String, dynamic>> subFiltersBy = await readSubFilters();

        debugPrint('Sous-filtres pour $filter: $subFiltersBy');

        List<Map<String, dynamic>> newSelectedSubFiltersBy = [];

        switch (filter) {
          case 'Par catégorie':
            newSelectedSubFiltersBy = newSelectedSubFiltersByCategories;
            break;
          case 'Par âge':
            newSelectedSubFiltersBy = newSelectedSubFiltersByAges;
            break;
          case 'Par jour':
            newSelectedSubFiltersBy = newSelectedSubFiltersByDays;
            break;
          case 'Par horaire':
            newSelectedSubFiltersBy = newSelectedSubFiltersBySchedules;
            break;
          case 'Par secteur':
            newSelectedSubFiltersBy = newSelectedSubFiltersBySectors;
            break;
        }

        for (var subFilterBy in subFiltersBy) {
          var index = newSelectedSubFiltersBy.indexWhere((item) => item['id'] == subFilterBy['id']);
          if (index != -1) {
            newSelectedSubFiltersBy[index]['name'] = subFilterBy['name'];
          }
        }
        newSelectedSubFiltersBy.removeWhere((item) => !subFiltersBy.any((subFilterBy) => subFilterBy['id'] == item['id']));
      }
    } catch (e) {
      debugPrint('Error updating selected sub-filters: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<dynamic> sortSubFilters(
    List<Map<String, dynamic>> subFilters,
    String selectedFilter
  ) {
    switch (selectedFilter) {
      case 'Par catégorie':
        subFilters.sort(
          (a,b) => a['name'].compareTo(b['name'])
        );
        break;

      case 'Par âge':
        subFilters.sort(
          (a, b) {
            int minAgeA = _getMinAgeFromAgeRange(a['name']);
            int minAgeB = _getMinAgeFromAgeRange(b['name']);
            return minAgeA.compareTo(minAgeB);
          }
        );
        break;

      case 'Par horaire':
        subFilters.sort(
          (a, b) {
            int startTimeA = _getStartTimeFromSchedule(a['name']);
            int startTimeB = _getStartTimeFromSchedule(b['name']);
            return startTimeA.compareTo(startTimeB);
          }
        );
        break;

      case 'Par jour':
        subFilters.sort(
          (a, b) {
            return _getDayIndex(a['name']).compareTo(_getDayIndex(b['name']));
          }
        );
        break;

      case 'Par secteur':
      subFilters.sort(
        (a, b) => a['name'].compareTo(b['name'])
      );
      break;

      default:
        subFilters.sort(
          (a, b) => a['name'].compareTo(b['name'])
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

  Future<bool> checkImageValidity(String imageUrl) async {
    try {
      final response = await http.head(Uri.parse(imageUrl));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    selectedFilter = 'Par catégorie';
    readSubFilters();
    readActivities();
    addInformationField();
    addDayField();
    addProfilePricing();
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
                color: Colors.white24,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Center(
                  child: SpinKitSpinningLines(
                    color: Colors.black,
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
                      'Gestion des activités',
                      style: TextStyle(
                        fontFamily: 'Satisfy-Regular',
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children : [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: _currentMode == ActivityMode.adding ?
                            [
                              BoxShadow(
                                color: Colors.blueAccent,
                                offset: Offset(8, 8),
                                blurRadius: 6,
                              ),
                            ] :
                            [
                              BoxShadow(
                                color: Colors.black54,
                                offset: Offset(8, 8),
                                blurRadius: 6,
                              ),
                            ],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF5B59B4),
                            foregroundColor: Colors.white,
                            side: BorderSide(
                              color: Color(0xFF5B59B4)
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          ),
                          onPressed: () {
                            setState(() {
                              _currentMode = ActivityMode.adding;
                              readSubFilters();
                              disciplineController.clear();
                              informationControllers.clear();
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
                              dayControllers.clear();
                              startHourControllersPerDay.clear();
                              endHourControllersPerDay.clear();
                              profileControllers.clear();
                              pricingControllers.clear();
                              selectedSubFiltersByCategories.clear();
                              selectedSubFiltersByAges.clear();
                              selectedSubFiltersByDays.clear();
                              selectedSubFiltersBySchedules.clear();
                              selectedSubFiltersBySectors.clear();
                              addInformationField();
                              addDayField();
                              addProfilePricing();
                            });
                          },
                          child: Icon(
                            Icons.add,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color: _currentMode == ActivityMode.editing ? Colors.blueAccent : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: _currentMode == ActivityMode.editing ?
                            [
                              BoxShadow(
                                color: Colors.blueAccent,
                                offset: Offset(8, 8),
                                blurRadius: 6,
                              ),
                            ] :
                            [
                              BoxShadow(
                                color: Colors.black54,
                                offset: Offset(8, 8),
                                blurRadius: 6,
                              ),
                            ],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF5B59B4),
                            foregroundColor: Colors.white,
                            side: BorderSide(color: Color(0xFF5B59B4)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          ),
                          onPressed: () {
                            setState(() {
                              _currentMode = ActivityMode.editing;
                              isEditing = false;
                              readActivities();
                              readSubFilters();
                              activityId = '';
                              newDisciplineController.clear();
                              newInformationControllers.clear();
                              newImageUrlController.clear();
                              newStructureNameController.clear();
                              newEmailController.clear();
                              newPhoneNumberController.clear();
                              newWebSiteController.clear();
                              newTitleAddressController.clear();
                              newStreetAddressController.clear();
                              newPostalCodeController.clear();
                              newCityController.clear();
                              newLatitudeController.clear();
                              newLongitudeController.clear();
                              newDayControllers.clear();
                              newStartHourControllersPerDay.clear();
                              newEndHourControllersPerDay.clear();
                              newProfileControllers.clear();
                              newPricingControllers.clear();
                              newSelectedSubFiltersByCategories.clear();
                              newSelectedSubFiltersByAges.clear();
                              newSelectedSubFiltersByDays.clear();
                              newSelectedSubFiltersBySchedules.clear();
                              newSelectedSubFiltersBySectors.clear();
                            });
                          },
                          child: Icon(
                            Icons.edit,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          color: _currentMode == ActivityMode.deleting ? Colors.blueAccent : Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: _currentMode == ActivityMode.deleting ?
                            [
                              BoxShadow(
                                color: Colors.blueAccent,
                                offset: Offset(8, 8),
                                blurRadius: 6,
                              ),
                            ] :
                            [
                              BoxShadow(
                                color: Colors.black54,
                                offset: Offset(8, 8),
                                blurRadius: 6,
                              ),
                            ],
                        ),
                        child:  ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF5B59B4),
                            foregroundColor: Colors.white,
                            side: BorderSide(color: Color(0xFF5B59B4)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                          ),
                          onPressed: () {
                            setState(() {
                              _currentMode = ActivityMode.deleting;
                              readActivities();
                              selectedActivityIds.clear();
                            });
                          },
                          child: Icon(
                            Icons.remove,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
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

  void addDayField() {
    setState(() {
      dayControllers.add(TextEditingController());
      startHourControllersPerDay.add([TextEditingController()]);
      endHourControllersPerDay.add([TextEditingController()]);
    });
  }

  void removeDayField(int dayIndex) {
    setState(() {
      dayControllers[dayIndex].dispose;
      dayControllers.removeAt(dayIndex);
      for (var controller in startHourControllersPerDay[dayIndex]) {
        controller.dispose();
      }
      startHourControllersPerDay.removeAt(dayIndex);
      for (var controller in endHourControllersPerDay[dayIndex]) {
        controller.dispose();
      }
      endHourControllersPerDay.removeAt(dayIndex);
    });
  }

  void addTimeSlotForDay(int dayIndex) {
    setState(() {
      startHourControllersPerDay[dayIndex].add(TextEditingController());
      endHourControllersPerDay[dayIndex].add(TextEditingController());
    });
  }

  void removeTimeSlotForDay(int dayIndex, int timeSlotIndex) {
    setState(() {
      startHourControllersPerDay[dayIndex][timeSlotIndex].dispose();
      startHourControllersPerDay[dayIndex].removeAt(timeSlotIndex);
      endHourControllersPerDay[dayIndex][timeSlotIndex].dispose();
      endHourControllersPerDay[dayIndex].removeAt(timeSlotIndex);
    });
  }

  void addProfilePricing() {
    setState(() {
      profileControllers.add(TextEditingController());
      pricingControllers.add(TextEditingController());
    });
  }

  void removeProfilePricing(int index) {
    setState(() {
      profileControllers[index].dispose();
      profileControllers.removeAt(index);
      pricingControllers[index].dispose();
      pricingControllers.removeAt(index);
    });
  }

  void addInformationField() {
    setState(() {
      informationControllers.add(TextEditingController());
    });
  }

  void removeInformationField(int infoIndex) {
    setState(() {
      informationControllers[infoIndex].dispose();
      informationControllers.removeAt(infoIndex);
    });
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
                readSubFilters();
                disciplineController.clear();
                informationControllers.clear();
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
                dayControllers.clear();
                startHourControllersPerDay.clear();
                endHourControllersPerDay.clear();
                profileControllers.clear();
                pricingControllers.clear();
                selectedSubFiltersByCategories.clear();
                selectedSubFiltersByAges.clear();
                selectedSubFiltersByDays.clear();
                selectedSubFiltersBySchedules.clear();
                selectedSubFiltersBySectors.clear();
                addInformationField();
                addDayField();
                addProfilePricing();
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
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 1.0),
                child: Center(
                  child: Text(
                    'Sport',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 1.0),
                child: Center(
                  child: Text(
                    'Culture',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
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
            value: selectedSubFilters.isEmpty && subFilters.isNotEmpty ? subFilters[0]['id'] : selectedSubFilters[0],
            onChanged: (String? newValue) {
              setState(() {
                var selectedSubFilter = subFilters.firstWhere(
                  (item) => item['id'] == newValue
                );
                var subFilterMap = {
                  'id': selectedSubFilter['id'].toString(),
                  'name': selectedSubFilter['name'].toString()
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
                value: subFilter['id'],
                child: Text(subFilter['name']),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Text(
            'Par catégorie',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: selectedSubFiltersByCategories.map((subFilter) {
              return Chip(
                label: Text(
                  subFilter['name']!,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                deleteIcon: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
                onDeleted: () {
                  setState(() {
                    selectedSubFiltersByCategories.removeWhere(
                      (item) => item['id'] == subFilter['id']
                    );
                  });
                },
                backgroundColor: Color(0xFF5B59B4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  side: BorderSide(
                    color: Color(0xFF5B59B4)
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical : 10),
              );
            }).toList(),
          ),
          const SizedBox(height: 4),
          Text(
            'Par âge',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: selectedSubFiltersByAges.map((subFilter) {
              return Chip(
                label: Text(
                  subFilter['name']!,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                deleteIcon: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
                onDeleted: () {
                  setState(() {
                    selectedSubFiltersByAges.removeWhere(
                      (item) => item['id'] == subFilter['id']
                    );
                  });
                },
                backgroundColor: Color(0xFF5B59B4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  side: BorderSide(
                    color: Color(0xFF5B59B4)
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical : 10),
              );
            }).toList(),
          ),
          const SizedBox(height: 4),
          Text(
            'Par jour',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: selectedSubFiltersByDays.map((subFilter) {
              return Chip(
                label: Text(
                  subFilter['name']!,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                deleteIcon: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
                onDeleted: () {
                  setState(() {
                    selectedSubFiltersByDays.removeWhere(
                      (item) => item['id'] == subFilter['id']
                    );
                  });
                },
                backgroundColor: Color(0xFF5B59B4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  side: BorderSide(
                    color: Color(0xFF5B59B4)
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical : 10),
              );
            }).toList(),
          ),
          const SizedBox(height: 4),
          Text(
            'Par horaire',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: selectedSubFiltersBySchedules.map((subFilter) {
              return Chip(
                label: Text(
                  subFilter['name']!,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                deleteIcon: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
                onDeleted: () {
                  setState(() {
                    selectedSubFiltersBySchedules.removeWhere(
                      (item) => item['id'] == subFilter['id']
                    );
                  });
                },
                backgroundColor: Color(0xFF5B59B4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  side: BorderSide(
                    color: Color(0xFF5B59B4)
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical : 10),
              );
            }).toList(),
          ),
          const SizedBox(height: 4),
          Text(
            'Par secteur',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: selectedSubFiltersBySectors.map((subFilter) {
              return Chip(
                label: Text(
                  subFilter['name']!,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                deleteIcon: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
                onDeleted: () {
                  setState(() {
                    selectedSubFiltersBySectors.removeWhere(
                      (item) => item['id'] == subFilter['id']
                    );
                  });
                },
                backgroundColor: Color(0xFF5B59B4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  side: BorderSide(
                    color: Color(0xFF5B59B4)
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical : 10),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.98,
            child: TextFormField(
              controller: disciplineController,
              decoration: InputDecoration(
                labelText: 'Discipline',
                hintText: 'Ex: Course à pied',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
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
          ListView.builder(
            shrinkWrap: true,
            itemCount: informationControllers.length,
            itemBuilder: (context, infoIndex) {
              return Column(
                children: [
                  if (informationControllers.length > 1)
                    SizedBox(height: 16),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.98,
                    child: TextFormField(
                      controller: informationControllers[infoIndex],
                      decoration: InputDecoration(
                        labelText: 'Information (optionnel)',
                        hintText: 'Ex: Amenez votre bouteille d\'eau',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ),
                  if (informationControllers.length > 1)
                    SizedBox(height: 16),
                  if (informationControllers.length > 1)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.red,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: () {
                        removeInformationField(infoIndex);
                      },
                      child: Text('Supprimer cette information',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              side: BorderSide(
                color: Colors.lightGreen,
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            onPressed: addInformationField,
            child: Text('Ajouter une information',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.98,
            child: TextFormField(
              controller: imageUrlController,
              decoration: InputDecoration(
                labelText: 'Image Url (optionnel)',
                hintText: 'Ex: https://www.example.com/image.jpg',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          const SizedBox(height: 16),
          FutureBuilder<bool>(
            key: ValueKey(imageUrlController.text),
            future: Future.delayed(const Duration(seconds: 1))
              .then((_) => checkImageValidity(imageUrlController.text)),
            builder:(context, snapshot) {
              if (snapshot.hasError || !snapshot.hasData || snapshot.data == false || imageUrlController.text.isEmpty) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF5B59B4),
                        width: 4,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.asset(
                        'assets/images/ActivityByDefault.webp',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              }
              return ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF5B59B4),
                      width: 4,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.network(
                      imageUrlController.text,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          ExpansionTile(
            title: Text(
              'Contact',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.98,
                child: TextFormField(
                  controller: structureNameController,
                  decoration: InputDecoration(
                    labelText: 'Nom de la structure/du responsable',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un nom de structure/du responsable';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.98,
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email (optionnel)',
                    hintText: 'Ex: abc@exemple.com',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null;
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
                width: MediaQuery.of(context).size.width * 0.98,
                child: TextFormField(
                  controller: phoneNumberController,
                  decoration: InputDecoration(
                    labelText: 'Numéro de téléphone (optionnel)',
                    hintText: 'Ex: 01 23 45 67 89/+33 1 23 45 67 89',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null;
                    }

                    final regex = RegExp(
                      r'^(?:\+33[\s]?[1-9](?:[\s]?\d{2}){4}|\d{10}|\d{2}[\s]?\d{2}[\s]?\d{2}[\s]?\d{2}[\s]?\d{2})$',
                      caseSensitive: false,
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
                width: MediaQuery.of(context).size.width * 0.98,
                child: TextFormField(
                  controller: webSiteController,
                  decoration: InputDecoration(
                    labelText: 'Site internet (optionnel)',
                    hintText: 'Ex: https://www.example.com',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null;
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
                color: Colors.black,
              ),
            ),
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.98,
                child: TextFormField(
                  controller: titleAddressController,
                  decoration: InputDecoration(
                    labelText: 'Intitulé d\'adresse',
                    hintText: 'Ex: Stade Maurice Postaire',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
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
                width: MediaQuery.of(context).size.width * 0.98,
                child: TextFormField(
                  controller: streetAddressController,
                  decoration: InputDecoration(
                    labelText: 'N° et/ou nom de rue',
                    hintText: 'Ex: 18 rue Pierre de Coubertin',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
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
                width: MediaQuery.of(context).size.width * 0.98,
                child: TextFormField(
                  controller: postalCodeController,
                  decoration: InputDecoration(
                    labelText: 'Code postal',
                    hintText: 'Ex: 50100',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
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
                width: MediaQuery.of(context).size.width * 0.98,
                child: TextFormField(
                  controller: cityController,
                  decoration: InputDecoration(
                    labelText: 'Ville',
                    hintText: 'Ex: Cherbourg-en-Cotentin',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
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
                width: MediaQuery.of(context).size.width * 0.98,
                child: TextFormField(
                  controller: latitudeController,
                  decoration: InputDecoration(
                    labelText: 'Latitude Google Maps',
                    hintText: 'Ex: 49.64358701909363',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
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
                width: MediaQuery.of(context).size.width * 0.98,
                child: TextFormField(
                  controller: longitudeController,
                  decoration: InputDecoration(
                    labelText: 'Longitude Google Maps',
                    hintText: 'Ex: -1.638480195782405',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
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
                color: Colors.black,
              ),
            ),
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: dayControllers.length,
                itemBuilder: (context, dayIndex) {
                  return Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.98,
                        child: TextFormField(
                          controller: dayControllers[dayIndex],
                          decoration: InputDecoration(
                            labelText: 'Jour',
                            hintText: 'Ex: Mercredi',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer un jour';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      if (dayControllers.length > 1)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            side: BorderSide(
                              color: Colors.red,
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          onPressed: () {
                            removeDayField(dayIndex);
                          },
                          child: Text(
                            'Supprimer cette journée',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (dayControllers.length > 1)
                        SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: startHourControllersPerDay[dayIndex].length,
                        itemBuilder: (context, timeSlotIndex) {
                          return Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.98,
                                child: TextFormField(
                                  controller: startHourControllersPerDay[dayIndex][timeSlotIndex],
                                  decoration: InputDecoration(
                                    labelText: 'Horaire de début (optionnel)',
                                    hintText: 'Ex: 10h, 10h30',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return null;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(height: 16),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.98,
                                child: TextFormField(
                                  controller: endHourControllersPerDay[dayIndex][timeSlotIndex],
                                  decoration: InputDecoration(
                                    labelText: 'Horaire de fin (optionnel)',
                                    hintText: 'Ex: 11h, 11h30',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return null;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(height: 16),
                              if (startHourControllersPerDay[dayIndex].length > 1)
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    foregroundColor: Colors.white,
                                    side: BorderSide(
                                      color: Colors.red,
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    removeTimeSlotForDay(dayIndex, timeSlotIndex);
                                  },
                                  child: Text('Supprimer ce créneau',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              if (startHourControllersPerDay[dayIndex].length > 1)
                                SizedBox(height: 16),
                            ],
                          );
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            side: BorderSide(
                              color: Colors.lightGreen,
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        onPressed: () {
                          addTimeSlotForDay(dayIndex);
                        },
                        child: Text('Ajouter un créneau',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  );
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  side: BorderSide(
                    color: Colors.lightGreen,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: () {
                  addDayField();
                },
                child: Text('Ajouter une journée',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
          ExpansionTile(
            title: Text(
              'Tarifs et profils',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: profileControllers.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.98,
                        child: TextFormField(
                          controller: profileControllers[index],
                          decoration: InputDecoration(
                            labelText: 'Profil',
                            hintText: 'Ex: Débutants',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
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
                        width: MediaQuery.of(context).size.width * 0.98,
                        child: TextFormField(
                          controller: pricingControllers[index],
                          decoration: InputDecoration(
                            labelText: 'Prix',
                            hintText: 'Ex: 10€, 10€50',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer un prix';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      if (profileControllers.length > 1)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            side: BorderSide(
                              color: Colors.red,
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          onPressed: () {
                            removeProfilePricing(index);
                          },
                          child: Text('Supprimer ce tarif par profil',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (profileControllers.length > 1)
                        SizedBox(height: 16),
                    ],
                  );
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  side: BorderSide(
                    color: Colors.lightGreen,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onPressed: addProfilePricing,
                child: Text('Ajouter un tarif par profil',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF5B59B4),
              foregroundColor: Colors.white,
              side: BorderSide(
                color: Color(0xFF5B59B4),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            onPressed: () {
              if (_addActivityKey.currentState!.validate()) {
                createNewActivity(
                  context: context,
                );
                readSubFilters();
                disciplineController.clear();
                informationControllers.clear();
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
                dayControllers.clear();
                startHourControllersPerDay.clear();
                endHourControllersPerDay.clear();
                profileControllers.clear();
                pricingControllers.clear();
                selectedSubFiltersByCategories.clear();
                selectedSubFiltersByAges.clear();
                selectedSubFiltersByDays.clear();
                selectedSubFiltersBySchedules.clear();
                selectedSubFiltersBySectors.clear();
                addInformationField();
                addDayField();
                addProfilePricing();
              }
            },
            child: Text('Ajouter l\'activité',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 32),
          ),
        ],
      ),
    );
  }

  void addNewDayField() {
    setState(() {
      newDayControllers.add(TextEditingController());
      newStartHourControllersPerDay.add([TextEditingController()]);
      newEndHourControllersPerDay.add([TextEditingController()]);    
    });
  }

  void removeNewDayField(int newDayIndex) {
    setState(() {
      newDayControllers.removeAt(newDayIndex);
      newStartHourControllersPerDay.removeAt(newDayIndex);
      newEndHourControllersPerDay.removeAt(newDayIndex);      
    });
  }

  void addNewTimeSlotForDay(int newDayIndex) {
    setState(() {
      newStartHourControllersPerDay[newDayIndex].add(TextEditingController());
      newEndHourControllersPerDay[newDayIndex].add(TextEditingController());      
    });
  }

  void removeNewTimeSlotForDay(int newDayIndex, int newTimeSlotIndex) {
    setState(() {
      newStartHourControllersPerDay[newDayIndex].removeAt(newTimeSlotIndex);
      newEndHourControllersPerDay[newDayIndex].removeAt(newTimeSlotIndex);     
    });
  }

  void addNewProfilePricing() {
    setState(() {
      newProfileControllers.add(TextEditingController());
      newPricingControllers.add(TextEditingController());
    });
  }

  void removeNewProfilePricing(int newIndex) {
    setState(() {
      newProfileControllers.removeAt(newIndex);
      newPricingControllers.removeAt(newIndex);
    });
  }

  void addNewInformationField() {
    setState(() {
      newInformationControllers.add(TextEditingController());
    });
  }

  void removeNewInformationField(int newInfoIndex) {
    setState(() {
      newInformationControllers[newInfoIndex].dispose();
      newInformationControllers.removeAt(newInfoIndex);
    });
  }

  Widget _buildEditActivity(
    BuildContext context
  ) {
    return isEditing ?
      Form(
        key: _editActivityKey,
        child: Column(
          children: [
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
              value: selectedSubFilters.isEmpty && subFilters.isNotEmpty ? subFilters[0]['id'] : selectedSubFilters,
              onChanged: (String? newValue) {
                setState(() {
                  var selectedSubFilter = subFilters.firstWhere(
                    (item) => item['id'] == newValue
                  );
                  var subFilterMap = {
                    'id': selectedSubFilter['id'].toString(),
                    'name': selectedSubFilter['name'].toString()
                  };

                  if (selectedFilter == 'Par catégorie') {
                    if (!newSelectedSubFiltersByCategories.any(
                      (item) => item['id'] == newValue)
                    ) {
                      newSelectedSubFiltersByCategories.add(subFilterMap);
                    }
                  }
                  if (selectedFilter == 'Par âge') {
                    if (!newSelectedSubFiltersByAges.any(
                      (item) => item['id'] == newValue)
                    ) {
                      newSelectedSubFiltersByAges.add(subFilterMap);
                    }
                  }
                  if (selectedFilter == 'Par jour') {
                    if (!newSelectedSubFiltersByDays.any(
                      (item) => item['id'] == newValue)
                    ) {
                      newSelectedSubFiltersByDays.add(subFilterMap);
                    }
                  }
                  if (selectedFilter == 'Par horaire') {
                    if (!newSelectedSubFiltersBySchedules.any(
                      (item) => item['id'] == newValue)
                    ) {
                      newSelectedSubFiltersBySchedules.add(subFilterMap);
                    }
                  }
                  if (selectedFilter == 'Par secteur') {
                    if (!newSelectedSubFiltersBySectors.any(
                      (item) => item['id'] == newValue)
                    ) {
                      newSelectedSubFiltersBySectors.add(subFilterMap);
                    }
                  }
                });
              },
              items: sortSubFilters(
                subFilters, selectedFilter
              ).map((subFilter) {
                return DropdownMenuItem<String>(
                  value: subFilter['id'],
                  child: Text(subFilter['name']),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Text(
              'Par catégorie',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: newSelectedSubFiltersByCategories.map((subFilter) {
                return Chip(
                  label: Text(
                    subFilter['name']!,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  deleteIcon: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 20,
                  ),
                  onDeleted: () {
                    setState(() {
                      newSelectedSubFiltersByCategories.removeWhere(
                        (item) => item['id'] == subFilter['id']
                      );
                    });
                  },
                  backgroundColor: Color(0xFF5B59B4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(
                      color: Color(0xFF5B59B4)
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical : 10),
                );
              }).toList(),
            ),
            const SizedBox(height: 4),
            Text(
              'Par âge',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: newSelectedSubFiltersByAges.map((subFilter) {
                return Chip(
                  label: Text(
                    subFilter['name']!,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  deleteIcon: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 20,
                  ),
                  onDeleted: () {
                    setState(() {
                      newSelectedSubFiltersByAges.removeWhere(
                        (item) => item['id'] == subFilter['id']
                      );
                    });
                  },
                  backgroundColor: Color(0xFF5B59B4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(
                      color: Color(0xFF5B59B4)
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical : 10),
                );
              }).toList(),
            ),
            const SizedBox(height: 4),
            Text(
              'Par jour',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: newSelectedSubFiltersByDays.map((subFilter) {
                return Chip(
                  label: Text(
                    subFilter['name']!,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  deleteIcon: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 20,
                  ),
                  onDeleted: () {
                    setState(() {
                      newSelectedSubFiltersByDays.removeWhere(
                        (item) => item['id'] == subFilter['id']
                      );
                    });
                  },
                  backgroundColor: Color(0xFF5B59B4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(
                      color: Color(0xFF5B59B4)
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical : 10),
                );
              }).toList(),
            ),
            const SizedBox(height: 4),
            Text(
              'Par horaire',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: newSelectedSubFiltersBySchedules.map((subFilter) {
                return Chip(
                  label: Text(
                    subFilter['name']!,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  deleteIcon: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 20,
                  ),
                  onDeleted: () {
                    setState(() {
                      newSelectedSubFiltersBySchedules.removeWhere(
                        (item) => item['id'] == subFilter['id']
                      );
                    });
                  },
                  backgroundColor: Color(0xFF5B59B4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(
                      color: Color(0xFF5B59B4)
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical : 10),
                );
              }).toList(),
            ),
            const SizedBox(height: 4),
            Text(
              'Par secteur',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: newSelectedSubFiltersBySectors.map((subFilter) {
                return Chip(
                  label: Text(
                    subFilter['name']!,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  deleteIcon: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 20,
                  ),
                  onDeleted: () {
                    setState(() {
                      newSelectedSubFiltersBySectors.removeWhere(
                        (item) => item['id'] == subFilter['id']
                      );
                    });
                  },
                  backgroundColor: Color(0xFF5B59B4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(
                      color: Color(0xFF5B59B4)
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical : 10),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF5B59B4),
                foregroundColor: Colors.white,
                side: BorderSide(
                  color: Color(0xFF5B59B4)
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
              onPressed: () async {
                updateSelectedSubFilters();
              },
              child: isLoading ?
                CircularProgressIndicator() :
                Text(
                  'Mettre à jour les filtres',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.98,
              child: TextFormField(
              controller: newDisciplineController,
                decoration: InputDecoration(
                  labelText: 'Nouvelle discipline',
                  hintText: 'Ex: Course à pied',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
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
            ListView.builder(
              shrinkWrap: true,
              itemCount: newInformationControllers.length,
              itemBuilder: (context, newInfoIndex) {
                return Column(
                  children: [
                    if (newInformationControllers.length > 1)
                      SizedBox(height: 16),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.98,
                      child: TextFormField(
                        controller: newInformationControllers[newInfoIndex],
                        decoration: InputDecoration(
                          labelText: 'Nouvelle information (optionnel)',
                          hintText: 'Ex: Amenez votre bouteille d\'eau',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                      ),
                    ),
                    if (newInformationControllers.length > 1)
                      SizedBox(height: 16),
                    if (newInformationControllers.length > 1)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.red,
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        onPressed: () {
                          removeNewInformationField(newInfoIndex);
                        },
                        child: Text('Supprimer cette information',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                side: BorderSide(
                  color: Colors.lightGreen,
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              onPressed: addNewInformationField,
              child: Text('Ajouter une information',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.98,
              child: TextFormField(
                controller: newImageUrlController,
                decoration: InputDecoration(
                  labelText: 'Nouvelle image Url (optionnel)',
                  hintText: 'Ex: https://www.example.com/image.jpg',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            const SizedBox(height: 16),
            FutureBuilder<bool>(
              key: ValueKey(newImageUrlController.text),
              future: Future.delayed(const Duration(seconds: 1))
                .then((_) => checkImageValidity(newImageUrlController.text)),
              builder:(context, snapshot) {
                if (snapshot.hasError || !snapshot.hasData || snapshot.data == false || newImageUrlController.text.isEmpty) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF5B59B4),
                          width: 4,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.asset(
                          'assets/images/ActivityByDefault.webp',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }
                return ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF5B59B4),
                        width: 4,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.network(
                        newImageUrlController.text,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            ExpansionTile(
              title: Text(
                'Contact',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.98,
                  child: TextFormField(
                    controller: newStructureNameController,
                    decoration: InputDecoration(
                      labelText: 'Nouveau nom de la structure/du responsable',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un nom de structure/du responsable';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.98,
                  child: TextFormField(
                    controller: newEmailController,
                    decoration: InputDecoration(
                      labelText: 'Nouvel email (optionnel)',
                      hintText: 'Ex: abc@exemple.com',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return null;
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
                  width: MediaQuery.of(context).size.width * 0.98,
                  child: TextFormField(
                    controller: newPhoneNumberController,
                    decoration: InputDecoration(
                      labelText: 'Nouveau numéro de téléphone (optionnel)',
                      hintText: 'Ex: 01 23 45 67 89/+33 1 23 45 67 89',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return null;
                      }

                      final regex = RegExp(
                        r'^(?:\+33[\s]?[1-9](?:[\s]?\d{2}){4}|\d{10}|\d{2}[\s]?\d{2}[\s]?\d{2}[\s]?\d{2}[\s]?\d{2})$',
                        caseSensitive: false,
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
                  width: MediaQuery.of(context).size.width * 0.98,
                  child: TextFormField(
                    controller: newWebSiteController,
                    decoration: InputDecoration(
                      labelText: 'Nouveau site internet (optionnel)',
                      hintText: 'Ex: https://www.example.com',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return null;
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
                  color: Colors.black,
                ),
              ),
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.98,
                  child: TextFormField(
                    controller: newTitleAddressController,
                    decoration: InputDecoration(
                      labelText: 'Nouvel intitulé d\'adresse',
                      hintText: 'Ex: Stade Maurice Postaire',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
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
                  width: MediaQuery.of(context).size.width * 0.98,
                  child: TextFormField(
                    controller: newStreetAddressController,
                    decoration: InputDecoration(
                      labelText: 'Nouveau(x) N° et/ou nom de rue',
                      hintText: 'Ex: 18 rue Pierre de Coubertin',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
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
                  width: MediaQuery.of(context).size.width * 0.98,
                  child: TextFormField(
                    controller: newPostalCodeController,
                    decoration: InputDecoration(
                      labelText: 'Nouveau code postal',
                      hintText: 'Ex: 50100',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
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
                  width: MediaQuery.of(context).size.width * 0.98,
                  child: TextFormField(
                    controller: newCityController,
                    decoration: InputDecoration(
                      labelText: 'Nouvelle ville',
                      hintText: 'Ex: Cherbourg-en-Cotentin',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
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
                  width: MediaQuery.of(context).size.width * 0.98,
                  child: TextFormField(
                    controller: newLatitudeController,
                    decoration: InputDecoration(
                      labelText: 'Nouvelle latitude Google Maps',
                      hintText: 'Ex: 49.64358701909363',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
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
                  width: MediaQuery.of(context).size.width * 0.98,
                  child: TextFormField(
                    controller: newLongitudeController,
                    decoration: InputDecoration(
                      labelText: 'Nouvelle longitude Google Maps',
                      hintText: 'Ex: -1.638480195782405',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
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
                  color: Colors.black,
                ),
              ),
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: newDayControllers.length,
                  itemBuilder: (context, newDayIndex) {
                    return Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.98,
                          child: TextFormField(
                            controller: newDayControllers[newDayIndex],
                            decoration: InputDecoration(
                              labelText: 'Nouveau jour',
                              hintText: 'Ex: Mercredi',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer un jour';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 16),
                        if (newDayControllers.length > 1)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                color: Colors.red,
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            onPressed: () {
                              removeNewDayField(newDayIndex);
                            },
                            child: Text('Supprimer cette journée',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (newDayControllers.length > 1)
                          SizedBox(height: 16),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: newStartHourControllersPerDay[newDayIndex].length,
                          itemBuilder: (context, newTimeSlotIndex) {
                            return Column(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.98,
                                  child: TextFormField(
                                    controller: newStartHourControllersPerDay[newDayIndex][newTimeSlotIndex],
                                    decoration: InputDecoration(
                                      labelText: 'Nouvel horaire de début (optionnel)',
                                      hintText: 'Ex: 10h, 10h30',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return null;
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(height: 16),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.98,
                                  child: TextFormField(
                                    controller: newEndHourControllersPerDay[newDayIndex][newTimeSlotIndex],
                                    decoration: InputDecoration(
                                      labelText: 'Nouvel horaire de fin (optionnel)',
                                      hintText: 'Ex: 11h, 11h30',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return null;
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(height: 16),
                                if (newStartHourControllersPerDay[newDayIndex].length > 1)
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      foregroundColor: Colors.white,
                                      side: BorderSide(
                                        color: Colors.red,
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      removeNewTimeSlotForDay(newDayIndex, newTimeSlotIndex);
                                    },
                                    child: Text('Supprimer ce créneau',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                if (newStartHourControllersPerDay[newDayIndex].length > 1)
                                  SizedBox(height: 16),
                              ],
                            );
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                color: Colors.lightGreen,
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          onPressed: () {
                            addNewTimeSlotForDay(newDayIndex);
                          },
                          child: Text('Ajouter un créneau',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                      ],
                    );
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    side: BorderSide(
                      color: Colors.lightGreen,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: () {
                    addNewDayField();
                  },
                  child: Text('Ajouter une journée',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
            ExpansionTile(
              title: Text(
                'Tarifs et profils',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: newProfileControllers.length,
                  itemBuilder: (context, newIndex) {
                    return Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.98,
                          child: TextFormField(
                            controller: newProfileControllers[newIndex],
                            decoration: InputDecoration(
                              labelText: 'Nouveau profil',
                              hintText: 'Ex: Débutants',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
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
                          width: MediaQuery.of(context).size.width * 0.98,
                          child: TextFormField(
                            controller: newPricingControllers[newIndex],
                            decoration: InputDecoration(
                              labelText: 'Nouveau prix',
                              hintText: 'Ex: 10€, 10€50',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
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
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            side: BorderSide(
                              color: Colors.red,
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          onPressed: () {
                            removeNewProfilePricing(newIndex);
                          },
                          child: Text('Supprimer ce tarif par profil',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (newProfileControllers.length > 1)
                          SizedBox(height: 16),
                      ],
                    );
                  },
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    side: BorderSide(
                      color: Colors.lightGreen,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  onPressed: addNewProfilePricing,
                  child: Text('Ajouter un tarif par profil',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF5B59B4),
                foregroundColor: Colors.white,
                side: BorderSide(
                  color: Color(0xFF5B59B4),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              onPressed: () {
                if (_editActivityKey.currentState!.validate()) {
                  updateActivity(
                    context: context,
                  );
                  activityId = '';
                  newDisciplineController.clear();
                  newInformationControllers.clear();
                  newImageUrlController.clear();
                  newStructureNameController.clear();
                  newEmailController.clear();
                  newPhoneNumberController.clear();
                  newWebSiteController.clear();
                  newTitleAddressController.clear();
                  newStreetAddressController.clear();
                  newPostalCodeController.clear();
                  newCityController.clear();
                  newLatitudeController.clear();
                  newLongitudeController.clear();
                  newDayControllers.clear();
                  newStartHourControllersPerDay.clear();
                  newEndHourControllersPerDay.clear();
                  newProfileControllers.clear();
                  newPricingControllers.clear();
                  newSelectedSubFiltersByCategories.clear();
                  newSelectedSubFiltersByAges.clear();
                  newSelectedSubFiltersByDays.clear();
                  newSelectedSubFiltersBySchedules.clear();
                  newSelectedSubFiltersBySectors.clear();
                  readActivities();
                  isEditing = false;
                }
              },
              child: Text('Modifier l\'activité',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF5B59B4),
                foregroundColor: Colors.white,
                side: BorderSide(
                  color: Color(0xFF5B59B4),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              onPressed: () {
                setState(() {
                  isEditing = false;
                  readActivities();
                  activityId = '';
                  newDisciplineController.clear();
                  newInformationControllers.clear();
                  newImageUrlController.clear();
                  newStructureNameController.clear();
                  newEmailController.clear();
                  newPhoneNumberController.clear();
                  newWebSiteController.clear();
                  newTitleAddressController.clear();
                  newStreetAddressController.clear();
                  newPostalCodeController.clear();
                  newCityController.clear();
                  newLatitudeController.clear();
                  newLongitudeController.clear();
                  newDayControllers.clear();
                  newStartHourControllersPerDay.clear();
                  newEndHourControllersPerDay.clear();
                  newProfileControllers.clear();
                  newPricingControllers.clear();
                  newSelectedSubFiltersByCategories.clear();
                  newSelectedSubFiltersByAges.clear();
                  newSelectedSubFiltersByDays.clear();
                  newSelectedSubFiltersBySchedules.clear();
                  newSelectedSubFiltersBySectors.clear();
                });
              },
              child: Text('Retour à la liste',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 32),
            ),
          ],
        ),
      ) :
      Column(
        children: [
          ToggleButtons(
            isSelected: [selectedSection == 0, selectedSection == 1],
            onPressed: (int section) {
              setState(() {
                selectedSection = section;
                readActivities();
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
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 1.0),
                child: Center(
                  child: Text(
                    'Sport',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )
                  )
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 1.0),
                child: Center(
                  child: Text(
                    'Culture',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )
                  )
                ),
              ),
            ],  
          ),
          const SizedBox(height: 16),
          Column(
            children: activities.map((activity) {
              Place place = Place.fromMap(activity['place'] ?? {});
              List<Schedule> schedules = (activity['schedules'] as List?)
                ?.map((schedule) => Schedule.fromMap(schedule as Map<String, dynamic>))
                .toList() ?? [];
              List<Pricing> pricings = (activity['pricings'] as List?)
                ?.map((pricing) => Pricing.fromMap(pricing as Map<String, String>))
                .toList() ?? [];

              return Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.98,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black54,
                            offset: Offset(4, 4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: ActivityCard(
                        imageUrl: activity['imageUrl'] ?? '',
                        discipline: activity['discipline'] ?? '',
                        place: place,
                        schedules: schedules,
                        pricings: pricings,
                        onTap: () {
                          readActivities();
                          activityId = activity['activityId'] ?? '';
                          newDisciplineController.text = activity['discipline'] ?? '';
                          if (activity['information'] != null) {
                            for (var info in activity['information']!) {
                              newInformationControllers.add(TextEditingController(text: info ?? ''));
                            }
                          }
                          newImageUrlController.text = activity['imageUrl'] ?? '';
                          newStructureNameController.text = activity['contact']?['structureName'] ?? '';
                          newEmailController.text = activity['contact']?['email'] ?? '';
                          newPhoneNumberController.text = activity['contact']?['phoneNumber'] ?? '';
                          newWebSiteController.text = activity['contact']?['webSite'] ?? '';
                          newTitleAddressController.text = activity['place']?['titleAddress'] ?? '';
                          newStreetAddressController.text = activity['place']?['streetAddress'] ?? '';
                          newPostalCodeController.text = activity['place']?['postalCode']?.toString() ?? '00000';
                          newCityController.text = activity['place']?['city'] ?? '';
                          newLatitudeController.text = activity['place']?['latitude']?.toString() ?? '0.0';
                          newLongitudeController.text = activity['place']?['longitude']?.toString() ?? '0.0';
                          
                          for (var schedule in activity['schedules'] ?? []) {
                            newDayControllers.add(TextEditingController(text:schedule['day'] ?? ''));
                            List<TextEditingController> newStartHourControllers = [];
                            List<TextEditingController> newEndHourControllers = [];

                            for (var timeSlot in schedule['timeSlots'] ?? []) {
                              newStartHourControllers.add(TextEditingController(text: timeSlot['startHour'] ?? ''));
                              newEndHourControllers.add(TextEditingController(text: timeSlot['endHour'] ?? ''));
                            }

                            newStartHourControllersPerDay.add(newStartHourControllers);
                            newEndHourControllersPerDay.add(newEndHourControllers);
                          }

                          for (var pricing in activity['pricings'] ?? []) {
                            newProfileControllers.add(TextEditingController(text: pricing['profile'] ?? ''));
                            newPricingControllers.add(TextEditingController(text: pricing['pricing'] ?? ''));
                          }
                          
                          newSelectedSubFiltersByCategories = (activity['filters']?['categoriesId'] as List? ?? [])
                            .map<Map<String, String>>((item) => {
                              'id': item['id'] ?? '',
                              'name': item['name'] ?? '',
                            }).toList();
                          newSelectedSubFiltersByAges = (activity['filters']?['agesId'] as List? ?? [])
                            .map<Map<String, String>>((item) => {
                              'id': item['id'] ?? '',
                              'name': item['name'] ?? '',
                            }).toList();
                          newSelectedSubFiltersByDays = (activity['filters']?['daysId'] as List? ?? [])
                            .map<Map<String, String>>((item) => {
                              'id': item['id'] ?? '',
                              'name': item['name'] ?? '',
                            }).toList();
                          newSelectedSubFiltersBySchedules = (activity['filters']?['schedulesId'] as List? ?? [])
                            .map<Map<String, String>>((item) => {
                              'id': item['id'] ?? '',
                              'name': item['name'] ?? '',
                            }).toList();
                          newSelectedSubFiltersBySectors = (activity['filters']?['sectorsId'] as List? ?? [])
                            .map<Map<String, String>>((item) => {
                              'id': item['id'] ?? '',
                              'name': item['name'] ?? '',
                            }).toList();
                          isEditing = true;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ]
              );
            }).toList(),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 16),
          ),
        ],
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
                readActivities();
                selectedActivityIds.clear();
              });
            },
            color: Colors.black,
            selectedColor: Colors.white,
            fillColor: Color(0xFF5B59B4),
            borderColor: Color(0xFF5B59B4),
            selectedBorderColor: Color(0xFF5B59B4),
            borderRadius: BorderRadius.circular(30),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 1.0),
                child: Center(
                  child: Text('Sport')
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 1.0),
                child: Center(
                  child: Text('Culture')
                ),
              ),
            ],  
          ),
          const SizedBox(height: 16),
          Column(
            children: activities.map((activity) {
              Place place = Place.fromMap(activity['place'] ?? {});
              List<Schedule> schedules = (activity['schedules'] as List?)
                ?.map((schedule) => Schedule.fromMap(schedule as Map<String, dynamic>))
                .toList() ?? [];
              List<Pricing> pricings = (activity['pricings'] as List?)
                ?.map((pricing) => Pricing.fromMap(pricing as Map<String, String>))
                .toList() ?? [];
              bool isSelected = selectedActivityIds.contains(activity['activityId']);

              return Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.98,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blueAccent : Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: isSelected ?
                          [
                            BoxShadow(
                              color: Colors.blueAccent,
                              offset: Offset(4, 4),
                              blurRadius: 6,
                            ),
                          ] :
                          [
                            BoxShadow(
                              color: Colors.black54,
                              offset: Offset(4, 4),
                              blurRadius: 6,
                            ),
                          ],
                      ),
                      child: ActivityCard(
                        imageUrl: activity['imageUrl'] ?? '',
                        discipline: activity['discipline'] ?? '',
                        place: place,
                        schedules: schedules,
                        pricings: pricings,
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedActivityIds.remove(activity['activityId']);
                            } else {
                              selectedActivityIds.add(activity['activityId']);
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF5B59B4),
              foregroundColor: Colors.white,
              side: BorderSide(
                color: Color(0xFF5B59B4),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            onPressed: () {
              if (_deleteActivityKey.currentState!.validate()) {
                deleteActivities(
                  context: context,
                  activityIds: selectedActivityIds,
                );
                readActivities();
                selectedActivityIds.clear();
              }
            },
            child: Text('Supprimer l\'activité',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 16),
          ),
        ],
      )
    );
  }
}