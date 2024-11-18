import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel {
  final String uid;
  final String email;
  final String password;
  final String firstName;
  final String name;
  final String role;

  UserModel({
    required this.uid,
    required this.email,
    required this.password,
    required this.firstName,
    required this.name,
    required this.role,
  });

  // Convert Firestore document to UserModel instance

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
  final data = snapshot.data();
  if (data == null) {
    debugPrint("Aucune donnée utilisateur trouvée pour l'UID ${snapshot.id}");
    return UserModel(
      uid: snapshot.id,
      email: '',
      password: '',  // Ou une valeur par défaut si nécessaire
      firstName: '',
      name: '',
      role: '',
    );
  }

  return UserModel(
    uid: snapshot.id,
    email: data['email'] ?? '',  // Valeur par défaut si l'email est manquant
    password: data['password'] ?? '',  // Valeur par défaut pour le mot de passe
    firstName: data['firstName'] ?? '',
    name: data['name'] ?? '',
    role: data['role'] ?? '',
  );
  }


  /* factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) throw Exception("User data not found");

    return UserModel(
      uid: snapshot.id,
      email: data['email'],
      password: data['password'],
      firstName: data['firstName'],
      name: data['name'],
      role: data['role'],
    );
  } */

  //Convert UserModel instance to firestore map
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'firstName': firstName,
      'name': name,
      'role': role,
    };
  }
}


