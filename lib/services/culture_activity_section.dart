import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:octoloupe/model/culture_filter_model.dart';
import 'package:octoloupe/services/database.dart';

class CultureService {
  final DatabaseService databaseService = DatabaseService();
  //CRUD SportCategories

  //Create CultureCategory
  Future<void> addCultureCategory(String categoryId, String name, String image) async {
    await databaseService.createFilter(
      'cultures',
      'categories',
      categoryId,
      name,
      image,
    );
  }

  //Read CultureCategories
  Future<List<CultureCategory>> getCultureCategories() async {
    try {
      var filtersData = await databaseService.getFilters(
        'cultures',
        'categories',
      );
      return filtersData.map((data) {
        return CultureCategory(
          id: data['id'],
          name: data['name'],
          image: data['image'],
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching culture categories: $e');
      return [];
    }
  }

  //Read CultureCategory
  Future<CultureCategory?> getCultureCategory(String categoryId) async {
    try {
      var filterData = await databaseService.getFilter(
        'cultures',
        'categories',
        categoryId,
      );
      if (filterData != null) {
        return CultureCategory(
          id: categoryId,
          name: filterData['name'],
          image: filterData['image'],
        );
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching culture category: $e');
      return null;
    }
  }

  //Update CultureCategory
  Future<void> updateCultureCategory(String categoryId, String newName, String newImage) async {
    await databaseService.updateFilter(
      'cultures',
      'categories',
      categoryId,
      newName,
      newImage,
    );
  }

  //Delete CultureCategory
  Future<void> deleteCultureCategory(String categoryId) async {
    await databaseService.deleteFilter(
      'cultures',
      'categories',
      categoryId,
    );
  }

  //CRUD CultureAges

  //Create CultureAge
  Future<void> addCultureAge(String ageId, String name, String image) async {
    await databaseService.createFilter(
      'cultures',
      'ages',
      ageId,
      name,
      image,
    );
  }

  //Read CultureAges
  Future<List<CultureAge>> getCultureAges() async {
    try {
      var filtersData = await databaseService.getFilters(
        'cultures',
        'ages',
      );
      return filtersData.map((data) {
        return CultureAge(
          id: data['id'],
          name: data['name'],
          image: data['image'],
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching culture ages: $e');
      return [];
    }
  }

  //Read CultureAge
  Future<CultureAge?> getCultureAge(String ageId) async {
    try {
      var filterData = await databaseService.getFilter(
        'cultures',
        'ages',
        ageId,
      );
      if (filterData != null) {
        return CultureAge(
          id: ageId,
          name: filterData['name'],
          image: filterData['image'],
        );
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching culture age: $e');
      return null;
    }
  }

  //Update CultureAge
  Future<void> updateCultureAge(String ageId, String newName, String newImage) async {
    await databaseService.updateFilter(
      'cultures',
      'ages',
      ageId,
      newName,
      newImage,
    );
  }

  //Delete CultureAge
  Future<void> deleteCultureAge(String ageId) async {
    await databaseService.deleteFilter(
      'cultures',
      'ages',
      ageId,
    );
  }

  //CRUD CultureDays

  //Create CultureDay
  Future<void> addCultureDay(String dayId, String name, String image) async {
    await databaseService.createFilter(
      'cultures',
      'days',
      dayId,
      name,
      image,
    );
  }

  //Read CultureDays
  Future<List<CultureDay>> getCultureDays() async {
    try {
      var filtersData = await databaseService.getFilters(
        'cultures',
        'days',
      );
      return filtersData.map((data) {
        return CultureDay(
          id: data['id'],
          name: data['name'],
          image: data['image'],
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching culture days: $e');
      return [];
    }
  }

  //Read CultureDay
  Future<CultureDay?> getCultureDay(String dayId) async {
    try {
      var filterData = await databaseService.getFilter(
        'cultures',
        'days',
        dayId,
      );
      if (filterData != null) {
        return CultureDay(
          id: dayId,
          name: filterData['name'],
          image: filterData['image'],
        );
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching culture day: $e');
      return null;
    }
  }


  //Update CultureDay
  Future<void> updateCultureDay(String dayId, String newName, String newImage) async {
    await databaseService.updateFilter(
      'cultures',
      'days',
      dayId,
      newName,
      newImage,
    );
  }

  //Delete CultureDay
  Future<void> deleteCultureDay(String dayId) async {
    await databaseService.deleteFilter(
      'cultures',
      'days',
      dayId,
    );
  }


  //CRUD CultureSchedules

  //Create CultureSchedules
  Future<void> addCultureSchedule(String scheduleId, String name, String image) async {
    await databaseService.createFilter(
      'cultures',
      'schedules',
      scheduleId,
      name,
      image,
    );
  }

  //Read CultureSchedules
  Future<List<CultureSchedule>> getCultureSchedules() async {
    try {
      var filtersData = await databaseService.getFilters(
        'cultures',
        'schedules',
      );
      return filtersData.map((data) {
        return CultureSchedule(
          id: data['id'],
          name: data['name'],
          image: data['image'],
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching culture schedules: $e');
      return [];
    }
  }

  //Read CultureSchedule
  Future<CultureSchedule?> getCultureSchedule(String scheduleId) async {
    try {
      var filterData = await databaseService.getFilter(
        'cultures',
        'schedules',
        scheduleId,
      );
      if (filterData != null) {
        return CultureSchedule(
          id: scheduleId,
          name: filterData['name'],
          image: filterData['image'],
        );
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching culture schedule: $e');
      return null;
    }
  }


  //Update CultureSchedule
  Future<void> updateCultureSchedule(String scheduleId, String newName, String newImage) async {
    await databaseService.updateFilter(
      'cultures',
      'schedules',
      scheduleId,
      newName,
      newImage,
    );
  }

  //Delete CultureSchedule
  Future<void> deleteCultureSchedule(String scheduleId) async {
    await databaseService.deleteFilter(
      'cultures',
      'schedules',
      scheduleId,
    );
  }


  //CRUD CultureSectors

  //Create CultureSectors
  Future<void> addCultureSector(String sectorId, String name, String image) async {
    await databaseService.createFilter(
      'cultures',
      'sectors',
      sectorId,
      name,
      image,
    );
  }

  //Read CultureSectors
  Future<List<CultureSector>> getCultureSectors() async {
    try {
      var filtersData = await databaseService.getFilters(
        'cultures',
        'sectors',
      );
      return filtersData.map((data) {
        return CultureSector(
          id: data['id'],
          name: data['name'],
          image: data['image'],
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching culture sectors: $e');
      return [];
    }
  }

  //Read CultureSector
  Future<CultureSector?> getCultureSector(String sectorId) async {
    try {
      var filterData = await databaseService.getFilter(
        'cultures',
        'sectors',
        sectorId,
      );
      if (filterData != null) {
        return CultureSector(
          id: sectorId,
          name: filterData['name'],
          image: filterData['image'],
        );
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching culture sector: $e');
      return null;
    }
  }

  //Update SportSector
  Future<void> updateCultureSector(String sectorId, String newName, String newImage) async {
    await databaseService.updateFilter(
      'cultures',
      'sectors',
      sectorId,
      newName,
      newImage,
    );
  }

  //Delete SportCategory
  Future<void> deleteCultureSector(String sectorId) async {
    await databaseService.deleteFilter(
      'cultures',
      'sectors',
      sectorId,
    );
  }
}