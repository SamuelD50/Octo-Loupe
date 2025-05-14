import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:octoloupe/model/activity_model.dart';
import 'dart:async';

// Create, Read, Update or Delete an activity. Use in combination with ActivityModel, SportActivityService & CultureActivityService for th evariations

class ActivitiesCRUD {

  final CollectionReference<Map<String, dynamic>> activitiesCollection =
    FirebaseFirestore.instance.collection('activities');

  Future<void> createActivity(
    String section,
    String? activityId,
    ActivityModel activityModel,
  ) async {
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
      }
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Error creating activity -> CRUD');
      throw Exception('Error creating activity');
      
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
      return querySnapshot.docs;
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Error fetching activities -> CRUD');
      throw Exception('Error fetching activities');
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
      }
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Error updating activity -> CRUD');
      throw Exception('Error updating activity(ies)');
    }
  }

  Future<void> deleteActivities(
    String section,
    List<String> activityIds
  ) async {
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
        }
      }
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Error deleting activity(ies) -> CRUD');
      throw Exception('Error deleting activity(ies)');
    }
  }
}