import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class ContactCRUD {

  final CollectionReference<Map<String, dynamic>> contactCollection =
    FirebaseFirestore.instance.collection('contacts');

  Future<void> createMessage(String? messageId, String title, String firstName, String name, String email, String subject, String body, DateTime timestamp) async {
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
        debugPrint('Message sent');
      }
    } catch (e) {
      throw Exception('Erreur lors de l\'envoi du message: $e');
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
    } catch (e) {
      throw Exception('Erreur lors de la récupération des messages: $e');
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
        debugPrint('Message deleted');
      }
    } catch (e) {
      throw Exception('Erreur lors de la suppression du message: $e');
    }
  }
}