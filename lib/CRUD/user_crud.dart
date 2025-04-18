import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:octoloupe/model/user_model.dart';
import 'dart:async';

class UserCRUD {
  final String? uid;

  UserCRUD([this.uid]);

  final CollectionReference<Map<String, dynamic>> usersCollection =
    FirebaseFirestore.instance.collection("users");

  Future<void> createUser(UserModel userModel) async{
    try {
      final docSnapshot = await usersCollection
        .where('email', isEqualTo: userModel.email)
        .get();

      if (docSnapshot.docs.isEmpty) {
        await usersCollection
        .doc(userModel.uid)
        .set(
          userModel.toMap()
        );
      }
      debugPrint('User created');
    } catch (e) {
      throw Exception('Erreur lors de la création de l\'utilisateur: $e');
    }
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      final docSnapshot = await usersCollection
        .doc(uid)
        .get();

      if (docSnapshot.exists) {
        return UserModel.fromFirestore(docSnapshot);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'utilisateur: $e');
    }
  }

  Future<void> updateUser(String uid, UserModel userModel) async {
    try {
      var docSnapshot = await usersCollection
        .doc(userModel.uid)
        .get();

      if (docSnapshot.exists) {
        await usersCollection
          .doc(userModel.uid)
          .update(
            userModel.toMap(),
          );
      }
      debugPrint('User updated');
    } catch (e) {
      throw Exception("Erreur lors de la mise à jour de l'utilisateur: $e");
    }
  }

  Future<void> deleteUser(String uid) async {
    try {
      var docSnapshot = await usersCollection
        .doc(uid)
        .get();

      if (docSnapshot.exists) {
        await usersCollection
          .doc(uid)
          .delete();
        debugPrint('User deleted');
      }
    } catch (e) {
      throw Exception('Erreur lors de la suppression de l\'utilisateur: $e');
    }
  }

  Future<bool> checkIfUserExists(String email) async {
    try {
      final querySnapshot = await usersCollection
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Erreur lors de la vérification de l\'utilisateir: ${e.toString()}');
    }
  }
}