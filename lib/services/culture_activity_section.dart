import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:octoloupe/model/culture_filter_model.dart';
import 'package:octoloupe/services/database.dart';

class CultureService {
  final DatabaseService databaseService = DatabaseService();
  //CRUD SportCategories

  //Create CultureCategory
  Future<void> addCultureCategory(String? categoryId, String name, String imageUrl) async {
    await databaseService.createFilter(
      'cultures',
      'categories',
      categoryId,
      name,
      imageUrl,
    );
  }

  //Read CultureCategories
  Future<List<CultureCategory>> getCultureCategories() async {
    try {
      var filtersData = await databaseService.getFilters(
        'cultures',
        'categories',
      );
      return filtersData.map((docSnapshot) {
        final id = docSnapshot['id'] ?? docSnapshot.id;
        final name = docSnapshot['name'] ?? 'Nom non disponible';
        final imageUrl = docSnapshot['imageUrl'] ?? 'Default imageUrl path';
        debugPrint('Culture category - id: $id, name: $name, imageUrl: $imageUrl');

        return CultureCategory(
          id: id,
          name: name,
          imageUrl: imageUrl,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching culture categories: $e');
      return [];
    }
  }

  //Update CultureCategory
  Future<void> updateCultureCategory(String categoryId, String newName, String newImageUrl) async {
    await databaseService.updateFilter(
      'cultures',
      'categories',
      categoryId,
      newName,
      newImageUrl,
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
  Future<void> addCultureAge(String? ageId, String name, String imageUrl) async {
    await databaseService.createFilter(
      'cultures',
      'ages',
      ageId,
      name,
      imageUrl,
    );
  }

  //Read CultureAges
  Future<List<CultureAge>> getCultureAges() async {
    try {
      var filtersData = await databaseService.getFilters(
        'cultures',
        'ages',
      );
      return filtersData.map((docSnapshot) {
        final id = docSnapshot['id'] ?? docSnapshot.id;
        final name = docSnapshot['name'] ?? 'Nom non disponible';
        final imageUrl = docSnapshot['imageUrl'] ?? 'Default imageUrl path';
        debugPrint('Culture age - id: $id, name: $name, imageUrl: $imageUrl');

        return CultureAge(
          id: id,
          name: name,
          imageUrl: imageUrl,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching culture ages: $e');
      return [];
    }
  }

  //Update CultureAge
  Future<void> updateCultureAge(String ageId, String newName, String newImageUrl) async {
    await databaseService.updateFilter(
      'cultures',
      'ages',
      ageId,
      newName,
      newImageUrl,
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
  Future<void> addCultureDay(String? dayId, String name, String imageUrl) async {
    await databaseService.createFilter(
      'cultures',
      'days',
      dayId,
      name,
      imageUrl,
    );
  }

  //Read CultureDays
  Future<List<CultureDay>> getCultureDays() async {
    try {
      var filtersData = await databaseService.getFilters(
        'cultures',
        'days',
      );
      return filtersData.map((docSnapshot) {
        final id = docSnapshot['id'] ?? docSnapshot.id;
        final name = docSnapshot['name'] ?? 'Nom non disponible';
        final imageUrl = docSnapshot['imageUrl'] ?? 'Default imageUrl path';
        debugPrint('Culture day - id: $id, name: $name, imageUrl: $imageUrl');

        return CultureDay(
          id: id,
          name: name,
          imageUrl: imageUrl,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching culture days: $e');
      return [];
    }
  }


  //Update CultureDay
  Future<void> updateCultureDay(String dayId, String newName, String newImageUrl) async {
    await databaseService.updateFilter(
      'cultures',
      'days',
      dayId,
      newName,
      newImageUrl,
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
  Future<void> addCultureSchedule(String? scheduleId, String name, String imageUrl) async {
    await databaseService.createFilter(
      'cultures',
      'schedules',
      scheduleId,
      name,
      imageUrl,
    );
  }

  //Read CultureSchedules
  Future<List<CultureSchedule>> getCultureSchedules() async {
    try {
      var filtersData = await databaseService.getFilters(
        'cultures',
        'schedules',
      );
      return filtersData.map((docSnapshot) {
        final id = docSnapshot['id'] ?? docSnapshot.id;
        final name = docSnapshot['name'] ?? 'Nom non disponible';
        final imageUrl = docSnapshot['imageUrl'] ?? 'Default imageUrl path';
        debugPrint('Culture schedule - id: $id, name: $name, imageUrl: $imageUrl');

        return CultureSchedule(
          id: id,
          name: name,
          imageUrl: imageUrl,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching culture schedules: $e');
      return [];
    }
  }


  //Update CultureSchedule
  Future<void> updateCultureSchedule(String scheduleId, String newName, String newImageUrl) async {
    await databaseService.updateFilter(
      'cultures',
      'schedules',
      scheduleId,
      newName,
      newImageUrl,
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
  Future<void> addCultureSector(String? sectorId, String name, String imageUrl) async {
    await databaseService.createFilter(
      'cultures',
      'sectors',
      sectorId,
      name,
      imageUrl,
    );
  }

  //Read CultureSectors
  Future<List<CultureSector>> getCultureSectors() async {
    try {
      var filtersData = await databaseService.getFilters(
        'cultures',
        'sectors',
      );
      return filtersData.map((docSnapshot) {
        final id = docSnapshot['id'] ?? docSnapshot.id;
        final name = docSnapshot['name'] ?? 'Nom non disponible';
        final imageUrl = docSnapshot['imageUrl'] ?? 'Default imageUrl path';
        debugPrint('Culture sector - id: $id, name: $name, imageUrl: $imageUrl');

        return CultureSector(
          id: id,
          name: name,
          imageUrl: imageUrl,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching culture sectors: $e');
      return [];
    }
  }

  //Update SportSector
  Future<void> updateCultureSector(String sectorId, String newName, String newImageUrl) async {
    await databaseService.updateFilter(
      'cultures',
      'sectors',
      sectorId,
      newName,
      newImageUrl,
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