import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class FiltersCRUD {

  final CollectionReference<Map<String, dynamic>> filtersCollection =
    FirebaseFirestore.instance.collection('filters');

  Future<void> createFilter(String section, String filterType, String? filterId, String name, String imageUrl) async {
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
        debugPrint('Filter created');
      }
    } catch (e) {
      throw Exception('Erreur lors de la création du filtre: $e');
    }
  } 
  
  String _generateFilterId(String section, String filterType) {
    return filtersCollection
      .doc(section)
      .collection(filterType)
      .doc().id;
  }

  Future<List<DocumentSnapshot>> getFilters(String section, String filterType) async {
    try {
      var docSnapshot = await filtersCollection
        .doc(section)
        .collection(filterType)
        .get();
      return docSnapshot.docs;
    } catch (e) {
      throw Exception('Erreur lors de la récupération des filtres: $e');
    }
  }


  Future<void> updateFilter(String section, String filterType, String filterId, String newName, String newImageUrl) async {
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
        debugPrint('Filter updated');
      }
    } catch (e) {
      debugPrint('Error updating filter: $e');
    }
  }

  Future<void> deleteFilter(String section, String filterType, String filterId) async {
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
        debugPrint('Filter deleted');
      }
    } catch (e) {
      debugPrint('Error deleting filter: $e');
    }
  }
}