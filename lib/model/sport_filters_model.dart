import 'package:cloud_firestore/cloud_firestore.dart';

// Model for sport filters

class SportFilterModel {
  final List<SportCategory> categories;
  final List<SportAge> ages;
  final List<SportDay> days;
  final List<SportSchedule> schedules;
  final List<SportSector> sectors;

  SportFilterModel({
    required this.categories,
    required this.ages,
    required this.days,
    required this.schedules,
    required this.sectors,
  });

  factory SportFilterModel.fromFirestore(
    DocumentSnapshot<Map<String, List>> snapshot
  ) {
    final data = snapshot.data();
    if (data == null) {
      return SportFilterModel(
        categories: [],
        ages: [],
        days: [],
        schedules: [],
        sectors: []
      );
    }

    return SportFilterModel(
      categories: (data['categories'] as List)
        .map(
          (e) => SportCategory.fromMap(
            e as Map<String, String>
          )
        ).toList(),
      ages: (data['ages'] as List)
        .map(
          (e) => SportAge.fromMap(
            e as Map<String, String>
          )
        ).toList(),
      days: (data['days'] as List)
        .map(
          (e) => SportDay.fromMap(
            e as Map<String, String>
          )
        ).toList(),
      schedules: (data['schedules'] as List)
        .map(
          (e) => SportSchedule.fromMap(
            e as Map<String, String>
          )
        ).toList(),
      sectors: (data['sectors'] as List)
        .map(
          (e) => SportSector.fromMap(
            e as Map<String, String>
          )
        ).toList(),
    );
  }

  Map<String, List> toMap() {
    return {
      'categories': categories.map(
        (e) => e.toMap()
      ).toList(),
      'ages': ages.map(
        (e) => e.toMap()
      ).toList(),
      'days': days.map(
        (e) => e.toMap()
      ).toList(),
      'schedules': schedules.map(
        (e) => e.toMap()
      ).toList(),
      'sectors': sectors.map(
        (e) => e.toMap()
      ).toList(),
    };
  }
}

class SportCategory {
  final String? id;
  final String name;
  final String imageUrl;

  SportCategory({
    this.id,
    required this.name,
    required this.imageUrl,
  });

  factory SportCategory.fromMap(
    Map<String, String> map, {
      String? id
    }) {
    return SportCategory(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'id': id as String,
      'name': name,
      'imageUrl': imageUrl,
    };
  }
}

class SportAge {
  final String? id;
  final String name;
  final String imageUrl;

  SportAge({
    this.id,
    required this.name,
    required this.imageUrl,
  });

  factory SportAge.fromMap(
    Map<String, String> map, {
      String? id
    }) {
    return SportAge(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'id': id as String,
      'name': name,
      'imageUrl': imageUrl,
    };
  }
}

class SportDay {
  final String? id;
  final String name;
  final String imageUrl;

  SportDay({
    this.id,
    required this.name,
    required this.imageUrl,
  });

  factory SportDay.fromMap(
    Map<String, String> map, {
      String? id
    }) {
    return SportDay(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'id': id as String,
      'name': name,
      'imageUrl': imageUrl,
    };
  }
}

class SportSchedule {
  final String? id;
  final String name;
  final String imageUrl;

  SportSchedule({
    this.id,
    required this.name,
    required this.imageUrl,
  });

  factory SportSchedule.fromMap(
    Map<String, String> map, {
      String? id
    }) {
    return SportSchedule(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'id': id as String,
      'name': name,
      'imageUrl': imageUrl,
    };
  }
}

class SportSector {
  final String? id;
  final String name;
  final String imageUrl;

  SportSector({
    this.id,
    required this.name,
    required this.imageUrl,
  });

  factory SportSector.fromMap(
    Map<String, String> map, {
      String? id
    }) {
    return SportSector(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'id': id as String,
      'name': name,
      'imageUrl': imageUrl,
    };
  }
}