import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';

//Create, read, update and delete filter. Use in combinaison with CultureFilterService, SportFilterService & SportFiltersModel, CultureFiltersModel

class FiltersCRUD {

  final CollectionReference<Map<String, dynamic>> filtersCollection =
    FirebaseFirestore.instance.collection('filters');

  Future<void> createFilter(
    String section,
    String filterType,
    String? filterId,
    String name,
    String imageUrl,
  ) async {
    try {
      String createFilterId = filterId ?? _generateFilterId(section, filterType);
      
      var docSnapshot = await filtersCollection
        .doc(section)
        .collection(filterType)
        .doc(createFilterId)
        .get();

      if (!docSnapshot.exists) {
        await filtersCollection
          .doc(section)
          .collection(filterType)
          .doc(createFilterId)
          .set({
            'name': name,
            'imageUrl': imageUrl,
            'id': createFilterId,
          });
      }
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Error creating filter -> CRUD');
      throw Exception('Error creating filter');
    }
  } 
  
  String _generateFilterId(
    String section,
    String filterType,
  ) {
    return filtersCollection
      .doc(section)
      .collection(filterType)
      .doc().id;
  }

  Future<List<DocumentSnapshot>> getFilters(
    String section,
    String filterType,
  ) async {
    try {
      var docSnapshot = await filtersCollection
        .doc(section)
        .collection(filterType)
        .get();
      return docSnapshot.docs;
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Error fetching filters -> CRUD');
      throw Exception('Error fetching filters');
    }
  }

  Future<void> updateFilter(
    String section,
    String filterType,
    String filterId,
    String newName,
    String newImageUrl,
  ) async {
    try {
      var docSnapshot = await filtersCollection
        .doc(section)
        .collection(filterType)
        .doc(filterId)
        .get();

      if (docSnapshot.exists) {
        await filtersCollection
          .doc(section)
          .collection(filterType)
          .doc(filterId)
          .update({
            'name': newName,
            'imageUrl': newImageUrl,
          });
      }
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Error updating filter -> CRUD');
      throw Exception('Error updating filter');
    }
  }

  Future<void> deleteFilter(
    String section,
    String filterType,
    String filterId,
  ) async {
    try {
      var docSnapshot = await filtersCollection
        .doc(section)
        .collection(filterType)
        .doc(filterId)
        .get();

      if (docSnapshot.exists) {
        await filtersCollection
          .doc(section)
          .collection(filterType)
          .doc(filterId)
          .delete();
      }
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Error deleting filter(s) -> CRUD');
      throw Exception('Error deleting filter(s)');
    }
  }
}