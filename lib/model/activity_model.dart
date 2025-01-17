import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityModel {
  final String activityId;
  final String discipline;
  final String information;
  final String imageUrl;
  final Place place;
  final Contact contact;
  final List<Schedule> schedules;
  final List<Pricing> pricings;
  final Filters filters;
  


  ActivityModel({
    required this.activityId,
    required this.discipline,
    required this.information,
    required this.imageUrl,
    required this.place,
    required this.contact,
    required this.schedules,
    required this.pricings,
    required this.filters
    
    /* required this.imageUrl, */

  });

  factory ActivityModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot
  ) {
    final data = snapshot.data();
    if (data == null) {
      return ActivityModel(
        activityId: snapshot.id,
        discipline: '',
        information: '',
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
          postalCode: 50130,
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
      information: data['information'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      contact: Contact.fromMap(data['contact'] ?? {
        'structureName': '',
        'email': '',
        'phoneNumber': '',
        'webSite': '',
      }),
      place: Place.fromMap(data['places'] ?? {
        'titleAddress': '',
        'streetAddress': '',
        'postalCode': 50130,
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
            e as Map<String, dynamic>
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
      'discipline': discipline,
      'information': information,
      'imageUrl': imageUrl,
      'contact': contact.toMap(),
      'places': place.toMap(),
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
  final String email;
  final String phoneNumber;
  final String webSite;

  Contact({
    required this.structureName,
    required this.email,
    required this.phoneNumber,
    required this.webSite,
  });

  factory Contact.fromMap(
    Map<String, dynamic> map
  ) {
    return Contact(
      structureName: map['structureName'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      webSite: map['webSite'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
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
            e as Map<String, dynamic>
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

class Pricing {
  final String profile;
  final String pricing;

  Pricing({
    required this.profile,
    required this.pricing,
  });

  factory Pricing.fromMap(
    Map<String, dynamic> map
  ) {
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

  factory TimeSlot.fromMap(
    Map<String, dynamic> map
  ) {
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
    Map<String, dynamic> map
  ) {
    return Filters(
      categoriesId: (map['categoriesId'] as List? ?? [])
        .map(
          (e) => Map<String, String>.from(
            e as Map
          )
        ).toList(),
      agesId: (map['agesId'] as List? ?? [])
        .map(
          (e) => Map<String, String>.from(
            e as Map
          )
        ).toList(),
      daysId: (map['daysId'] as List? ?? [])
        .map(
          (e) => Map<String, String>.from(
            e as Map
          )
        ).toList(),
      schedulesId: (map['schedulesId'] as List? ?? [])
        .map(
          (e) => Map<String, String>.from(
            e as Map
          )
        ).toList(),
      sectorsId: (map['sectorsId'] as List? ?? [])
        .map(
          (e) => Map<String, String>.from(
            e as Map
          )
        ).toList(),
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