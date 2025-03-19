import 'package:octoloupe/CRUD/activities_crud.dart';
import 'package:octoloupe/model/activity_model.dart';

class SportActivityService {
  final ActivitiesCRUD activitiesCRUD = ActivitiesCRUD();

  Future<void> addSportActivity(
    String? activityId,
    String discipline,
    List<String>? information,
    String? imageUrl,
    String structureName,
    String? email,
    String? phoneNumber,
    String? webSite,
    String titleAddress,
    String streetAddress,
    int postalCode,
    String city,
    double latitude,
    double longitude,
    List<Schedule> schedules,
    List<Pricing> pricings,
    List<Map<String, String>> categoriesId,
    List<Map<String, String>> agesId,
    List<Map<String, String>> daysId,
    List<Map<String, String>> schedulesId,
    List<Map<String, String>> sectorsId
  ) async {
    final activityModel = ActivityModel(
      activityId: activityId ?? '',
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
      schedules: schedules,
      pricings: pricings,
      filters: Filters(
        categoriesId: categoriesId,
        agesId: agesId,
        daysId: daysId,
        schedulesId: schedulesId,
        sectorsId: sectorsId,
      ),
    );

    await activitiesCRUD.createActivity(
      'sports',
      activityId,
      activityModel,
    );
  }

  /* Future<List<ActivityModel>> getSportActivities() async {
    try {
      var querySnapshot = await activitiesCRUD.getActivities('sports');
      return querySnapshot.map((doc) {
        return ActivityModel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>);
      }).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des activités sportives: $e');
    }
  } */

 Future<List<ActivityModel>> getSportActivities() async {
  try {
    var activitiesData = await activitiesCRUD.getActivities('sports');
    return activitiesData.map((docSnapshot) {
      /* debugPrint('ActivitiesData: ${docSnapshot.data()}'); */
      final activityId = docSnapshot.id;
      final discipline = docSnapshot['discipline'];
      final information = (docSnapshot['information'] is List) ?
        (docSnapshot['information'] as List).map((e) => e as String).toList() :
        null;
      final imageUrl = docSnapshot['imageUrl'] as String?;
      final structureName = docSnapshot['contact']['structureName'];
      final email = docSnapshot['contact']['email'] as String?;
      final phoneNumber = docSnapshot['contact']['phoneNumber'] as String?;
      final webSite = docSnapshot['contact']['webSite'] as String?;
      final titleAddress = docSnapshot['place']['titleAddress'];
      final streetAddress = docSnapshot['place']['streetAddress'];
      final postalCode = docSnapshot['place']['postalCode'];
      final city = docSnapshot['place']['city'];
      final latitude = docSnapshot['place']['latitude'];
      final longitude = docSnapshot['place']['longitude'];
      List<Schedule> schedules = [];
      for (var schedule in docSnapshot['schedules']) {
        final day = schedule['day'];
        List<TimeSlot> timeSlots = [];
        for (var timeSlot in schedule['timeSlots']) {
          timeSlots.add(TimeSlot(
            startHour: timeSlot['startHour'],
            endHour: timeSlot['endHour'],
          ));
        }
        schedules.add(Schedule(day: day, timeSlots: timeSlots));
      }
      final pricings = (docSnapshot['pricings'] as List).map((pricingDoc) {
        return Pricing(
          profile: pricingDoc['profile'],
          pricing: pricingDoc['pricing'],
        );
      }).toList();
      final categoriesId = (docSnapshot['filters']['categoriesId'] as List)
          .map((e) => {
            'id': e['id'] as String,
            'name': e['name'] as String,
          }).toList();
        final agesId = (docSnapshot['filters']['agesId'] as List)
          .map((e) => {
            'id': e['id'] as String,
            'name': e['name'] as String,
          }).toList();
        final daysId = (docSnapshot['filters']['daysId'] as List)
          .map((e) => {
            'id': e['id'] as String,
            'name': e['name'] as String,
          }).toList();
        final schedulesId = (docSnapshot['filters']['schedulesId'] as List)
          .map((e) => {
            'id': e['id'] as String,
            'name': e['name'] as String,
          }).toList();
        final sectorsId = (docSnapshot['filters']['sectorsId'] as List)
          .map((e) => {
            'id': e['id'] as String,
            'name': e['name'] as String,
          }).toList();

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
        schedules: schedules,
        pricings: pricings,
        filters: Filters(
          categoriesId: categoriesId,
          agesId: agesId,
          daysId: daysId,
          schedulesId: schedulesId,
          sectorsId: sectorsId,
        )
      );
    }).toList();
  } catch (e) {
    throw Exception('Erreur lors de la récupération des activités sportives: $e');
  }
 }

  Future<void> updateSportActivity(
    String activityId,
    String newDiscipline,
    List<String>? newInformation,
    String? newImageUrl,
    String newStructureName,
    String? newEmail,
    String? newPhoneNumber,
    String? newWebSite,
    String newTitleAddress,
    String newStreetAddress,
    int newPostalCode,
    String newCity,
    double newLatitude,
    double newLongitude,
    List<Schedule> newSchedules,
    List<Pricing> newPricings,
    List<Map<String, String>> newCategoriesId,
    List<Map<String, String>> newAgesId,
    List<Map<String, String>> newDaysId,
    List<Map<String, String>> newSchedulesId,
    List<Map<String, String>> newSectorsId
  ) async {
    final activityModel = ActivityModel(
      activityId: activityId,
      discipline: newDiscipline,
      information: newInformation,
      imageUrl: newImageUrl,
      contact: Contact(
        structureName: newStructureName,
        email: newEmail,
        phoneNumber: newPhoneNumber,
        webSite: newWebSite,
      ),
      place: Place(
        titleAddress: newTitleAddress,
        streetAddress: newStreetAddress,
        postalCode: newPostalCode,
        city: newCity,
        latitude: newLatitude,
        longitude: newLongitude,
      ),
      schedules: newSchedules,
      pricings: newPricings,
      filters: Filters(
        categoriesId: newCategoriesId,
        agesId: newAgesId,
        daysId: newDaysId,
        schedulesId: newSchedulesId,
        sectorsId: newSectorsId,
      ),
    );

    await activitiesCRUD.updateActivity(
      'sports',
      activityId,
      activityModel,
    );
  }

  Future<void> deleteSportActivities(
    List<String> activityIds
  ) async {
    await activitiesCRUD.deleteActivities(
      'sports',
      activityIds,
    );
  }
}