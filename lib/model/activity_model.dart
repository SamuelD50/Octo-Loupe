import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityModel {
  final String activityId;
  final String discipline;
  final String information;
  final Place place;
  final List<Schedule> schedules;
  final List<Pricing> pricings;
  final List<Filters> filters;
  /* final String imageUrl; */


  ActivityModel({
    required this.activityId,
    required this.discipline,
    required this.information,
    required this.place,
    required this.schedules,
    required this.pricings,
    required this.filters,
    
    /* required this.imageUrl, */

  });

  factory ActivityModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) {
      return ActivityModel(
        activityId: snapshot.id,
        discipline: '',
        information: '',
        place: Place(
          titleAddress: '',
          streetAddress: '',
          postalCode: '',
          city: '',
          latitude: 0.0,
          longitude: 0.0,
        ),
        schedules: [
          Schedule(
            day: '',
            timeSlots: [
              TimeSlot(
                startHour: '',
                endHour: '',
              ),
            ],
          ),
        ],
        pricings: [
          Pricing(
            profile: '',
            pricing: '',
          ),
        ],
        filters: [
          Filters(
            categoriesId: [],
            agesId: [],
            daysId: [],
            schedulesId: [],
            sectorsId: [],
          ),
        ],
      );
    }

    return ActivityModel(
      activityId: snapshot.id,
      discipline: data['discipline'] ?? '',
      information: data['information'] ?? '',
      place: Place.fromMap(data['places'] ?? {
        'titleAddress': '',
        'streetAddress': '',
        'postalCode': '',
        'city': '',
        'latitude': 0.0,
        'longitude': 0.0,
      }),
      schedules: (data['schedules'] as List? ?? [
        {
          'day': '',
          'timeSlots': [
            {
              'startHour': '',
              'endHour': '',
            },
          ],
        },
      ])
        .map((e) => Schedule.fromMap(e as Map<String, dynamic>))
        .toList(),
      pricings: (data['pricings'] as List? ?? [
        {
          'profile': '',
          'pricing': '',
        },
      ])
        .map((e) => Pricing.fromMap(e as Map<String, dynamic>))
        .toList(),
      filters: (data['filters'] as List? ?? [
        {
          'categoriesId': [],
          'agesId': [],
          'daysId': [],
          'schedulesId': [],
          'sectorsId': [],
        },
      ])
        .map((e) => Filters.fromMap(e as Map<String, dynamic>))
        .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'discipline': discipline,
      'information': information,
      'places': place.toMap(),
      'schedules': schedules.map((e) => e.toMap()).toList(),
      'pricings': pricings.map((e) => e.toMap()).toList(),
      'filters': filters.map((e) => e.toMap()).toList(),
    };
  }
}

class Place {
  final String titleAddress;
  final String streetAddress;
  final String postalCode;
  final String city;
  final double latitude;
  final double longitude;

  Place({
    required this.titleAddress,
    required this.streetAddress,
    required this.postalCode,
    required this.city,
    required this.latitude,
    required this.longitude,
  });

  factory Place.fromMap(Map<String, dynamic> map) {
    return Place(
      titleAddress: map['titleAddress'] ?? '',
      streetAddress: map['streetAddress'] ?? '',
      postalCode: map['postalCode'] ?? '',
      city: map['city'] ?? '',
      latitude: map['latitude'] ?? '',
      longitude: map['longitude'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titleAddress': titleAddress,
      'streetAddress': streetAddress,
      'postalCode': postalCode,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class Schedule {
  final String day;
  final List<TimeSlot> timeSlots;

  Schedule({
    required this.day,
    required this.timeSlots,
  });

  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      day: map['day'] ?? '',
      timeSlots: (map['timeSlots'] as List? ?? [])
        .map((e) => TimeSlot.fromMap(e as Map<String, dynamic>))
        .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'timeSlots': timeSlots.map((e) => e.toMap()).toList(),
    };
  }
}

class Pricing {
  final String profile;
  final String pricing;

  Pricing({
    required this.profile,
    required this.pricing,
  });

  factory Pricing.fromMap(Map<String, dynamic> map) {
    return Pricing(
      profile: map['profile'] ?? '',
      pricing: map['pricing'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'profile': profile,
      'pricing': pricing,
    };
  }
}

class TimeSlot {
  final String startHour;
  final String endHour;

  TimeSlot({
    required this.startHour,
    required this.endHour,
  });

  factory TimeSlot.fromMap(Map<String, dynamic> map) {
    return TimeSlot(
      startHour: map['startHour'] ?? '',
      endHour: map['endHour'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'startHour': startHour,
      'endHour': endHour,
    };
  }
}

class Filters {
  final List<String> categoriesId;
  final List<String> agesId;
  final List<String> daysId;
  final List<String> schedulesId;
  final List<String> sectorsId;

  Filters({
    required this.categoriesId,
    required this.agesId,
    required this.daysId,
    required this.schedulesId,
    required this.sectorsId,
  });

  factory Filters.fromMap(Map<String, dynamic> map) {
    return Filters(
      categoriesId: (map['categoriesId'] as List? ?? [])
        .map((e) => e as String)
        .toList(),
      agesId: (map['agesId'] as List? ?? [])
        .map((e) => e as String)
        .toList(),
      daysId: (map['daysId'] as List? ?? [])
        .map((e) => e as String)
        .toList(),
      schedulesId: (map['schedulesId'] as List? ?? [])
        .map((e) => e as String)
        .toList(),
      sectorsId: (map['sectorsId'] as List? ?? [])
        .map((e) => e as String)
        .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoriesId': categoriesId,
      'agesId': agesId,
      'daysId': daysId,
      'schedulesId': schedulesId,
      'sectorsId': sectorsId,
    };
  }
}