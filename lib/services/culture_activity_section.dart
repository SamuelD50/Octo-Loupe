import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:octoloupe/model/culture_filter_model.dart';


class CultureService {
  //CRUD SportCategories

  //Create CultureCategory
  Future<void> addCultureCategory(String name, String image) async {
    await FirebaseFirestore.instance
      .collection('cultures')
      .doc('categories')
      .collection('items')
      .add({
        'name': name,
        'image': image,
      });
      debugPrint('Adding new category $name successfully');
  }

  //Read CultureCategories
  Future<List<CultureCategory>> getCultureCategories() async {
    final snapshot = await FirebaseFirestore.instance
      .collection('cultures')
      .doc('categories')
      .collection('items')
      .get();

    return snapshot.docs.map((doc) {
      return CultureCategory.fromJson(doc.data());
    }).toList();
  }

  //Update CultureCategory
  Future<void> updateCultureCategory(String categoryId, String newName, String newImage) async {
    try {
      await FirebaseFirestore.instance
        .collection('cultures')
        .doc('categories')
        .collection('items')
        .doc(categoryId)
        .update({
          'name': newName,
          'image': newImage,
        });
        debugPrint('Category $newName updated successfully');
    } catch (e) {
      debugPrint('Error updating the category: $e');
    }
  }

  //Delete CultureCategory
  Future<void> deleteCultureCategory(String categoryId) async {
    await FirebaseFirestore.instance
      .collection('cultures')
      .doc('categories')
      .collection('items')
      .doc(categoryId)
      .delete();
      debugPrint('Category with ID $categoryId deleted');
  }

  //CRUD CultureAges

  //Create CultureAge
  Future<void> addCultureAge(String name, String image) async {
    await FirebaseFirestore.instance
      .collection('cultures')
      .doc('ages')
      .collection('items')
      .add({
        'name': name,
        'image': image,
      });
      debugPrint('Adding new age $name successfully');
  }

  //Read CultureAges
  Future<List<CultureAge>> getCultureAges() async {
    final snapshot = await FirebaseFirestore.instance
      .collection('cultures')
      .doc('ages')
      .collection('items')
      .get();

    return snapshot.docs.map((doc) {
      return CultureAge.fromJson(doc.data());
    }).toList();
  }

  //Update CultureAge
  Future<void> updateCultureAge(String ageId, String newName, String newImage) async {
    try {
      await FirebaseFirestore.instance
        .collection('cultures')
        .doc('ages')
        .collection('items')
        .doc(ageId)
        .update({
          'name': newName,
          'image': newImage,
        });
        debugPrint('Age $newName updated successfully');
    } catch (e) {
      debugPrint('Error updating the age: $e');
    }
  }

  //Delete CultureAge
  Future<void> deleteCultureAge(String ageId) async {
    await FirebaseFirestore.instance
      .collection('cultures')
      .doc('ages')
      .collection('items')
      .doc(ageId)
      .delete();
      debugPrint('Age with $ageId deleted');
  }

  //CRUD CultureDays

  //Create CultureDay
  Future<void> addCultureDay(String name, String image) async {
    await FirebaseFirestore.instance
      .collection('cultures')
      .doc('days')
      .collection('items')
      .add({
        'name': name,
        'image': image,
      });
      debugPrint('Adding new day $name successfully');
  }

  //Read CultureDays
  Future<List<CultureDay>> getCultureDays() async {
    final snapshot = await FirebaseFirestore.instance
      .collection('cultures')
      .doc('days')
      .collection('items')
      .get();

    return snapshot.docs.map((doc) {
      return CultureDay.fromJson(doc.data());
    }).toList();
  }

  //Update CultureDay
  Future<void> updateCultureDay(String dayId, String newName, String newImage) async {
    try {
      await FirebaseFirestore.instance
        .collection('cultures')
        .doc('days')
        .collection('items')
        .doc(dayId)
        .update({
          'name': newName,
          'image': newImage,
        });
        debugPrint('Day $newName updated successfully');
    } catch (e) {
      debugPrint('Error updating the day: $e');
    }
  }

  //Delete CultureDay
  Future<void> deleteCultureDay(String dayId) async {
    await FirebaseFirestore.instance
      .collection('cultures')
      .doc('days')
      .collection('items')
      .doc(dayId)
      .delete();
      debugPrint('Day with ID $dayId deleted');
  }


  //CRUD CultureSchedules

  //Create CultureSchedules
  Future<void> addCultureSchedule(String name, String image) async {
    await FirebaseFirestore.instance
      .collection('cultures')
      .doc('schedules')
      .collection('items')
      .add({
        'name': name,
        'image': image,
      });
      debugPrint('Adding new schedule $name successfully');
  }

  //Read CultureSchedules
  Future<List<CultureSchedule>> getCultureSchedules() async {
    final snapshot = await FirebaseFirestore.instance
      .collection('cultures')
      .doc('schedules')
      .collection('items')
      .get();

    return snapshot.docs.map((doc) {
      return CultureSchedule.fromJson(doc.data());
    }).toList();
  }

  //Update CultureSchedule
  Future<void> updateCultureSchedule(String scheduleId, String newName, String newImage) async {
    try {
      await FirebaseFirestore.instance
        .collection('cultures')
        .doc('schedules')
        .collection('items')
        .doc(scheduleId)
        .update({
          'name': newName,
          'image': newImage,
        });
        debugPrint('Schedule $newName updated successfully');
    } catch (e) {
      debugPrint('Error updating the schedule: $e');
    }
  }

  //Delete CultureCategory
  Future<void> deleteCultureSchedule(String scheduleId) async {
    await FirebaseFirestore.instance
      .collection('cultures')
      .doc('schedules')
      .collection('items')
      .doc(scheduleId)
      .delete();
      debugPrint('Schedule with ID $scheduleId deleted');
  }


  //CRUD CultureSectors

  //Create CultureSectors
  Future<void> addCultureSector(String name, String image) async {
    await FirebaseFirestore.instance
      .collection('cultures')
      .doc('sectors')
      .collection('items')
      .add({
        'name': name,
        'image': image,
      });
      debugPrint('Adding new sector $name successfully');
  }

  //Read CultureSectors
  Future<List<CultureSector>> getCultureSectors() async {
    final snapshot = await FirebaseFirestore.instance
      .collection('cultures')
      .doc('sectors')
      .collection('items')
      .get();

    return snapshot.docs.map((doc) {
      return CultureSector.fromJson(doc.data());
    }).toList();
  }

  //Update SportSector
  Future<void> updateCultureSector(String sectorId, String newName, String newImage) async {
    try {
      await FirebaseFirestore.instance
        .collection('cultures')
        .doc('sectors')
        .collection('items')
        .doc(sectorId)
        .update({
          'name': newName,
          'image': newImage,
        });
        debugPrint('Sector $newName updated successfully');
    } catch (e) {
      debugPrint('Error updating the sector: $e');
    }
  }

  //Delete SportCategory
  Future<void> deleteCultureSector(String sectorId) async {
    await FirebaseFirestore.instance
      .collection('cultures')
      .doc('sectors')
      .collection('items')
      .doc(sectorId)
      .delete();
      debugPrint('Sector with ID $sectorId deleted');
  }
}