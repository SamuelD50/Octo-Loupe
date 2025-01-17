import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class ActivitiesCRUD {

  final CollectionReference<Map<String, dynamic>> activitiesCollection =
    FirebaseFirestore.instance.collection('activities');

  Future<void> createActivity(String section, String? activityId, String discipline, String information, String imageUrl, String structureName, String email, String phoneNumber, String webSite,  String titleAddress, String streetAddress, int postalCode, String city, double latitude, double longitude, String day, String startHour, String endHour, String profile, String pricing, List<Map<String, String>> categoriesId, List<Map<String, String>> agesId, List<Map<String, String>> daysId, List<Map<String, String>> schedulesId, List<Map<String, String>> sectorsId) async {
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
          .set({
            'discipline': discipline,
            'information': information,
            'imageUrl': imageUrl,
            'contact': {
              'structureName': structureName,
              'email': email,
              'phoneNumber': phoneNumber,
              'webSite': webSite,
            },
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
            'filters': {
              'categoriesId': categoriesId,
              'agesId': agesId,
              'daysId': daysId,
              'schedulesId': schedulesId,
              'sectorsId': sectorsId,
            },
          });
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
    String newImageUrl,
    String newStructureName,
    String newEmail,
    String newPhoneNumber,
    String newWebSite,
    String newTitleAddress,
    String newStreetAddress,
    int newPostalCode,
    String newCity,
    double newLatitude,
    double newLongitude,
    String newDay,
    String newStartHour,
    String newEndHour,
    String newProfile,
    String newPricing,
    List<Map<String, String>> newCategoriesId,
    List<Map<String, String>> newAgesId,
    List<Map<String, String>> newDaysId,
    List<Map<String, String>> newSchedulesId,
    List<Map<String, String>> newSectorsId,
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
            'imageUrl': newImageUrl,
            'contact': {
              'structureName': newStructureName,
              'email': newEmail,
              'phoneNumber': newPhoneNumber,
              'webSite': newWebSite,
            },
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
            'filters': {
              'categoriesId': newCategoriesId,
              'agesId': newAgesId,
              'daysId': newDaysId,
              'schedulesId': newSchedulesId,
              'sectorsId': newSectorsId,
            },
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