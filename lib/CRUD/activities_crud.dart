import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:octoloupe/model/activity_model.dart';
import 'dart:async';

class ActivitiesCRUD {

  final CollectionReference<Map<String, dynamic>> activitiesCollection =
    FirebaseFirestore.instance.collection('activities');

  Future<void> createActivity(String section, String? activityId, ActivityModel activityModel) async {
    try {
      String createActivityId = activityId ?? _generateActivityId(section);

      var docSnapshot = await activitiesCollection
        .doc(section)
        .collection('ActivityById')
        .doc(createActivityId)
        .get();

      if (!docSnapshot.exists) {
        await activitiesCollection
          .doc(section)
          .collection('ActivityById')
          .doc(createActivityId)
          .set(
            activityModel.toMap()
          );
        debugPrint('Activity created');
      }
    } catch (e) {
      throw Exception('Erreur lors de la création de l\'activité: $e');
    }
  }

  String _generateActivityId(String section) {
    return activitiesCollection
      .doc(section)
      .collection('ActivityById')
      .doc().id;
  }

  Future<List<DocumentSnapshot>> getActivities(String section) async {
    try {
      var querySnapshot = await activitiesCollection
        .doc(section)
        .collection('ActivityById')
        .get();
        debugPrint('QuerySnapshot activitesCRUD: ${querySnapshot.docs}');
      return querySnapshot.docs;
    } catch (e) {
      throw Exception('Erreur lors de la récupération des activités: $e');
    }
  }

  Future<void> updateActivity(
    String section,
    String activityId,
    ActivityModel activityModel,
  ) async {
    try {
      var docSnapshot = await activitiesCollection
        .doc(section)
        .collection('ActivityById')
        .doc(activityId)
        .get();

      if (docSnapshot.exists) {
        await activitiesCollection
          .doc(section)
          .collection('ActivityById')
          .doc(activityId)
          .update(
            activityModel.toMap(),
          );
        debugPrint('Activity updated');
      }
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de l\'activité: $e');
    }
  }

  Future<void> deleteActivities(String section, List<String> activityIds) async {
    try {
      for (String activityId in activityIds) {
        var docSnapshot = await activitiesCollection
          .doc(section)
          .collection('ActivityById')
          .doc(activityId)
          .get();

        if (docSnapshot.exists) {
          await activitiesCollection
            .doc(section)
            .collection('ActivityById')
            .doc(activityId)
            .delete();
          debugPrint('Activity(ies) deleted');
        }
      }
    } catch (e) {
      throw Exception('Erreur lors de la suppression de(s) l\'activité(s): $e');
    }
  }
}