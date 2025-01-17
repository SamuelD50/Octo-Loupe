import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:octoloupe/model/culture_filters_model.dart';
import 'package:octoloupe/CRUD/filters_crud.dart';

class CultureFilterService {
  final FiltersCRUD filtersCRUD = FiltersCRUD();
  //CRUD SportCategories

  //Create CultureCategory
  Future<void> addCultureCategory(
    String? categoryId,
    String name,
    String imageUrl
  ) async {
    await filtersCRUD.createFilter(
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
      var filtersData = await filtersCRUD.getFilters(
        'cultures',
        'categories',
      );
      return filtersData.map((docSnapshot) {
        final id = docSnapshot['id'];
        final name = docSnapshot['name'];
        final imageUrl = docSnapshot['imageUrl'];

        return CultureCategory(
          id: id,
          name: name,
          imageUrl: imageUrl,
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  //Update CultureCategory
  Future<void> updateCultureCategory(
    String categoryId,
    String newName,
    String newImageUrl
  ) async {
    await filtersCRUD.updateFilter(
      'cultures',
      'categories',
      categoryId,
      newName,
      newImageUrl,
    );
  }

  //Delete CultureCategory
  Future<void> deleteCultureCategory(
    String categoryId
  ) async {
    await filtersCRUD.deleteFilter(
      'cultures',
      'categories',
      categoryId,
    );
  }

  //CRUD CultureAges

  //Create CultureAge
  Future<void> addCultureAge(
    String? ageId,
    String name,
    String imageUrl
  ) async {
    await filtersCRUD.createFilter(
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
      var filtersData = await filtersCRUD.getFilters(
        'cultures',
        'ages',
      );
      return filtersData.map((docSnapshot) {
        final id = docSnapshot['id'];
        final name = docSnapshot['name'];
        final imageUrl = docSnapshot['imageUrl'];

        return CultureAge(
          id: id,
          name: name,
          imageUrl: imageUrl,
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  //Update CultureAge
  Future<void> updateCultureAge(
    String ageId,
    String newName,
    String newImageUrl
  ) async {
    await filtersCRUD.updateFilter(
      'cultures',
      'ages',
      ageId,
      newName,
      newImageUrl,
    );
  }

  //Delete CultureAge
  Future<void> deleteCultureAge(
    String ageId
  ) async {
    await filtersCRUD.deleteFilter(
      'cultures',
      'ages',
      ageId,
    );
  }

  //CRUD CultureDays

  //Create CultureDay
  Future<void> addCultureDay(
    String? dayId,
    String name,
    String imageUrl
  ) async {
    await filtersCRUD.createFilter(
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
      var filtersData = await filtersCRUD.getFilters(
        'cultures',
        'days',
      );
      return filtersData.map((docSnapshot) {
        final id = docSnapshot['id'];
        final name = docSnapshot['name'];
        final imageUrl = docSnapshot['imageUrl'];

        return CultureDay(
          id: id,
          name: name,
          imageUrl: imageUrl,
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }


  //Update CultureDay
  Future<void> updateCultureDay(
    String dayId,
    String newName,
    String newImageUrl
  ) async {
    await filtersCRUD.updateFilter(
      'cultures',
      'days',
      dayId,
      newName,
      newImageUrl,
    );
  }

  //Delete CultureDay
  Future<void> deleteCultureDay(
    String dayId
  ) async {
    await filtersCRUD.deleteFilter(
      'cultures',
      'days',
      dayId,
    );
  }


  //CRUD CultureSchedules

  //Create CultureSchedules
  Future<void> addCultureSchedule(
    String? scheduleId,
    String name,
    String imageUrl
  ) async {
    await filtersCRUD.createFilter(
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
      var filtersData = await filtersCRUD.getFilters(
        'cultures',
        'schedules',
      );
      return filtersData.map((docSnapshot) {
        final id = docSnapshot['id'];
        final name = docSnapshot['name'];
        final imageUrl = docSnapshot['imageUrl'];

        return CultureSchedule(
          id: id,
          name: name,
          imageUrl: imageUrl,
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }


  //Update CultureSchedule
  Future<void> updateCultureSchedule(
    String scheduleId,
    String newName,
    String newImageUrl
  ) async {
    await filtersCRUD.updateFilter(
      'cultures',
      'schedules',
      scheduleId,
      newName,
      newImageUrl,
    );
  }

  //Delete CultureSchedule
  Future<void> deleteCultureSchedule(
    String scheduleId
  ) async {
    await filtersCRUD.deleteFilter(
      'cultures',
      'schedules',
      scheduleId,
    );
  }


  //CRUD CultureSectors

  //Create CultureSectors
  Future<void> addCultureSector(
    String? sectorId,
    String name,
    String imageUrl
  ) async {
    await filtersCRUD.createFilter(
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
      var filtersData = await filtersCRUD.getFilters(
        'cultures',
        'sectors',
      );
      return filtersData.map((docSnapshot) {
        final id = docSnapshot['id'];
        final name = docSnapshot['name'];
        final imageUrl = docSnapshot['imageUrl'];

        return CultureSector(
          id: id,
          name: name,
          imageUrl: imageUrl,
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  //Update SportSector
  Future<void> updateCultureSector(
    String sectorId,
    String newName,
    String newImageUrl
  ) async {
    await filtersCRUD.updateFilter(
      'cultures',
      'sectors',
      sectorId,
      newName,
      newImageUrl,
    );
  }

  //Delete SportCategory
  Future<void> deleteCultureSector(
    String sectorId
  ) async {
    await filtersCRUD.deleteFilter(
      'cultures',
      'sectors',
      sectorId,
    );
  }
}