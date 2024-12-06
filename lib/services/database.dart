import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/user_model.dart';
import 'dart:async';

class DatabaseService {
  final String? uid;

  DatabaseService([this.uid]);

  final CollectionReference<Map<String, dynamic>> userCollection =
    FirebaseFirestore.instance.collection("users");

  // CRUD user

  Future<void> createUser(UserModel user) async{
    try {
      await userCollection
        .doc(user.uid)
        .set(
          user.toMap()
        );
      debugPrint('User created with UID: ${user.uid}');
    } catch (e) {
      debugPrint('Error creating user: $e');
      rethrow;
    }
  }

  Stream<UserModel?> getUserStream() {
    if (uid == null || uid!.isEmpty) {
      debugPrint('UID is required for fetching user data');
      return Stream.value(null);
    }

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
      });
  }

  Future<UserModel?> getUser() async {
    if (uid == null || uid!.isEmpty) {
      debugPrint('UID is required to fetch user');
      return null;
    }

    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
        await userCollection.doc(uid).get();
      if (snapshot.exists) {
        return UserModel.fromFirestore(snapshot);
      } else {
        debugPrint('User not found with UID: $uid');
      }
    } catch (e) {
      debugPrint('Error fetching user: $e');
    }
    return null;
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await userCollection.doc(user.uid).update(user.toMap());
      debugPrint('User updated with UID: ${user.uid}');
    } catch (e) {
      debugPrint("Error updating user: $e");
      rethrow;
    }
  }

  Future<void> deleteUser() async {
    if (uid == null || uid!.isEmpty) {
      debugPrint('UID is required to delete user');
      return;
    }

    try {
      await userCollection.doc(uid).delete();
      debugPrint('User deleted with UID: $uid');
    } catch (e) {
      debugPrint('Error deleting user: $e');
      rethrow;
    }
  }

  final CollectionReference<Map<String, dynamic>> filtersCollection =
    FirebaseFirestore.instance.collection('filters');

  Future<void> createFilter(String section, String filterType, String? filterId, String name, String imageUrl) async {
    try {
      String createFilterId = filterId ?? _generateFilterId(section, filterType);
      
      var docSnapshot = await filtersCollection
        .doc(section)
        .collection(filterType)
        .doc(createFilterId)
        .get();

      if (!docSnapshot.exists) {
        await filtersCollection
          .doc(section)
          .collection(filterType)
          .doc(createFilterId)
          .set({
            'name': name,
            'imageUrl': imageUrl,
            'id': createFilterId,
          });
        debugPrint('Added new $name filter in $filterType in section $section with ID $createFilterId successfully');
      } else {
        debugPrint('Filter with ID $createFilterId already exists in $filterType in $section');
      }
    } catch (e) {
      debugPrint('Error adding $name filter : $e');
    }
  } 
  
  String _generateFilterId(String section, String filterType) {
    return filtersCollection
      .doc(section)
      .collection(filterType)
      .doc().id;
  }

  Future<List<DocumentSnapshot>> getFilters(String section, String filterType) async {
    try {
      var docSnapshot = await filtersCollection
        .doc(section)
        .collection(filterType)
        .get();
      debugPrint('Fetched ${docSnapshot.docs.length} filter IDs for $filterType in $section');
      return docSnapshot.docs;
    } catch (e) {
      debugPrint('Error fetching filter IDs for $filterType in $section: $e');
      return [];
    }
  }


  Future<void> updateFilter(String section, String filterType, String filterId, String newName, String newImageUrl) async {
    try {
      var docSnapshot = await filtersCollection
        .doc(section)
        .collection(filterType)
        .doc(filterId)
        .get();

      if (docSnapshot.exists) {
        await filtersCollection
          .doc(section)
          .collection(filterType)
          .doc(filterId)
          .update({
            'name': newName,
            'imageUrl': newImageUrl,
          });
        debugPrint('$newName filter updated successfully in $filterType in $section with ID: $filterId');
      } else {
        debugPrint('Filter with ID $filterId does not exist in $filterType in $section');
      }
    } catch (e) {
      debugPrint('Error updating $newName filter: $e');
    }
  }

  Future<void> deleteFilter(String section, String filterType, String filterId) async {
    try {
      var docSnapshot = await filtersCollection
        .doc(section)
        .collection(filterType)
        .doc(filterId)
        .get();

      if (docSnapshot.exists) {
        await filtersCollection
          .doc(section)
          .collection(filterType)
          .doc(filterId)
          .delete();
        debugPrint('Filter with ID $filterId deleted successfully from $filterType in $section');
      }
    } catch (e) {
      debugPrint('Error deleting filter with ID $filterId: $e');
    }
  }
}

/* Future<void> createUser(UserModel user) async{
    try {
      await userCollection.doc(user.uid).set(user.toMap());
      debugPrint('User created with UID: ${user.uid}');
    } catch (e) {
      debugPrint('Error creating user: $e');
      rethrow;
    }
  } */