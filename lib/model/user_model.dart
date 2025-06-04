import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:octoloupe/model/topic_model.dart';

// Model for 1 user

class UserModel {
  final String uid;
  final String email;
  final String firstName;
  final String name;
  final String role;
  final String? fcmToken;
  final List<TopicModel>? topicsSport;
  final List<TopicModel>? topicsCulture;

  UserModel({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.name,
    required this.role,
    this.fcmToken,
    this.topicsSport,
    this.topicsCulture,
  });

  // Convert Firestore document to UserModel instance

  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot
  ) {
  final data = snapshot.data();

  debugPrint('Data: $data');
  if (data == null) {
    return UserModel(
      uid: snapshot.id,
      email: '',
      firstName: '',
      name: '',
      role: '',
      fcmToken: null,
      topicsSport: null,
      topicsCulture: null,
    );
  }

  return UserModel(
    uid: snapshot.id,
    email: data['email'] ?? '',
    firstName: data['firstName'] ?? '',
    name: data['name'] ?? '',
    role: data['role'] ?? '',
    fcmToken: data['fcmToken'],
    topicsSport: (data['topicsSport'] as List?)
      ?.map((e) => TopicModel.fromMap(e as Map<String, dynamic>))
      .toList(),
    topicsCulture: (data['topicsCulture'] as List?)
      ?.map((e) => TopicModel.fromMap(e as Map<String, dynamic>))
      .toList(),
  );
  }

  //Convert UserModel instance to firestore map
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'firstName': firstName,
      'name': name,
      'role': role,
      'fcmToken': fcmToken,
      'topicsSport': topicsSport
        ?.map((e) => e.toMap())
        .toList(),
      'topicsCulture': topicsCulture
        ?.map((e) => e.toMap())
        .toList(),
    };
  }
}