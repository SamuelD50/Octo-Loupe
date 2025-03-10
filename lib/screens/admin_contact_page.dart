import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:octoloupe/CRUD/contact_crud.dart';
import 'package:octoloupe/components/contact_card.dart';
import 'package:octoloupe/components/custom_app_bar.dart';
import 'package:octoloupe/services/contact_service.dart';
import 'package:octoloupe/model/contact_model.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminContactPage extends StatefulWidget {
  const AdminContactPage({super.key});

  @override
  AdminContactPageState createState() => AdminContactPageState();
}

  enum ContactMode { reading, deleting }

class AdminContactPageState extends State<AdminContactPage> {

  bool isLoading = false;
  ContactMode _currentMode = ContactMode.reading;
  bool isOpen = false;
  String messageId = '';
  Map<String, dynamic>? selectedMessage;

  ContactService contactService = ContactService();
  List<Map<String, dynamic>> messages = [];

  @override
  Widget build(
    BuildContext context
  ) {
    return isLoading ? 
      Scaffold(
        appBar: const CustomAppBar(),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white24,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Center(
                  child: SpinKitSpinningLines(
                    color: Colors.black,
                    size: 60,
                  ),
                )
              )
            )
          ]
        )
      )
    : Scaffold(
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white24,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 32),
                    child: Text(
                      'Formulaire de contact',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  isOpen ?
                    _buildDetailMessage(context)
                    : _buildMessageList(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> readMessages() async {
    try {
      setState(() {
        isLoading = true;
      });

      var messagesData = await contactService.getAllMessages();
      debugPrint('1: $messagesData');

      messages = messagesData.map((contactModel) {
        return contactModel.toMap();
      }).toList();
      debugPrint('2: $messages');

      await Future.delayed(Duration(milliseconds: 25));

      setState(() {
        isLoading = false;
      });

      debugPrint('ReadMessages: $messages');
    } catch (e) {
      debugPrint('Error fetching messages: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    readMessages();
  }

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

  Widget _buildMessageList(
    BuildContext context,
  ) {
    return messages.isEmpty ?
      Center(
        child: Text(
          'Aucun message',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
      ) :
      ListView.builder(
        shrinkWrap: true,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          var message = messages[index];
          
          return ContactCard(
            message: message,
            onTap: () {
              setState(() {
                isOpen = true;
                selectedMessage = message;
              });
            },
          );
        }
      );
  }

  Widget _buildDetailMessage(
    BuildContext context
  ) {
    return Column(
      children: [
        Card(
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
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Objet: ${selectedMessage!['subject']}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.red,
                        child: Text(
                          _getInitials(selectedMessage!['firstName'], selectedMessage!['name']),
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 25),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${selectedMessage!['title']} ${selectedMessage!['firstName']} ${selectedMessage!['name']}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              final String emailUrlString = 'mailto:${selectedMessage!['email']}?subject=Re: ${Uri.encodeComponent(selectedMessage!['subject'])}';

                              if (Platform.isAndroid || Platform.isIOS) {
                                try {
                                  final Uri emailUrl = Uri.parse(emailUrlString);
                                  launchUrl(emailUrl);
                                } catch (e) {
                                  debugPrint('Error: $e');
                                }
                              }
                            },
                            child: Text(
                              '${selectedMessage!['email']}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Text(
                            'Le ${selectedMessage!['timestamp']['day'].toString()} ${_getMonthName(selectedMessage!['timestamp']['month'])} ${selectedMessage!['timestamp']['year'].toString()} à ${selectedMessage!['timestamp']['hour'].toString()}:${selectedMessage!['timestamp']['minute'].toString()}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            )
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SingleChildScrollView(
                    child: Text(
                      selectedMessage!['body'] ?? 'Pas de corps de message',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ),
        SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF5B59B4),
            foregroundColor: Colors.white,
            side: BorderSide(
              color: Color(0xFF5B59B4),
            ),
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          onPressed: () {
            if (selectedMessage != null) {
              ContactService().deleteMessage(selectedMessage!['messageId']);
              readMessages();
              isOpen = false;
            }
          },
          child: Text('Supprimer ce message',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF5B59B4),
            foregroundColor: Colors.white,
            side: BorderSide(
              color: Color(0xFF5B59B4),
            ),
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          onPressed: () {
            readMessages();
            isOpen = false;
          },
          child: Text(
            'Revenir à la liste',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
      ],   
    );
  }
}