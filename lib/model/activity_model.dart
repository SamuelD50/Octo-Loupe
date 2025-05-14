import 'package:cloud_firestore/cloud_firestore.dart';

// Model for 1 activity

class ActivityModel {
  final String activityId;
  final String discipline;
  final List<String>? information;
  final String? imageUrl;
  final Place place;
  final Contact contact;
  final List<Schedule> schedules;
  final List<Pricing> pricings;
  final Filters filters;

  ActivityModel({
    required this.activityId,
    required this.discipline,
    this.information,
    this.imageUrl,
    required this.place,
    required this.contact,
    required this.schedules,
    required this.pricings,
    required this.filters
  });

  factory ActivityModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot
  ) {
    final data = snapshot.data();
    if (data == null) {
      return ActivityModel(
        activityId: snapshot.id,
        discipline: '',
        information: [],
        imageUrl: '',
        contact: Contact(
          structureName: '',
          email: '',
          phoneNumber: '',
          webSite: '',
        ),
        place: Place(
          titleAddress: '',
          streetAddress: '',
          postalCode: 00000,
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
        filters:
          Filters(
            categoriesId: [],
            agesId: [],
            daysId: [],
            schedulesId: [],
            sectorsId: [],
          ),
      );
    }

    return ActivityModel(
      activityId: snapshot.id,
      discipline: data['discipline'] ?? '',
      information: (data['information'] as List?)?.map((e) =>
         e as String).toList(),
      imageUrl: data['imageUrl'] as String?,
      contact: Contact.fromMap(data['contact'] ?? {
        'structureName': '',
        'email': '',
        'phoneNumber': '',
        'webSite': '',
      }),
      place: Place.fromMap(data['place'] ?? {
        'titleAddress': '',
        'streetAddress': '',
        'postalCode': 00000,
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
        .map(
          (e) => Schedule.fromMap(
            e as Map<String, dynamic>
          )
        ).toList(),
      pricings: (data['pricings'] as List? ?? [
        {
          'profile': '',
          'pricing': '',
        },
      ])
        .map(
          (e) => Pricing.fromMap(
            e as Map<String, String>
          )
        ).toList(),
      filters: Filters.fromMap(data['filters'] ?? {
        'categoriesId': [],
        'agesId': [],
        'daysId': [],
        'schedulesId': [],
        'sectorsId': [],
      }),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'activityId': activityId,
      'discipline': discipline,
      'information': information ?? [],
      'imageUrl': imageUrl,
      'contact': contact.toMap(),
      'place': place.toMap(),
      'schedules': schedules.map(
        (e) => e.toMap()
      ).toList(),
      'pricings': pricings.map(
        (e) => e.toMap()
      ).toList(),
      'filters': filters.toMap(),
    };
  }
}

class Place {
  final String titleAddress;
  final String streetAddress;
  final int postalCode;
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

  factory Place.fromMap(
    Map<String, dynamic> map
  ) {
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

class Contact {
  final String structureName;
  final String? email;
  final String? phoneNumber;
  final String? webSite;

  Contact({
    required this.structureName,
    this.email,
    this.phoneNumber,
    this.webSite,
  });

  factory Contact.fromMap(
    Map<String, String?> map
  ) {
    return Contact(
      structureName: map['structureName'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      webSite: map['webSite'] ?? '',
    );
  }

  Map<String, String?> toMap() {
    return {
      'structureName': structureName,
      'email': email,
      'phoneNumber': phoneNumber,
      'webSite': webSite,
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

  factory Schedule.fromMap(
    Map<String, dynamic> map
  ) {
    return Schedule(
      day: map['day'] ?? '',
      timeSlots: (map['timeSlots'] as List? ?? [])
        .map(
          (e) => TimeSlot.fromMap(
            e as Map<String, String?>
          )
        ).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'timeSlots': timeSlots.map(
        (e) => e.toMap()
      ).toList(),
    };
  }
}

class TimeSlot {
  final String? startHour;
  final String? endHour;

  TimeSlot({
    required this.startHour,
    required this.endHour,
  });

  factory TimeSlot.fromMap(
    Map<String, String?> map
  ) {
    return TimeSlot(
      startHour: map['startHour'] ?? '',
      endHour: map['endHour'] ?? '',
    );
  }

  Map<String, String?> toMap() {
    return {
      'startHour': startHour,
      'endHour': endHour,
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

  factory Pricing.fromMap(
    Map<String, String> map
  ) {
    return Pricing(
      profile: map['profile'] ?? '',
      pricing: map['pricing'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'profile': profile,
      'pricing': pricing,
    };
  }
}

class Filters {
  final List<Map<String, String>> categoriesId;
  final List<Map<String, String>> agesId;
  final List<Map<String, String>> daysId;
  final List<Map<String, String>> schedulesId;
  final List<Map<String, String>> sectorsId;

  Filters({
    required this.categoriesId,
    required this.agesId,
    required this.daysId,
    required this.schedulesId,
    required this.sectorsId,
  });

  factory Filters.fromMap(
    Map<String, List> map
  ) {
    return Filters(
      categoriesId: (map['categoriesId'] ?? [])
        .map((e) => {
          'id': e['id'] as String,
          'name': e['name'] as String,
        }).toList(),
      agesId: (map['agesId'] ?? [])
        .map((e) => {
          'id': e['id'] as String,
          'name': e['name'] as String,
        }).toList(),
      daysId: (map['daysId'] ?? [])
        .map((e) => {
          'id': e['id'] as String,
          'name': e['name'] as String,
        }).toList(),
      schedulesId: (map['schedulesId'] ?? [])
        .map((e) => {
          'id': e['id'] as String,
          'name': e['name'] as String,
        }).toList(),
      sectorsId: (map['sectorsId'] ?? [])
        .map((e) => {
          'id': e['id'] as String,
          'name': e['name'] as String,
        }).toList(),
    );
  }

  Map<String, List> toMap() {
    return {
      'categoriesId': categoriesId,
      'agesId': agesId,
      'daysId': daysId,
      'schedulesId': schedulesId,
      'sectorsId': sectorsId,
    };
  }
}