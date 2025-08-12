import 'package:flutter/material.dart';
import 'package:octoloupe/model/culture_filters_model.dart';
import 'package:octoloupe/model/sport_filters_model.dart';

class FilterProvider extends ChangeNotifier {
  int _selectedSection = 0;
  int get selectedSection => _selectedSection;

  void setSection(int section) {
    if (_selectedSection == section) return;
    _selectedSection = section;
    notifyListeners();
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

  void resetFilters() {
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
    notifyListeners();
  }

  // Collect filters to search for matching activities
  Map<String, List<Map<String, String>>> collectFilters() {
    final Map<String, List<Map<String, String>>> filters = {};
    
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
    return filters;
  }

  void setSelectedCategories({
    required int selectedSection,
    required List<Map<String, String>>? selectedCategories
  }) {
    if (selectedCategories != null) {
      if (selectedSection == 0) {
        selectedSportCategories = selectedCategories
          .map((category) => SportCategory.fromMap(category))
          .toList();
      } else {
        selectedCultureCategories = selectedCategories
          .map((category) => CultureCategory.fromMap(category))
          .toList();
      }
    }
    notifyListeners();
  }

  void setSelectedAges({
    required int selectedSection,
    required List<Map<String, String>>? selectedAges
  }) {
    if (selectedAges != null) {
      if (selectedSection == 0) {
        selectedSportAges = selectedAges
          .map((age) => SportAge.fromMap(age))
          .toList();
      } else {
        selectedCultureAges = selectedAges
          .map((age) => CultureAge.fromMap(age))
          .toList();
      }
    }
    notifyListeners();
  }

  void setSelectedDays({
    required int selectedSection,
    required List<Map<String, String>>? selectedDays
  }) {
    if (selectedDays != null) {
      if (selectedSection == 0) {
        selectedSportDays = selectedDays
          .map((day) => SportDay.fromMap(day))
          .toList();
      } else {
        selectedCultureDays = selectedDays
          .map((day) => CultureDay.fromMap(day))
          .toList();
      }
    }
    notifyListeners();
  }

  void setSelectedSchedules({
    required int selectedSection,
    required List<Map<String, String>>? selectedSchedules
  }) {
    if (selectedSchedules != null) {
      if (selectedSection == 0) {
        selectedSportSchedules = selectedSchedules
          .map((schedule) => SportSchedule.fromMap(schedule))
          .toList();
      } else {
        selectedCultureSchedules = selectedSchedules
          .map((schedule) => CultureSchedule.fromMap(schedule))
          .toList();
      }
    }
    notifyListeners();
  }

  void setSelectedSectors({
    required int selectedSection,
    required List<Map<String, String>>? selectedSectors
  }) {
    if (selectedSectors != null) {
      if (selectedSection == 0) {
        selectedSportSectors = selectedSectors
          .map((sector) => SportSector.fromMap(sector))
          .toList();
      } else {
        selectedCultureSectors = selectedSectors
          .map((sector) => CultureSector.fromMap(sector))
          .toList();
      }
    }
    notifyListeners();
  }

}