import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:octoloupe/model/user_model.dart';
import 'dart:async';

//Create, read, update and delete user. Use in combinaison with UserModel & AuthService

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
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Error creating user -> CRUD');
      throw Exception('Error creating user');
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
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Error fetching user -> CRUD');
      throw Exception('Error fetching user');
    }
  }

  Future<void> updateUser(
    String uid,
    UserModel userModel,
  ) async {
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
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Error updating user -> CRUD');
      throw Exception("Error updating user");
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
      }
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Error deleting user -> CRUD');
      throw Exception('Error deleting user');
    }
  }

  Future<bool> checkIfUserExists(String email) async {
    try {
      final querySnapshot = await usersCollection
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Error cheching user -> CRUD');
      throw Exception('Error checking if user exists');
    }
  }
}