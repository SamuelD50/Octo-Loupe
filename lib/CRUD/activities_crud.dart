import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class ActivitiesCRUD {

  final CollectionReference<Map<String, dynamic>> activitiesCollection =
    FirebaseFirestore.instance.collection('activities');

  Future<void> createActivity(String section, String? activityId, String discipline, String information, String titleAddress, String streetAddress, String postalCode, String city, double latitude, double longitude, String day, String startHour, String endHour, String profile, String pricing, List<String> categoriesId, List<String> agesId, List<String> daysId, List<String> schedulesId, List<String> sectorsId) async {
    try {
      var docSnapshot = await activitiesCollection
        .doc(section)
        .collection('ActivityById')
        .doc(activityId)
        .get();

      if (!docSnapshot.exists) {
        await activitiesCollection
          .doc(section)
          .collection('ActivityById')
          .doc(activityId)
          .set({
            'discipline': discipline,
            'information': information,
            'place': {
              'titleAddress': titleAddress,
              'streetAddress': streetAddress,
              'postalCode': postalCode,
              'city': city,
              'latitude': latitude,
              'longitude': longitude,
            },
            'schedules': [
              {
                'day': day,
                'timeSlots': [
                  {
                    'startHour': startHour,
                    'endHour': endHour,
                  },
                ],
              },
            ],
            'pricings': [
              {
                'profile': profile,
                'pricing': pricing,
              },
            ],
            'filters': [
              {
                'categoriesId': [],
                'agesId': [],
                'daysId': [],
                'schedulesId': [],
                'sectorsId': [],
              },
            ],
          });
        debugPrint('Activity created');
      }
    } catch (e) {
      throw Exception('Erreur lors de la création de l\'activité: $e');
    }
  }

  Future<List<DocumentSnapshot>> getActivities(String section) async {
    try {
      var docSnapshot = await activitiesCollection
        .doc(section)
        .collection('ActivityById')
        .get();
      return docSnapshot.docs;
    } catch (e) {
      throw Exception('Erreur lors de la récupération des activités: $e');
    }
  }

  Future<void> updateActivity(
    String section,
    String activityId,
    String newDiscipline,
    String newInformation,
    String newTitleAddress,
    String newStreetAddress,
    String newPostalCode,
    String newCity,
    double newLatitude,
    double newLongitude,
    String newDay,
    String newStartHour,
    String newEndHour,
    String newProfile,
    String newPricing
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
          .update({
            'discipline': newDiscipline,
            'information': newInformation,
            'place': {
              'titleAddress': newTitleAddress,
              'streetAddress': newStreetAddress,
              'postalCode': newPostalCode,
              'city': newCity,
              'latitude': newLatitude,
              'longitude': newLongitude,
            },
            'schedules': [
              {
                'day': newDay,
                'timeSlots': [
                  {
                    'startHour': newStartHour,
                    'endHour': newEndHour,
                  },
                ],
              },
            ],
            'profile': newProfile,
            'pricing': newPricing,
            'filters': [
              {
                'categoriesId': [],
                'agesId': [],
                'daysId': [],
                'schedulesId': [],
                'sectorsId': [],
              },
            ],
          });
        debugPrint('Activity updated');
      }
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de l\'activité: $e');
    }
  }

  Future<void> deleteActivity(String section, String activityId) async {
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
          .delete();
        debugPrint('Activity deleted');
      }
    } catch (e) {
      throw Exception('Erreur lors de la suppression de l\'activité: $e');
    }
  }

}