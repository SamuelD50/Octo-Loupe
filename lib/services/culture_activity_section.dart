import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:octoloupe/model/culture_filter_model.dart';


class CultureService {
  //CRUD SportCategories

  //Create CultureCategory
  Future<void> addCultureCategory(String name, String image) async {
    try {
      await FirebaseFirestore.instance
        .collection('filters')
        .doc('cultures')
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

  //Read CultureCategories
  Future<List<CultureCategory>> getCultureCategories() async {
    try {
      final snapshot = await FirebaseFirestore.instance
        .collection('filters')
        .doc('cultures')
        .collection('categories')
        .get();
      debugPrint('Number of categories fetched : ${snapshot.docs.length}');

      return snapshot.docs.map((doc) {
        final data = doc.data();
        final name = data['name'] ?? 'Unknown category';
        final image = data['image'] ?? 'assets/images/glisse.jpg';

        debugPrint('Category fetched: $name, Image: $image');
        return CultureCategory(name: name, image: image);
      }).toList();
    } catch (e) {
      debugPrint('Error fetching categories: $e');
      return [];
    }
  }

  //Update CultureCategory
  Future<void> updateCultureCategory(String categoryId, String newName, String newImage) async {
    try {
      await FirebaseFirestore.instance
        .collection('filters')
        .doc('cultures')
        .collection('categories')
        .doc(categoryId)
        .update({
          'name': newName,
          'image': newImage,
        });
        debugPrint('Category $newName updated successfully');
    } catch (e) {
      debugPrint('Error updating category: $e');
    }
  }

  //Delete CultureCategory
  Future<void> deleteCultureCategory(String categoryId) async {
    try {
      await FirebaseFirestore.instance
        .collection('filters')
        .doc('cultures')
        .collection('categories')
        .doc(categoryId)
        .delete();
      debugPrint('Category with ID $categoryId deleted');
    } catch (e) {
      debugPrint('Error deleting category: $e');
    }
  }

  //CRUD CultureAges

  //Create CultureAge
  Future<void> addCultureAge(String name, String image) async {
    try {
      await FirebaseFirestore.instance
        .collection('filters')
        .doc('cultures')
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

  //Read CultureAges
  Future<List<CultureAge>> getCultureAges() async {
    try {
      final snapshot = await FirebaseFirestore.instance
        .collection('filters')
        .doc('cultures')
        .collection('ages')
        .get();

      debugPrint('Number of ages fetched: ${snapshot.docs.length}');

      return snapshot.docs.map((doc) {
        final data = doc.data();
        final name = data['name'] ?? 'Unknown age';
        final image = data['image'] ?? 'assets/images/glisse.jpg';

        debugPrint('Age fetched: $name, Image: $image');

        return CultureAge(name: name, image: image);
      }).toList();
    } catch (e) {
      debugPrint('Error fetching ages: $e');
      return [];
    }
  }

  //Update CultureAge
  Future<void> updateCultureAge(String ageId, String newName, String newImage) async {
    try {
      await FirebaseFirestore.instance
        .collection('filters')
        .doc('cultures')
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

  //Delete CultureAge
  Future<void> deleteCultureAge(String ageId) async {
    try {
      await FirebaseFirestore.instance
        .collection('filters')
        .doc('cultures')
        .collection('ages')
        .doc(ageId)
        .delete();
      debugPrint('Age with $ageId deleted');
    } catch (e) {
      debugPrint('Error deleting age: $e');
    }
  }

  //CRUD CultureDays

  //Create CultureDay
  Future<void> addCultureDay(String name, String image) async {
    try {
      await FirebaseFirestore.instance
        .collection('filters')
        .doc('cultures')
        .collection('days')
        .add({
          'name': name,
          'image': image,
        });
      debugPrint('Adding new day $name successfully');
    } catch (e) {
      debugPrint('Error adding day: $e');
    }
  }

  //Read CultureDays
  Future<List<CultureDay>> getCultureDays() async {
    try {
      final snapshot = await FirebaseFirestore.instance
        .collection('filters')
        .doc('cultures')
        .collection('days')
        .get();
      debugPrint('Number of days fetched: ${snapshot.docs.length}');

      return snapshot.docs.map((doc) {
        final data = doc.data();
        final name = data['name'] ?? 'Unknown day';
        final image = data['image'] ?? 'assets/images/glisse.jpg';

        debugPrint('Day fetched: $name, Image: $image');

        return CultureDay(name: name, image: image);
      }).toList();
    } catch (e) {
      debugPrint('Error fetching days: $e');
      return [];
    }
  }

  //Update CultureDay
  Future<void> updateCultureDay(String dayId, String newName, String newImage) async {
    try {
      await FirebaseFirestore.instance
        .collection('filters')
        .doc('cultures')
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

  //Delete CultureDay
  Future<void> deleteCultureDay(String dayId) async {
    try {
      await FirebaseFirestore.instance
        .collection('filters')
        .doc('cultures')
        .collection('days')
        .doc(dayId)
        .delete();
      debugPrint('Day with ID $dayId deleted');
    } catch (e) {
      debugPrint('Error deleting day: $e');
    }
  }


  //CRUD CultureSchedules

  //Create CultureSchedules
  Future<void> addCultureSchedule(String name, String image) async {
    try {
      await FirebaseFirestore.instance
        .collection('filters')
        .doc('cultures')
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

  //Read CultureSchedules
  Future<List<CultureSchedule>> getCultureSchedules() async {
    try {
      final snapshot = await FirebaseFirestore.instance
        .collection('filters')
        .doc('cultures')
        .collection('schedules')
        .get();
      debugPrint('Number of schedules fetched ${snapshot.docs.length}');

      return snapshot.docs.map((doc) {
        final data = doc.data();
        final name = data['name'] ?? 'Unknown schedule';
        final image = data['image'] ?? 'assets/images/glisse.jpg';

        debugPrint('Schedule fetched: $name, Image: $image');

        return CultureSchedule(name: name, image: image);
      }).toList();
    } catch (e) {
      debugPrint('Error fetching schedules: $e');
      return [];
    }
  }


  //Update CultureSchedule
  Future<void> updateCultureSchedule(String scheduleId, String newName, String newImage) async {
    try {
      await FirebaseFirestore.instance
        .collection('filters')
        .doc('cultures')
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

  //Delete CultureSchedule
  Future<void> deleteCultureSchedule(String scheduleId) async {
    try {
      await FirebaseFirestore.instance
        .collection('filters')
        .doc('cultures')
        .collection('schedules')
        .doc(scheduleId)
        .delete();
      debugPrint('Schedule with ID $scheduleId deleted');
    } catch (e) {
      debugPrint('Error deleting schedule: $e');
    }
  }


  //CRUD CultureSectors

  //Create CultureSectors
  Future<void> addCultureSector(String name, String image) async {
    try {
      await FirebaseFirestore.instance
        .collection('filters')
        .doc('cultures')
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

  //Read CultureSectors
  Future<List<CultureSector>> getCultureSectors() async {
    try {
      final snapshot = await FirebaseFirestore.instance
        .collection('filters')
        .doc('cultures')
        .collection('sectors')
        .get();
      debugPrint('Number of sectors fetched: ${snapshot.docs.length}');

      return snapshot.docs.map((doc) {
        final data = doc.data();
        final name = data['name'] ?? 'Unknown sector';
        final image = data['image'] ?? 'assets/images/glisse.jpg';

        debugPrint('Sector fetched: $name, Image: $image');

        return CultureSector(name: name, image: image);
      }).toList();
    } catch (e) {
      debugPrint('Error fetching sectors: $e');
      return [];
    }
  }

  //Update SportSector
  Future<void> updateCultureSector(String sectorId, String newName, String newImage) async {
    try {
      await FirebaseFirestore.instance
        .collection('filters')
        .doc('cultures')
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

  //Delete SportCategory
  Future<void> deleteCultureSector(String sectorId) async {
    try {
      await FirebaseFirestore.instance
        .collection('filters')
        .doc('cultures')
        .collection('sectors')
        .doc(sectorId)
        .delete();
      debugPrint('Sector with ID $sectorId deleted');
    } catch (e) {
      debugPrint('Error deleting sector: $e');
    }
  }
}