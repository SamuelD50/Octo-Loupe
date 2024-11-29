import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CultureFilterModel {
  final List<CultureCategory> categories;
  final List<CultureAge> ages;
  final List<CultureDay> days;
  final List<CultureSchedule> schedules;
  final List<CultureSector> sectors;

  CultureFilterModel({
    required this.categories,
    required this.ages,
    required this.days,
    required this.schedules,
    required this.sectors,
  });

  factory CultureFilterModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) {
      debugPrint('Aucune donnée trouvée pour la section Culture');
      return CultureFilterModel(
        categories: [],
        ages: [],
        days: [],
        schedules: [],
        sectors: []
      );
    }

    return CultureFilterModel(
      categories: (data['categories'] as List? ?? [])
        .map((e) => CultureCategory.fromMap(e as Map<String, dynamic>))
        .toList(),
      ages: (data['ages'] as List? ?? [])
        .map((e) => CultureAge.fromMap(e as Map<String, dynamic>))
        .toList(),
      days: (data['days'] as List? ?? [])
        .map((e) => CultureDay.fromMap(e as Map<String, dynamic>))
        .toList(),
      schedules: (data['schedules'] as List? ?? [])
        .map((e) => CultureSchedule.fromMap(e as Map<String, dynamic>))
        .toList(),
      sectors: (data['sectors'] as List? ?? [])
        .map((e) => CultureSector.fromMap(e as Map<String, dynamic>))
        .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categories': categories.map((e) => e.toMap()).toList(),
      'ages': ages.map((e) => e.toMap()).toList(),
      'days': days.map((e) => e.toMap()).toList(),
      'schedules': schedules.map((e) => e.toMap()).toList(),
      'sectors': sectors.map((e) => e.toMap()).toList(),
    };
  }
}

class CultureCategory {
  final String id;
  final String name;
  final String image;

  CultureCategory({
    required this.id,
    required this.name,
    required this.image,
  });

  factory CultureCategory.fromMap(Map<String, dynamic> map) {
    return CultureCategory(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      image: map['image'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
    };
  }
}

class CultureAge {
  final String id;
  final String name;
  final String image;

  CultureAge({
    required this.id,
    required this.name,
    required this.image,
  });

  factory CultureAge.fromMap(Map<String, dynamic> map) {
    return CultureAge(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      image: map['image'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
    };
  }
}

class CultureDay {
  final String id;
  final String name;
  final String image;

  CultureDay({
    required this.id,
    required this.name,
    required this.image,
  });

  factory CultureDay.fromMap(Map<String, dynamic> map) {
    return CultureDay(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      image: map['image'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
    };
  }
}

class CultureSchedule {
  final String id;
  final String name;
  final String image;

  CultureSchedule({
    required this.id,
    required this.name,
    required this.image,
  });

  factory CultureSchedule.fromMap(Map<String, dynamic> map) {
    return CultureSchedule(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      image: map['image'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
    };
  }
}

class CultureSector {
  final String id;
  final String name;
  final String image;

  CultureSector({
    required this.id,
    required this.name,
    required this.image,
  });

  factory CultureSector.fromMap(Map<String, dynamic> map) {
    return CultureSector(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      image: map['image'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
    };
  }
}