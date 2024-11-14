import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/user_model.dart';

class DatabaseService {
  final String uid;

  DatabaseService(this.uid);

  final CollectionReference<Map<String, dynamic>> userCollection = FirebaseFirestore.instance.collection("users");

  //Save user in Firestore
  Future<void> saveUser(UserModel user) async {
    try {
      return await userCollection.doc(user.uid).set(user.toMap());
    } catch (e) {
      debugPrint("Error saving user: $e");
      rethrow;
    }
  }

  //Collect user from Firestore
  Stream<UserModel> getUser(String uid) {
    return userCollection
      .doc(uid)
      .snapshots()
      .map((snapshot) => UserModel.fromFirestore(snapshot));
  }
}