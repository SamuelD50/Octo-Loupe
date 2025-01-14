import 'package:octoloupe/CRUD/activities_crud.dart';
import 'package:octoloupe/model/activity_model.dart';

class CultureActivityService {
  final ActivitiesCRUD activitiesCRUD = ActivitiesCRUD();

  Future<void> addCultureActivity(String section, String? activityId, String discipline, String information, String titleAddress, String streetAddress, String postalCode, String city, double latitude, double longitude, String day, String startHour, String endHour, String profile, String pricing, List<String> categoriesId, List<String> agesId, List<String> daysId, List<String> schedulesId, List<String> sectorsId) async {
    await activitiesCRUD.createActivity(
      'cultures',
      activityId,
      discipline,
      information,
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

  Future<List<ActivityModel>> getCultureActivities(String section) async {
    try {
      var activitiesData = await activitiesCRUD.getActivities(
        'cultures'
      );
      return activitiesData.map((docSnapshot) {
        final activityId = docSnapshot.id;
        final discipline = docSnapshot['discipline'];
        final information = docSnapshot['information'];
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
          filters: [
            Filters(
              categoriesId: categoriesId,
              agesId: agesId,
              daysId: daysId,
              schedulesId: schedulesId,
              sectorsId: sectorsId,
            )
          ],
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> updateCultureActivity(String activityId, String newDiscipline,
    String newInformation, String newTitleAddress, String newStreetAddress, String newPostalCode, String newCity, double newLatitude, double newLongitude, String newDay, String newStartHour, String newEndHour, String newProfile, String newPricing, List<String> categoriesId, List<String> agesId, List<String> daysId, List<String> schedulesId, List<String> sectorsId) async {
    await activitiesCRUD.createActivity(
      'cultures',
      activityId,
      newDiscipline,
      newInformation,
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
      categoriesId,
      agesId,
      daysId,
      schedulesId,
      sectorsId,
    );
  }

  Future<void> deleteCultureActivity(String activityId) async {
    await activitiesCRUD.deleteActivity(
      'cultures',
      activityId,
    );
  }
}