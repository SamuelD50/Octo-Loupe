class ActivityModel {
  final String discipline;
  final List<Schedule> schedules;
  final List<Pricing> pricings;
  final Place place;
  final String information;
  /* final String imageUrl; */


  ActivityModel({
    required this.discipline,
    required this.schedules,
    required this.pricings,
    required this.place,
    required this.information,
    /* required this.imageUrl, */
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    var schedulesFromJson = json['schedules'] as List? ?? [];
    var pricingsFromJson = json['pricings'] as List? ?? [];

    return ActivityModel(
      discipline: json['discipline'] ?? '',
      schedules: schedulesFromJson.map((schedule) => Schedule.fromJson(schedule)).toList(),
      pricings: pricingsFromJson.map((pricing) => Pricing.fromJson(pricing)).toList(),
      place: Place.fromJson(json['place'] ?? {}),
      information: json['information'] ?? '',
    );
  }

  static List<ActivityModel> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => ActivityModel.fromJson(json)).toList();
  }
}

class Schedule {
  final String day;
  final List<TimeSlot> timeSlots;

  Schedule({
    required this.day,
    required this.timeSlots,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    var timeSlotsFromJson = json['timeSlots'] as List? ?? [];
    return Schedule(
      day: json['day'],
      timeSlots: timeSlotsFromJson.map((timeSlot) => TimeSlot.fromJson(timeSlot)).toList(),
    );
  }
}

class TimeSlot {
  final String startHour;
  final String endHour;

  TimeSlot({
    required this.startHour,
    required this.endHour,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      startHour: json['startHour'],
      endHour: json['endHour'],
    );
  }
}

class Pricing {
  final String profile;
  final String pricing;


  Pricing({
    required this.profile,
    required this.pricing,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) {
    return Pricing(
      profile: json['profile'],
      pricing: json['pricing']
    );
  }


}

class Place {
  final String title;
  final String streetAddress;
  final String postalCode;
  final String city;
  final double latitude;
  final double longitude;


  Place({
    required this.title,
    required this.streetAddress,
    required this.postalCode,
    required this.city,
    required this.latitude,
    required this.longitude,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      title: json['title'],
      streetAddress: json['streetAddress'],
      postalCode: json['postalCode'],
      city: json['city'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}