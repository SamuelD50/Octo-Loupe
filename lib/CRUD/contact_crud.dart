import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';

// Create, read, delete messages. Use in combination with ContactService & ContactModel

class ContactCRUD {

  final CollectionReference<Map<String, dynamic>> contactCollection =
    FirebaseFirestore.instance.collection('contacts');

  Future<void> createMessage(
    String? messageId,
    String title,
    String firstName,
    String name,
    String email,
    String subject,
    String body,
    DateTime timestamp,
  ) async {
    try {
      String createMessageId = messageId ?? _generateMessageId();

      var docSnapshot = await contactCollection
        .doc(createMessageId)
        .get();

      if (!docSnapshot.exists) {
        var timestampMap = {
          'day': timestamp.day,
          'month': timestamp.month,
          'year': timestamp.year,
          'hour': timestamp.hour,
          'minute': timestamp.minute,
        };

        await contactCollection
          .doc(createMessageId)
          .set({
            'messageId': createMessageId,
            'title': title,
            'firstName': firstName,
            'name': name,
            'email': email,
            'subject': subject,
            'body': body,
            'timestamp': timestampMap,
          });
      }
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Error creating message -> CRUD');
      throw Exception('Error creating message');
    }
  }

  String _generateMessageId() {
    return contactCollection
      .doc().id;
  }

  Future<List<DocumentSnapshot>> getMessages() async {
    try {
      var docSnapshot = await contactCollection
        .orderBy('timestamp', descending: true)
        .get();
      return docSnapshot.docs;
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Error fetching messages -> CRUD');
      throw Exception('Error fetching messages');
    }
  }

  Future<void> deleteMessage(String messageId) async {
    try {
      var docSnapshot = await contactCollection
        .doc(messageId)
        .get();

      if (docSnapshot.exists) {
        await contactCollection
          .doc(messageId)
          .delete();
      }
    } catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(e, stackTrace, reason: 'Error deleting messages(s) -> CRUD');
      throw Exception('Error deleting message(s)');
    }
  }
}