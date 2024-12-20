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
  final String? id;
  final String name;
  final String imageUrl;

  CultureCategory({
    this.id,
    required this.name,
    required this.imageUrl,
  });

  factory CultureCategory.fromMap(Map<String, dynamic> map, {String? id}) {
    return CultureCategory(
      id: id,
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
    };
  }
}

class CultureAge {
  final String? id;
  final String name;
  final String imageUrl;

  CultureAge({
    this.id,
    required this.name,
    required this.imageUrl,
  });

  factory CultureAge.fromMap(Map<String, dynamic> map, {String? id}) {
    return CultureAge(
      id: id,
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
    };
  }
}

class CultureDay {
  final String? id;
  final String name;
  final String imageUrl;

  CultureDay({
    this.id,
    required this.name,
    required this.imageUrl,
  });

  factory CultureDay.fromMap(Map<String, dynamic> map, {String? id}) {
    return CultureDay(
      id: id,
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
    };
  }
}

class CultureSchedule {
  final String? id;
  final String name;
  final String imageUrl;

  CultureSchedule({
    this.id,
    required this.name,
    required this.imageUrl,
  });

  factory CultureSchedule.fromMap(Map<String, dynamic> map, {String? id}) {
    return CultureSchedule(
      id: id,
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
    };
  }
}

class CultureSector {
  final String? id;
  final String name;
  final String imageUrl;

  CultureSector({
    this.id,
    required this.name,
    required this.imageUrl,
  });

  factory CultureSector.fromMap(Map<String, dynamic> map, {String? id}) {
    return CultureSector(
      id: id,
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
    };
  }
}