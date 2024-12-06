import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:octoloupe/model/sport_filter_model.dart';
import 'package:octoloupe/services/database.dart';

class SportService {
  final DatabaseService databaseService = DatabaseService();
  //CRUD SportCategories

  //Create SportCategory
  Future<void> addSportCategory(String? categoryId, String name, String imageUrl) async {
    await databaseService.createFilter(
      'sports',
      'categories',
      categoryId,
      name,
      imageUrl,
    );
  }

  //Read SportCategories
  Future<List<SportCategory>> getSportCategories() async {
    try {
      var filtersData = await databaseService.getFilters(
        'sports',
        'categories',
      );
      return filtersData.map((docSnapshot) {
        final id = docSnapshot['id'] ?? docSnapshot.id;
        final name = docSnapshot['name'] ?? 'Nom non disponible';
        final imageUrl = docSnapshot['imageUrl'] ?? 'Default imageUrl path';
        debugPrint('Sport category - id: $id, name: $name, imageUrl: $imageUrl');

        return SportCategory(
          id: id,
          name: name,
          imageUrl: imageUrl,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching sport categories: $e');
      return [];
    }
  }

  //Update SportCategory
  Future<void> updateSportCategory(String categoryId, String newName, String newImageUrl) async {
    await databaseService.updateFilter(
      'sports',
      'categories',
      categoryId,
      newName,
      newImageUrl,
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
  Future<void> addSportAge(String? ageId, String name, String imageUrl) async {
    await databaseService.createFilter(
      'sports',
      'ages',
      ageId,
      name,
      imageUrl,
    );
  }


  //Read SportAges
  Future<List<SportAge>> getSportAges() async {
    try {
      var filtersData = await databaseService.getFilters(
        'sports',
        'ages',
      );
      return filtersData.map((docSnapshot) {
        final id = docSnapshot['id'] ?? docSnapshot.id;
        final name = docSnapshot['name'] ?? 'Nom non disponible';
        final imageUrl = docSnapshot['imageUrl'] ?? 'Default imageUrl path';
        debugPrint('Sport age - id: $id, name: $name, imageUrl: $imageUrl');

        return SportAge(
          id: id,
          name: name,
          imageUrl: imageUrl,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching sport ages: $e');
      return [];
    }
  }

  //Update SportAge
  Future<void> updateSportAge(String ageId, String newName, String newImageUrl) async {
    await databaseService.updateFilter(
      'sports',
      'ages',
      ageId,
      newName,
      newImageUrl,
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
  Future<void> addSportDay(String? dayId, String name, String imageUrl) async {
    await databaseService.createFilter(
      'sports',
      'days',
      dayId,
      name,
      imageUrl,
    );
  }


  //Read SportDays
  Future<List<SportDay>> getSportDays() async {
    try {
      var filtersData = await databaseService.getFilters(
        'sports',
        'days',
      );
      return filtersData.map((docSnapshot) {
        final id = docSnapshot['id'] ?? docSnapshot.id;
        final name = docSnapshot['name'] ?? 'Nom non disponible';
        final imageUrl = docSnapshot['imageUrl'] ?? 'Default imageUrl path';
        debugPrint('Sport day - id: $id, name: $name, imageUrl: $imageUrl');

        return SportDay(
          id: id,
          name: name,
          imageUrl: imageUrl,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching sport days: $e');
      return [];
    }
  }


  //Update SportDay
  Future<void> updateSportDay(String dayId, String newName, String newImageUrl) async {
    await databaseService.updateFilter(
      'sports',
      'days',
      dayId,
      newName,
      newImageUrl,
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
  Future<void> addSportSchedule(String? scheduleId, String name, String imageUrl) async {
    await databaseService.createFilter(
      'sports',
      'schedules',
      scheduleId,
      name,
      imageUrl,
    );
  }

  //Read SportSchedules
  Future<List<SportSchedule>> getSportSchedules() async {
    try {
      var filtersData = await databaseService.getFilters(
        'sports',
        'schedules',
      );
      return filtersData.map((docSnapshot) {
        final id = docSnapshot['id'] ?? docSnapshot.id;
        final name = docSnapshot['name'] ?? 'Nom non disponible';
        final imageUrl = docSnapshot['imageUrl'] ?? 'Default imageUrl path';
        debugPrint('Sport schedule - id: $id, name: $name, imageUrl: $imageUrl');

        return SportSchedule(
          id: id,
          name: name,
          imageUrl: imageUrl,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching sport schedules: $e');
      return [];
    }
  }

  //Update SportSchedule
  Future<void> updateSportSchedule(String scheduleId, String newName, String newImageUrl) async {
    await databaseService.updateFilter(
      'sports',
      'schedules',
      scheduleId,
      newName,
      newImageUrl,
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
  Future<void> addSportSector(String? sectorId, String name, String imageUrl) async {
    await databaseService.createFilter(
      'sports',
      'sectors',
      sectorId,
      name,
      imageUrl,
    );
  }

  //Read SportCategories
  Future<List<SportSector>> getSportSectors() async {
    try {
      var filtersData = await databaseService.getFilters(
        'sports',
        'sectors',
      );
      return filtersData.map((docSnapshot) {
        final id = docSnapshot['id'] ?? docSnapshot.id;
        final name = docSnapshot['name'] ?? 'Nom non disponible';
        final imageUrl = docSnapshot['imageUrl'] ?? 'Default imageUrl path';
        debugPrint('Sport sector - id: $id, name: $name, imageUrl: $imageUrl');

        return SportSector(
          id: id,
          name: name,
          imageUrl: imageUrl,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching sport sectors: $e');
      return [];
    }
  }

  //Update SportSector
  Future<void> updateSportSector(String sectorId, String newName, String newImageUrl) async {
    await databaseService.updateFilter(
      'sports',
      'sectors',
      sectorId,
      newName,
      newImageUrl,
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