import 'package:cloud_firestore/cloud_firestore.dart';

// Model for 1 user

class UserModel {
  final String uid;
  final String email;
  final String firstName;
  final String name;
  final String role;
  final Filters? filtersSport;
  final Filters? filtersCulture;

  UserModel({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.name,
    required this.role,
    this.filtersSport,
    this.filtersCulture,
  });

  // Convert Firestore document to UserModel instance

  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot
  ) {
  final data = snapshot.data();
  if (data == null) {
    return UserModel(
      uid: snapshot.id,
      email: '',
      firstName: '',
      name: '',
      role: '',
      filtersSport: null,
      filtersCulture: null,
    );
  }

  return UserModel(
    uid: snapshot.id,
    email: data['email'] ?? '',
    firstName: data['firstName'] ?? '',
    name: data['name'] ?? '',
    role: data['role'] ?? '',
    filtersSport: Filters.fromMap(data['filtersSport'] ?? {
      'categoriesId': [],
      'agesId': [],
      'daysId': [],
      'schedulesId': [],
      'sectorsId': [],
    }),
    filtersCulture: Filters.fromMap(data['filtersCulture'] ?? {
      'categoriesId': [],
      'agesId': [],
      'daysId': [],
      'schedulesId': [],
      'sectorsId': [],
    }),
  );
  }

  //Convert UserModel instance to firestore map
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'firstName': firstName,
      'name': name,
      'role': role,
      'filtersSport': filtersSport?.toMap(),
      'filtersCulture': filtersCulture?.toMap(),
    };
  }
}

/* class Filters {
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

  Map<String, String> toMap() {
    return {
      'categoriesId': categoriesId,
      'agesId': agesId,
      'daysId': daysId,
      'schedulesId': schedulesId,
      'sectorsId': sectorsId,
    };
  }
} */

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

  factory Filters.fromMap(Map<String, dynamic> map) {
    List<Map<String, String>> parseList(dynamic data) {
      if (data is List) {
        return data
            .where((item) => item is Map)
            .map<Map<String, String>>((item) {
              final mapItem = item as Map;
              return {
                'id': mapItem['id']?.toString() ?? '',
                'name': mapItem['name']?.toString() ?? '',
              };
            }).toList();
      }
      return [];
    }

    return Filters(
      categoriesId: parseList(map['categoriesId']),
      agesId: parseList(map['agesId']),
      daysId: parseList(map['daysId']),
      schedulesId: parseList(map['schedulesId']),
      sectorsId: parseList(map['sectorsId']),
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