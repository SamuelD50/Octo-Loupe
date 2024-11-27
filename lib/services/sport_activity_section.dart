import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:octoloupe/model/sport_filter_model.dart';
import 'package:octoloupe/services/database.dart';

class SportService {
  final DatabaseService databaseService = DatabaseService();
  //CRUD SportCategories

  //Create SportCategory
  Future<void> addSportCategory(String categoryId, String name, String image) async {
    await databaseService.createFilter(
      'sports',
      'categories',
      categoryId,
      name,
      image,
    );
  }

  //Read SportCategories
  Future<List<SportCategory>> getSportCategories() async {
    try {
      var filtersData = await databaseService.getFilters(
        'sports',
        'categories',
      );
      return filtersData.map((data) {
        return SportCategory(
          id: data['id'],
          name: data['name'],
          image: data['image'],
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching sport categories: $e');
      return [];
    }
  }

  //Read SportCategory
  Future<SportCategory?> getSportCategory(String categoryId) async {
    try {
      var filterData = await databaseService.getFilter(
        'sports',
        'categories',
        categoryId,
      );
      if (filterData != null) {
        return SportCategory(
          id: categoryId,
          name: filterData['name'],
          image: filterData['image'],
        );
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching sport category: $e');
      return null;
    }
  }

  //Update SportCategory
  Future<void> updateSportCategory(String categoryId, String newName, String newImage) async {
    await databaseService.updateFilter(
      'sports',
      'categories',
      categoryId,
      newName,
      newImage,
    );
  }

  //Delete SportCategory
  Future<void> deleteSportCategory(String categoryId) async {
    await databaseService.deleteFilter(
      'sports',
      'categories',
      categoryId,
    );
  }

  //CRUD SportAges

  //Create SportAge
  Future<void> addSportAge(String ageId, String name, String image) async {
    await databaseService.createFilter(
      'sports',
      'ages',
      ageId,
      name,
      image,
    );
  }

  //Read SportAges
  Future<List<SportAge>> getSportAges() async {
    try {
      var filtersData = await databaseService.getFilters(
        'sports',
        'ages'
      );
      return filtersData.map((data) {
        return SportAge(
          id: data['id'],
          name: data['name'],
          image: data['image'],
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching sport ages: $e');
      return [];
    }
  }


  //Read SportAge
  Future<SportAge?> getSportAge(String ageId) async {
    try {
      var filterData = await databaseService.getFilter(
        'sports',
        'ages',
        ageId
      );
      if (filterData != null) {
        return SportAge(
          id: ageId,
          name: filterData['name'],
          image: filterData['image'],
        );
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching age: $e');
      return null;
    }
  }

  //Update SportAge
  Future<void> updateSportAge(String ageId, String newName, String newImage) async {
    await databaseService.updateFilter(
      'sports',
      'ages',
      ageId,
      newName,
      newImage,
    );
  }

  //Delete SportAge
  Future<void> deleteSportAge(String ageId) async {
    await databaseService.deleteFilter(
      'sports',
      'ages',
      ageId,
    );
  }

  //CRUD SportDays

  //Create SportDay
  Future<void> addSportDay(String dayId, String name, String image) async {
    await databaseService.createFilter(
      'sports',
      'days',
      dayId,
      name,
      image,
    );
  }

  //Read SportDays
  Future<List<SportDay>> getSportDays() async {
    try {
      var filtersData = await databaseService.getFilters(
        'sports',
        'days',
      );
      return filtersData.map((data) {
        return SportDay(
          id: data['id'],
          name: data['name'],
          image: data['image'],
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching sport days: $e');
      return [];
    }
  }

  //Read SportDay
  Future<SportDay?> getSportDay(String dayId) async {
    try {
      var filterData = await databaseService.getFilter(
        'sports',
        'days',
        dayId,
      );
      if (filterData != null) {
        return SportDay(
          id: dayId,
          name: filterData['name'],
          image: filterData['image'],
        );
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching sport day: $e');
      return null;
    }
  }


  //Update SportDay
  Future<void> updateSportDay(String dayId, String newName, String newImage) async {
    await databaseService.updateFilter(
      'sports',
      'days',
      dayId,
      newName,
      newImage,
    );
  }

  //Delete SportDay
  Future<void> deleteSportDay(String dayId) async {
    await databaseService.deleteFilter(
      'sports',
      'days',
      dayId,
    );
  }


  //CRUD SportSchedules

  //Create SportSchedules
  Future<void> addSportSchedule(String scheduleId, String name, String image) async {
     await databaseService.createFilter(
      'sports',
      'schedules',
      scheduleId,
      name,
      image,
    );
  }

 //Read SportSchedules
  Future<List<SportSchedule>> getSportSchedules() async {
    try {
      var filtersData = await databaseService.getFilters(
        'sports',
        'schedules',
      );
      return filtersData.map((data) {
        return SportSchedule(
          id: data['id'],
          name: data['name'],
          image: data['image'],
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching sport schedules: $e');
      return [];
    }
  }

  //Read SportSchedule
  Future<SportSchedule?> getSportSchedule(String scheduleId) async {
    try {
      var filterData = await databaseService.getFilter(
        'sports',
        'schedules',
        scheduleId,
      );
      if (filterData != null) {
        return SportSchedule(
          id: scheduleId,
          name: filterData['name'],
          image: filterData['image'],
        );
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching sport schedule: $e');
      return null;
    }
  }



  //Update SportSchedule
  Future<void> updateSportSchedule(String scheduleId, String newName, String newImage) async {
    await databaseService.updateFilter(
      'sports',
      'schedules',
      scheduleId,
      newName,
      newImage,
    );
  }

  //Delete SportSchedule
  Future<void> deleteSportSchedule(String scheduleId) async {
    await databaseService.deleteFilter(
      'sports',
      'schedules',
      scheduleId,
    );
  }


  //CRUD SportSectors

  //Create SportSectors
  Future<void> addSportSector(String sectorId, String name, String image) async {
    await databaseService.createFilter(
      'sports',
      'sectors',
      sectorId,
      name,
      image,
    );
  }


  //Read SportSectors
  Future<List<SportSector>> getSportSectors() async {
    try {
      var filtersData = await databaseService.getFilters(
        'sports',
        'sectors',
      );
      return filtersData.map((data) {
        return SportSector(
          id: data['id'],
          name: data['name'],
          image: data['image'],
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching sport sectors: $e');
      return [];
    }
  }

  //Read SportSector
  Future<SportSector?> getSportSector(String sectorId) async {
    try {
      var filterData = await databaseService.getFilter(
        'sports',
        'sectors',
        sectorId,
      );
      if (filterData != null) {
        return SportSector(
          id: sectorId,
          name: filterData['name'],
          image: filterData['image'],
        );
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching sport sector: $e');
      return null;
    }
  }

  //Update SportSector
  Future<void> updateSportSector(String sectorId, String newName, String newImage) async {
    await databaseService.updateFilter(
      'sports',
      'sectors',
      sectorId,
      newName,
      newImage,
    );
  }

  //Delete SportSector
  Future<void> deleteSportSector(String sectorId) async {
    await databaseService.deleteFilter(
      'sports',
      'sectors',
      sectorId,
    );
  }
}