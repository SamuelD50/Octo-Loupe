import 'package:octoloupe/CRUD/activities_crud.dart';
import 'package:octoloupe/model/activity_model.dart';

class SportActivityService {
  final ActivitiesCRUD activitiesCRUD = ActivitiesCRUD();

  Future<void> addSportActivity(
    String? activityId,
    String discipline,
    String information,
    String imageUrl,
    String structureName,
    String email,
    String phoneNumber,
    String webSite,
    String titleAddress,
    String streetAddress,
    int postalCode,
    String city,
    double latitude,
    double longitude,
    String day,
    String startHour,
    String endHour,
    String profile,
    String pricing,
    List<Map<String, String>> categoriesId,
    List<Map<String, String>> agesId,
    List<Map<String, String>> daysId,
    List<Map<String, String>> schedulesId,
    List<Map<String, String>> sectorsId
  ) async {
    await activitiesCRUD.createActivity(
      'sports',
      activityId,
      discipline,
      information,
      imageUrl,
      structureName,
      email,
      phoneNumber,
      webSite,
      titleAddress,
      streetAddress,
      postalCode,
      city,
      latitude,
      longitude,
      day,
      startHour,
      endHour,
      profile,
      pricing,
      categoriesId,
      agesId,
      daysId,
      schedulesId,
      sectorsId,
    );
  }

  Future<List<ActivityModel>> getSportActivities() async {
    try {
      var activitiesData = await activitiesCRUD.getActivities(
        'sports'
      );
      return activitiesData.map((docSnapshot) {
        final activityId = docSnapshot.id;
        final discipline = docSnapshot['discipline'];
        final information = docSnapshot['information'];
        final imageUrl = docSnapshot['imageUrl'];
        final structureName = docSnapshot['contact']['structureName'];
        final email = docSnapshot['contact']['email'];
        final phoneNumber = docSnapshot['contact']['phoneNumber'];
        final webSite = docSnapshot['contact']['webSite'];
        final titleAddress = docSnapshot['place']['titleAddress'];
        final streetAddress = docSnapshot['place']['streetAddress'];
        final postalCode = docSnapshot['place']['postalCode'];
        final city = docSnapshot['place']['city'];
        final latitude = docSnapshot['place']['latitude'];
        final longitude = docSnapshot['place']['longitude'];
        final day = docSnapshot['schedules']['day'];
        final startHour = docSnapshot['timeSlot']['startHour'];
        final endHour = docSnapshot['timeSlot']['endHour'];
        final profile = docSnapshot['pricings']['profile'];
        final pricing = docSnapshot['pricings']['pricing'];
        final categoriesId = docSnapshot['filters']['categoriesId'];
        final agesId = docSnapshot['filters']['agesId'];
        final daysId = docSnapshot['filters']['daysId'];
        final schedulesId = docSnapshot['filters']['schedulesId'];
        final sectorsId = docSnapshot['filters']['sectorsId'];

        return ActivityModel(
          activityId: activityId,
          discipline: discipline,
          information: information,
          imageUrl: imageUrl,
          contact: Contact(
            structureName: structureName,
            email: email,
            phoneNumber: phoneNumber,
            webSite: webSite,
          ),
          place: Place(
            titleAddress: titleAddress,
            streetAddress: streetAddress,
            postalCode: postalCode,
            city: city,
            latitude: latitude,
            longitude: longitude,
          ),
          schedules: [
            Schedule(
              day: day,
              timeSlots: [
                TimeSlot(
                  startHour: startHour,
                  endHour: endHour,
                ),
              ],
            ),
          ],
          pricings: [
            Pricing(
              profile: profile,
              pricing: pricing,
            ),
          ],
          filters: Filters(
            categoriesId: categoriesId,
            agesId: agesId,
            daysId: daysId,
            schedulesId: schedulesId,
            sectorsId: sectorsId,
          ),
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> updateSportActivity(
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
    List<Map<String, String>> newSectorsId
  ) async {
    await activitiesCRUD.createActivity(
      'sports',
      activityId,
      newDiscipline,
      newInformation,
      newImageUrl,
      newStructureName,
      newEmail,
      newPhoneNumber,
      newWebSite,
      newTitleAddress,
      newStreetAddress,
      newPostalCode,
      newCity,
      newLatitude,
      newLongitude,
      newDay,
      newStartHour,
      newEndHour,
      newProfile,
      newPricing,
      newCategoriesId,
      newAgesId,
      newDaysId,
      newSchedulesId,
      newSectorsId,
    );
  }

  Future<void> deleteSportActivity(
    String activityId
  ) async {
    await activitiesCRUD.deleteActivity(
      'sports',
      activityId,
    );
  }
}