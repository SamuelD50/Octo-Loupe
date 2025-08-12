import 'package:flutter/material.dart';
import 'package:octoloupe/providers/filter_provider.dart';
import 'package:octoloupe/services/culture_activity_service.dart';
import 'package:octoloupe/services/sport_activity_service.dart';
import 'package:provider/provider.dart';

class ActivitiesProvider extends ChangeNotifier {
  int _selectedSection = 0;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  final SportActivityService sportActivityService = SportActivityService();
  final CultureActivityService cultureActivityService = CultureActivityService();
  List<Map<String, dynamic>> _activities = [];
  List<Map<String, dynamic>> get activities => _activities;

  //Get activities
  Future<void> readActivities(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      final selectedSection = Provider.of<FilterProvider>(context, listen: false).selectedSection;

      if (selectedSection == 0) {
        _activities = (await sportActivityService.getSportActivities())
          .map((item) => (item).toMap())
          .toList();
      } else {
        _activities = (await cultureActivityService.getCultureActivities())
          .map((item) => (item).toMap())
          .toList();
      }
    } catch (e) {
      throw Exception('Error fetching activity: $e');
    } finally {
      await Future.delayed(Duration(milliseconds: 25));
      _isLoading = false;
      notifyListeners();
    }
  }

  //Get all activities before filtering by keyword
  Future<void> readAllActivities() async {
    try {
      _isLoading = true;

      List<Map<String, dynamic>> sportActivities = (await sportActivityService.getSportActivities())
        .map((item) => (item).toMap())
        .toList();

      List<Map<String, dynamic>> cultureActivities = (await cultureActivityService.getCultureActivities())
        .map((item) => (item).toMap())
        .toList();

      _activities = [...sportActivities, ...cultureActivities];
    } catch (e) {
      debugPrint('Error fetching activities: $e');
    } finally {
      await Future.delayed(Duration(milliseconds: 25));
      _isLoading = false;
      notifyListeners();
    }
  }

  //List of activities after filtering
  /* List<Map<String, dynamic>> filteredActivities = []; */

  Future<List<Map<String, dynamic>>> sortActivities({
    required List<Map<String, dynamic>> activities,
    Map<String, List<Map<String, String>>>? filters,
    List<String>? keywords,
  }) async {
    _filteredActivities = [];

    //Filter activities by categories, ages, days, schedules and sectors
    List<Map<String, String>> categories = [];
    List<Map<String, String>> ages = [];
    List<Map<String, String>> days = [];
    List<Map<String, String>> schedules = [];
    List<Map<String, String>> sectors = [];

    if (filters != null) {
      if (filters.containsKey('categories')) {
        categories = filters['categories']!.map((category) {
          return {
            'id': category['id']!,
            'name': category['name']!,
          };
        }).toList();
      }
      
      if (filters.containsKey('ages')) {
        ages = filters['ages']!.map((age) {
          return {
            'id': age['id']!,
            'name': age['name']!,
          };
        }).toList();
      }

      if (filters.containsKey('days')) {
        days = filters['days']!.map((day) {
          return {
            'id': day['id']!,
            'name': day['name']!,
          };
        }).toList();
      }

      if (filters.containsKey('schedules')) {
        schedules = filters['schedules']!.map((schedule) {
          return {
            'id': schedule['id']!,
            'name': schedule['name']!,
          };
        }).toList();
      }

      if (filters.containsKey('sectors')) {
        sectors = filters['sectors']!.map((sector) {
          return {
            'id': sector['id']!,
            'name': sector['name']!,
          };
        }).toList();
      }
    }

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

      bool matchesCategory = categories.isEmpty || categories.any((category) {
        return categoriesId.any((categoryId) => category['id'] == categoryId['id']);
      });

      bool matchesAge = ages.isEmpty || ages.any((age) {
        return agesId.any((ageId) => age['id'] == ageId['id']);
      });

      bool matchesDay = days.isEmpty || days.any((day) {
        return daysId.any((dayId) => day['id'] == dayId['id']);
      });

      bool matchesSchedule = schedules.isEmpty || schedules.any((schedule) {
        return schedulesId.any((scheduleId) => schedule['id'] == scheduleId['id']);
      });

      bool matchesSector = sectors.isEmpty || sectors.any((sector) {
        return sectorsId.any((sectorId) => sector['id'] == sectorId['id']);
      });

      if (matchesCategory && matchesAge && matchesDay && matchesSchedule && matchesSector) {
        _filteredActivities.add(activity);
      }
    }
  
    //Filter activities by keywords
    if (keywords != null && keywords.isNotEmpty) {
      _filteredActivities = _filteredActivities.where((activity) {
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
    
    debugPrint('FilteredActivities L322: ${_filteredActivities}');

    return _filteredActivities;
  }

  List<Map<String, dynamic>> _filteredActivities = [];
  List<Map<String, dynamic>> get filteredActivities => _filteredActivities;

  Map<String, dynamic>? _selectedActivity;
  Map<String, dynamic>? get selectedActivity => _selectedActivity;

  void setFilteredActivities(List<Map<String, dynamic>> filteredActivities) {
    _filteredActivities = filteredActivities;
    notifyListeners();
  }

  void setSelectedActivity(Map<String, dynamic> selectedActivity) {
    _selectedActivity = selectedActivity;
    notifyListeners();
  }

  void clearSelectedActivity() {
    _selectedActivity = null;
    notifyListeners();
  }
}