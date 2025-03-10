import 'package:flutter/material.dart';

class ContactCard extends StatelessWidget {
  final Map<String, dynamic> message;
  final VoidCallback onTap;

  const ContactCard({
    super.key,
    required this.message,
    required this.onTap,
  });

  String _getInitials(String firstName, String name) {
    return '${firstName.substring(0, 1)}${name.substring(0, 1)}';
  }

  String _getMonthName(int month) {
    const monthsNames = [
      'Janvier',
      'Février',
      'Mars',
      'Avril',
      'Mai',
      'Juin',
      'Juillet',
      'Août',
      'Septembre',
      'Octobre',
      'Novembre',
      'Décembre'
    ];

    if (month >= 1 && month <= 12) {
      return monthsNames[month - 1];
    } else {
      return 'Mois inconnu';
    }
  }

  @override
  Widget build(
    BuildContext context
  ) {
    String initials = _getInitials(message['firstName'], message['name']);

    return Card(
      color: Color(0xFF5D71FF),
      surfaceTintColor: Color(0xFF5B59B4),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0xFF5B59B4),
              offset: Offset(4, 4),
              blurRadius: 4,
            ),
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(16),
          title: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.red,
                child: Text(
                  initials,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${message['title']} ${message['firstName']} ${message['name']}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Objet: ${message['subject']}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      message['body'] != null && message['body']!.length > 50 ?
                        message['body']!.substring(0, 50)
                        : message['body'] ?? 'Pas de corps',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Text(
                '${message['timestamp']['day'].toString()} ${_getMonthName(message['timestamp']['month'])} ${message['timestamp']['year'].toString()}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                )
              ),
              SizedBox(width: 4),
              Text(
                '${message['timestamp']['hour'].toString()}:${message['timestamp']['minute'].toString()}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                )
              ),
            ]
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}