import 'package:cloud_firestore/cloud_firestore.dart';

// Model for 1 message

class ContactModel {
  final String messageId;
  final String title;
  final String firstName;
  final String name;
  final String email;
  final String subject;
  final String body;
  final Map<String, dynamic> timestamp;
  final String timestampFormatted;

  ContactModel({
    required this.messageId,
    required this.title,
    required this.firstName,
    required this.name,
    required this.email,
    required this.subject,
    required this.body,
    required this.timestamp,
  }) : timestampFormatted = _formatTimestamp(timestamp);

    

   static String _formatTimestamp(Map<String, dynamic> timestamp) {
    final now = DateTime.now();
    final day = timestamp['day'];
    final month = timestamp['month'];
    final year = timestamp['year'];
    final hour = timestamp['hour'];
    final minute = timestamp['minute'];

    if (year == now.year && month == now.month && day == now.day) {
      return '$hour:${minute.toString().padLeft(2, '0')}';
    } else {
      return '$day/$month/$year';
    }
  }

  factory ContactModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot
  ) {
    final data = snapshot.data();
    if (data == null) {
      return ContactModel(
        messageId: snapshot.id,
        title: '',
        firstName: '',
        name: '',
        email: '',
        subject: '',
        body: '',
        timestamp: {
          'day': 0,
          'month': 1,
          'year': '0000',
          'hour': '0',
          'minute': '0',
        },
      );
    }

    final timestamp = data['timestamp'] != null ?
      {
        'day': data['timestamp']['day'],
        'month': data['timestamp']['month'],
        'year': data['timestamp']['year'],
        'hour': data['timestamp']['hour'],
        'minute': data['timestamp']['minute'],
      } : {
        'day': 0,
        'month': 1,
        'year': '0000',
        'hour': '0',
        'minute': '0',
      };

    return ContactModel(
      messageId: snapshot.id,
      title: data['title'] ?? '',
      firstName: data['firstName'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      subject: data['subject'] ?? '',
      body: data['body'] ?? '',
      timestamp: timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'firstName': firstName,
      'title': title,
      'name': name,
      'email': email,
      'subject': subject,
      'body': body,
      'timestamp': {
        'day': timestamp['day'],
        'month': timestamp['month'],
        'year': timestamp['year'],
        'hour': timestamp['hour'],
        'minute': timestamp['minute'],
      },
    };
  }

  static Timestamp getFirestoreTimestamp(Map<String, dynamic> timestamp) {
    final dateTime = DateTime(
      timestamp['year'],
      timestamp['month'],
      timestamp['day'],
      timestamp['hour'],
      timestamp['minute'],
    );
    return Timestamp.fromDate(dateTime);
  }
}