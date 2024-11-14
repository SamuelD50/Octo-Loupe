import 'package:cloud_firestore/cloud_firestore.dart';

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
    if (data == null) throw Exception("User data not found");

    return UserModel(
      uid: snapshot.id,
      email: data['email'],
      password: data['password'],
      firstName: data['firstName'],
      name: data['name'],
      role: data['role'],
    );
  }

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


