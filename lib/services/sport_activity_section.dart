import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:octoloupe/model/sport_activity_model.dart';

//CRUD SportCategories

//Create SportCategory
Future<void> addSportCategory(String name, String image) async {
  await FirebaseFirestore.instance
    .collection('sports')
    .doc('categories')
    .collection('items')
    .add({
      'name': name,
      'image': image,
    });
    debugPrint('Adding new category $name successfully');
}

//Read SportCategories
Future<List<SportCategories>> getSportCategories() async {
  final snapshot = await FirebaseFirestore.instance
    .collection('sports')
    .doc('categories')
    .collection('items')
    .get();

  return snapshot.docs.map((doc) {
    return SportCategories.fromMap(doc.data());
  }).toList();
}

//Update SportCategory
Future<void> updateSportCategory(String categoryId, String newName, String newImage) async {
  try {
    await FirebaseFirestore.instance
      .collection('sports')
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

//Delete SportCategory
Future<void> deleteSportCategory(String categoryId) async {
  await FirebaseFirestore.instance
    .collection('sports')
    .doc('categories')
    .collection('items')
    .doc(categoryId)
    .delete();
    debugPrint('Category with ID $categoryId deleted');
}

//CRUD SportAges

//Create SportAge
Future<void> addSportAge(String name, String image) async {
  await FirebaseFirestore.instance
    .collection('sports')
    .doc('ages')
    .collection('items')
    .add({
      'name': name,
      'image': image,
    });
    debugPrint('Adding new age $name successfully');
}

//Read SportAges
Future<List<SportAges>> getSportAges() async {
  final snapshot = await FirebaseFirestore.instance
    .collection('sports')
    .doc('ages')
    .collection('items')
    .get();

  return snapshot.docs.map((doc) {
    return SportAges.fromMap(doc.data());
  }).toList();
}

//Update SportAge
Future<void> updateSportAge(String ageId, String newName, String newImage) async {
  try {
    await FirebaseFirestore.instance
      .collection('sports')
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

//Delete SportAge
Future<void> deleteSportAge(String ageId) async {
  await FirebaseFirestore.instance
    .collection('sports')
    .doc('ages')
    .collection('items')
    .doc(ageId)
    .delete();
    debugPrint('Age with $ageId deleted');
}

//CRUD SportDays

//Create SportDay
Future<void> addSportDay(String name, String image) async {
  await FirebaseFirestore.instance
    .collection('sports')
    .doc('days')
    .collection('items')
    .add({
      'name': name,
      'image': image,
    });
    debugPrint('Adding new day $name successfully');
}

//Read SportDays
Future<List<SportDays>> getSportDays() async {
  final snapshot = await FirebaseFirestore.instance
    .collection('sports')
    .doc('days')
    .collection('items')
    .get();

  return snapshot.docs.map((doc) {
    return SportDays.fromMap(doc.data());
  }).toList();
}

//Update SportDay
Future<void> updateSportDay(String dayId, String newName, String newImage) async {
  try {
    await FirebaseFirestore.instance
      .collection('sports')
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

//Delete SportDay
Future<void> deleteSportDay(String dayId) async {
  await FirebaseFirestore.instance
    .collection('sports')
    .doc('days')
    .collection('items')
    .doc(dayId)
    .delete();
    debugPrint('Day with ID $dayId deleted');
}


//CRUD SportSchedules

//Create SportSchedules
Future<void> addSportSchedule(String name, String image) async {
  await FirebaseFirestore.instance
    .collection('sports')
    .doc('schedules')
    .collection('items')
    .add({
      'name': name,
      'image': image,
    });
    debugPrint('Adding new schedule $name successfully');
}

//Read SportSchedules
Future<List<SportSchedules>> getSportSchedules() async {
  final snapshot = await FirebaseFirestore.instance
    .collection('sports')
    .doc('schedules')
    .collection('items')
    .get();

  return snapshot.docs.map((doc) {
    return SportSchedules.fromMap(doc.data());
  }).toList();
}

//Update SportSchedule
Future<void> updateSportSchedule(String scheduleId, String newName, String newImage) async {
  try {
    await FirebaseFirestore.instance
      .collection('sports')
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

//Delete SportCategory
Future<void> deleteSportSchedule(String scheduleId) async {
  await FirebaseFirestore.instance
    .collection('sports')
    .doc('schedules')
    .collection('items')
    .doc(scheduleId)
    .delete();
    debugPrint('Schedule with ID $scheduleId deleted');
}


//CRUD SportSectors

//Create SportSectors
Future<void> addSportSector(String name, String image) async {
  await FirebaseFirestore.instance
    .collection('sports')
    .doc('sectors')
    .collection('items')
    .add({
      'name': name,
      'image': image,
    });
    debugPrint('Adding new sector $name successfully');
}

//Read SportSectors
Future<List<SportSectors>> getSportSectors() async {
  final snapshot = await FirebaseFirestore.instance
    .collection('sports')
    .doc('sectors')
    .collection('items')
    .get();

  return snapshot.docs.map((doc) {
    return SportSectors.fromMap(doc.data());
  }).toList();
}

//Update SportSector
Future<void> updateSportSector(String sectorId, String newName, String newImage) async {
  try {
    await FirebaseFirestore.instance
      .collection('sports')
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
Future<void> deleteSportSector(String sectorId) async {
  await FirebaseFirestore.instance
    .collection('sports')
    .doc('sectors')
    .collection('items')
    .doc(sectorId)
    .delete();
    debugPrint('Sector with ID $sectorId deleted');
}