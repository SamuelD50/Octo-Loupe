import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:octoloupe/model/sport_filter_model.dart';

class SportService {
  //CRUD SportCategories

  //Create SportCategory
  Future<void> addSportCategory(String name, String image) async {
    try {
      await FirebaseFirestore.instance
        .collection('filters')
        .doc('sports')
        .collection('categories')
        .add({
          'name': name,
          'image': image,
        });
      debugPrint('Adding new category $name successfully');
    } catch (e) {
      debugPrint('Error adding category: $e');
    }
  }

  //Read SportCategories
  Future<List<SportCategory>> getSportCategories() async {
    try {
      final snapshot = await FirebaseFirestore.instance
        .collection('filters')
        .doc('sports')
        .collection('categories')
        .get();

      debugPrint('Number of categories fetched: ${snapshot.docs.length}');

      return snapshot.docs.map((doc) {
        final data = doc.data();
        final name = data['name'] ?? 'Unknown category';
        final image = data['image'] ?? 'assets/images/glisse.jpg';

        debugPrint('Category fetched: $name, Image: $image');

        return SportCategory(name: name, image: image);
      }).toList();
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      return [];
    }
  }

  //Update SportCategory
  Future<void> updateSportCategory(String categoryId, String newName, String newImage) async {
    try {
      await FirebaseFirestore.instance
        .collection('filters')
        .doc('sports')
        .collection('categories')
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
    try {
      await FirebaseFirestore.instance
        .collection('filters')
        .doc('sports')
        .collection('categories')
        .doc(categoryId)
        .delete();
      debugPrint('Category with ID $categoryId deleted');
    } catch (e) {
      debugPrint('Error deleting category: $e');
    }
  }

  //CRUD SportAges

  //Create SportAge
  Future<void> addSportAge(String name, String image) async {
    try {
      await FirebaseFirestore.instance
        .collection('filters')
        .doc('sports')
        .collection('ages')
        .add({
          'name': name,
          'image': image,
        });
      debugPrint('Adding new age $name successfully');
    } catch (e) {
      debugPrint('Error adding age: $e');
    }
  }

  //Read SportAges
  Future<List<SportAge>> getSportAges() async {
    try {
      final snapshot = await FirebaseFirestore.instance
        .collection('filters')
        .doc('sports')
        .collection('ages')
        .get();

      debugPrint('Number of ages fetched: ${snapshot.docs.length}');

      return snapshot.docs.map((doc) {
        final data = doc.data();
        final name = data['name'] ?? 'Unknown age';
        final image = data['image'] ?? 'assets/images/glisse.jpg';

        debugPrint('Age fetched: $name, Image: $image');

        return SportAge(name: name, image: image);
      }).toList();
    } catch (e) {
      debugPrint('Error fetching ages: $e');
      return [];
    }
  }


  //Update SportAge
  Future<void> updateSportAge(String ageId, String newName, String newImage) async {
    try {
      await FirebaseFirestore.instance
        .collection('filters')
        .doc('sports')
        .collection('ages')
        .doc(ageId)
        .update({
          'name': newName,
          'image': newImage,
        });
      debugPrint('Age $newName updated successfully');
    } catch (e) {
      debugPrint('Error updating age: $e');
    }
  }

  //Delete SportAge
  Future<void> deleteSportAge(String ageId) async {
    try {
      await FirebaseFirestore.instance
        .collection('filters')
        .doc('sports')
        .collection('ages')
        .doc(ageId)
        .delete();
      debugPrint('Age with $ageId deleted');
    } catch (e) {
      debugPrint('Error deleting age: $e');
    }
  }

  //CRUD SportDays

  //Create SportDay
  Future<void> addSportDay(String name, String image) async {
    try {
      await FirebaseFirestore.instance
        .collection('filters')
        .doc('sports')
        .collection('days')
        .add({
          'name': name,
          'image': image,
        });
      debugPrint('Adding new day $name successfully');
    } catch (e) {
      debugPrint('Error adding day; $e');
    }
  }

  //Read SportDays
  Future<List<SportDay>> getSportDays() async {
    try {
      final snapshot = await FirebaseFirestore.instance
        .collection('filters')
        .doc('sports')
        .collection('days')
        .get();

      debugPrint('Number of days fetched: ${snapshot.docs.length}');

      return snapshot.docs.map((doc) {
        final data = doc.data();
        final name = data['name'] ?? 'Unknow day';
        final image = data['image'] ?? 'assets/images/glisse.jpg';

        debugPrint('Day fetched: $name, Image: $image');

        return SportDay(name: name, image: image);
      }).toList();
    } catch (e) {
      debugPrint('Error fetching days: $e');
      return [];
    }
  }


  //Update SportDay
  Future<void> updateSportDay(String dayId, String newName, String newImage) async {
    try {
      await FirebaseFirestore.instance
        .collection('filters')
        .doc('sports')
        .collection('days')
        .doc(dayId)
        .update({
          'name': newName,
          'image': newImage,
        });
      debugPrint('Day $newName updated successfully');
    } catch (e) {
      debugPrint('Error updating day: $e');
    }
  }

  //Delete SportDay
  Future<void> deleteSportDay(String dayId) async {
    try {
      await FirebaseFirestore.instance
        .collection('filters')
        .doc('sports')
        .collection('days')
        .doc(dayId)
        .delete();
      debugPrint('Day with ID $dayId deleted');
    } catch (e) {
      debugPrint('Error deleting day: $e');
    }
  }


  //CRUD SportSchedules

  //Create SportSchedules
  Future<void> addSportSchedule(String name, String image) async {
    try {
      await FirebaseFirestore.instance
        .collection('filters')
        .doc('sports')
        .collection('schedules')
        .add({
          'name': name,
          'image': image,
        });
      debugPrint('Adding new schedule $name successfully');
    } catch (e) {
      debugPrint('Error adding schedule: $e');
    }
  }

 //Read SportSchedules
  Future<List<SportSchedule>> getSportSchedules() async {
    try {
      final snapshot = await FirebaseFirestore.instance
        .collection('filters')
        .doc('sports')
        .collection('schedules')
        .get();
      debugPrint('Number of schedules fetched ${snapshot.docs.length}');

      return snapshot.docs.map((doc) {
        final data = doc.data();
        final name = data['name'] ?? 'Unknown schedule';
        final image = data['image'] ?? 'assets/images/glisse.jpg';

        debugPrint('Schedule fetched: $name, Image: $image');

        return SportSchedule(name: name, image: image);
      }).toList();
    } catch (e) {
      debugPrint('Error fetching schedules: $e');
      return [];
    }
  }


  //Update SportSchedule
  Future<void> updateSportSchedule(String scheduleId, String newName, String newImage) async {
    try {
      await FirebaseFirestore.instance
        .collection('filters')
        .doc('sports')
        .collection('schedules')
        .doc(scheduleId)
        .update({
          'name': newName,
          'image': newImage,
        });
      debugPrint('Schedule $newName updated successfully');
    } catch (e) {
      debugPrint('Error updating schedule: $e');
    }
  }

  //Delete SportSchedule
  Future<void> deleteSportSchedule(String scheduleId) async {
    try {
      await FirebaseFirestore.instance
        .collection('filters')
        .doc('sports')
        .collection('schedules')
        .doc(scheduleId)
        .delete();
      debugPrint('Schedule with ID $scheduleId deleted');
    } catch (e) {
      debugPrint('Error deleting schedule: $e');
    }
  }


  //CRUD SportSectors

  //Create SportSectors
  Future<void> addSportSector(String name, String image) async {
    try {
      await FirebaseFirestore.instance
        .collection('filters')
        .doc('sports')
        .collection('sectors')
        .add({
          'name': name,
          'image': image,
        });
      debugPrint('Adding new sector $name successfully');
    } catch (e) {
      debugPrint('Error adding sector: $e');
    }
  }


  //Read SportSectors
  Future<List<SportSector>> getSportSectors() async {
    try {
      final snapshot = await FirebaseFirestore.instance
        .collection('filters')
        .doc('sports')
        .collection('sectors')
        .get();

      debugPrint('Number of sectors fetched: ${snapshot.docs.length}');

      return snapshot.docs.map((doc) {
        final data = doc.data();
        final name = data['name'] ?? 'Unknown sector';
        final image = data['image'] ?? 'assets/images/glisse.jpg';

        debugPrint('Sector fetched: $name, Image: $image');

        return SportSector(name: name, image: image);
      }).toList();
    } catch (e) {
      debugPrint('Error fetching sectors: $e');
      return [];
    }
  }


  //Update SportSector
  Future<void> updateSportSector(String sectorId, String newName, String newImage) async {
    try {
      await FirebaseFirestore.instance
        .collection('filters')
        .doc('sports')
        .collection('sectors')
        .doc(sectorId)
        .update({
          'name': newName,
          'image': newImage,
        });
        debugPrint('Sector $newName updated successfully');
    } catch (e) {
      debugPrint('Error updating sector: $e');
    }
  }

  //Delete SportSector
  Future<void> deleteSportSector(String sectorId) async {
    try {
      await FirebaseFirestore.instance
        .collection('filters')
        .doc('sports')
        .collection('sectors')
        .doc(sectorId)
        .delete();
      debugPrint('Sector with ID $sectorId deleted');
    } catch (e) {
      debugPrint('Error deleting sector: $e');
    }
  }
}