import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:octoloupe/CRUD/contact_crud.dart';
import 'package:octoloupe/model/contact_model.dart';
import 'package:octoloupe/components/snackbar.dart';
import 'package:flutter/material.dart';

class ContactService {
  final ContactCRUD contactCRUD = ContactCRUD();

  Future<void> sendMessage(
    String? messageId,
    String title,
    String firstName,
    String name,
    String email,
    String subject,
    String body,
    DateTime timestamp, {
      required BuildContext context,
      required Function(bool) setLoading
    }
  ) async {
    try {
      setLoading(true);

      String escapedFirstName = escapeHtml(firstName);
      String escapedName = escapeHtml(name);
      String escapedEmail = escapeHtml(email);
      String escapedSubject = escapeHtml(subject);
      String escapedBody = escapeHtml(body);

      await contactCRUD.createMessage(
        messageId,
        title,
        escapedFirstName,
        escapedName,
        escapedEmail,
        escapedSubject,
        escapedBody,
        timestamp,
      );

      setLoading(false);

      if (context.mounted) {
        CustomSnackBar(
          message: 'Message envoyé avec succès',
          backgroundColor: Colors.green,
        ).showSnackBar(context);
      }
    } on FirebaseException catch (e, stackTrace) {
      setLoading(false);

      if (context.mounted) {
        CustomSnackBar(
          message: 'Erreur lors de l\'envoi du message',
          backgroundColor: Colors.red,
        ).showSnackBar(context);
      }

      FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: 'Error sending message -> Service',
        information: ['errorCode: ${e.code}']  
      );
    }
  }

  String escapeHtml(String input) {
    return input
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;')
      .replaceAll("'", '&#39;');
  }

  Future<List<ContactModel>> getAllMessages() async {
    try {
      var messagesData = await contactCRUD.getMessages();

      return messagesData.map((docSnapshot) {
        final messageId = docSnapshot['messageId'];
        final title = docSnapshot['title'];
        final firstName = docSnapshot['firstName'];
        final name = docSnapshot['name'];
        final email = docSnapshot['email'];
        final subject = docSnapshot['subject'];
        final body = docSnapshot['body'];
        final timestampMap = docSnapshot['timestamp'] as Map<String, dynamic>;
        final timestamp = DateTime(
          timestampMap['year'],
          timestampMap['month'],
          timestampMap['day'],
          timestampMap['hour'],
          timestampMap['minute'],
        );

        return ContactModel(
          messageId: messageId,
          title: title,
          firstName: firstName,
          name: name,
          email: email,
          subject: subject,
          body: body,
          timestamp: {
            'year': timestamp.year,
            'month': timestamp.month,
            'day': timestamp.day,
            'hour': timestamp.hour,
            'minute': timestamp.minute,
          },
        );
      }).toList();
    } on FirebaseException catch (e, stackTrace) {
      FirebaseCrashlytics.instance.recordError(
        e,
        stackTrace,
        reason: 'Error fetching messages -> Service',
        information: ['errorCode: ${e.code}']   
      );

      throw Exception('Error fetching messages');
    }
  }

  Future<void> deleteMessage(
    String messageId
  ) async {
    await contactCRUD.deleteMessage(
      messageId,
    );
  }
}