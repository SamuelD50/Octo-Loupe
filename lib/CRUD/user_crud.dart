import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/user_model.dart';
import 'dart:async';

class UserCRUD {
  final String? uid;

  UserCRUD([this.uid]);

  final CollectionReference<Map<String, dynamic>> userCollection =
    FirebaseFirestore.instance.collection("users");

  Future<void> createUser(UserModel user) async{
    try {
      final querySnapshot = await userCollection
        .where('email', isEqualTo: user.email)
        .get();

      if (querySnapshot.docs.isEmpty) {
        await userCollection
        .doc(user.uid)
        .set(
          user.toMap()
        );
      }
      debugPrint('User created');
    } catch (e) {
      debugPrint('Error creating user: $e');
    }
  }

  Future<UserModel?> getUser() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
        await userCollection
        .doc(uid)
        .get();

      if (snapshot.exists) {
        return UserModel.fromFirestore(snapshot);
      } else {
        debugPrint('User not found');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching user: $e');
    }
    return null;
  }

  Future<void> updateUser(UserModel user) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await userCollection.doc(user.uid).get();
      
      if (!snapshot.exists) {
        debugPrint('User not found');
        return;
      }
      await userCollection.doc(user.uid).update(user.toMap());
      debugPrint('User updated');
    } catch (e) {
      debugPrint("Error updating user: $e");
    }
  }

  Future<void> deleteUser() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await userCollection.doc(uid).get();
      if (!snapshot.exists) {
        return;
      }

      await userCollection.doc(uid).delete();
      debugPrint('User deleted');
    } catch (e) {
      debugPrint('Error deleting user: $e');
    }
  }

  Future<bool> checkIfUserExists(String email) async {
    try {
      final querySnapshot = await userCollection
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Erreur lors de la vérification de l\'utilisateir: ${e.toString()}');
    }
  }
}