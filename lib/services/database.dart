import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/user_model.dart';
import 'dart:async';

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
  Stream<UserModel?> getUser(String uid) {
    debugPrint('Fetching user with UID: $uid');
    return userCollection
      .doc(uid)
      .snapshots()
      .map((snapshot) {
        if (snapshot.exists) {
          return UserModel.fromFirestore(snapshot);
        } else {
          debugPrint('No user data found for UID: $uid');
          return null;
        }
      }).handleError((error) {
        debugPrint('Error fetching user data: $error');
        return null;
      });
  }
}