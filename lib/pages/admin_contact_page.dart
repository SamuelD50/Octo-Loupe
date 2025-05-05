import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:octoloupe/components/custom_app_bar.dart';
import 'package:octoloupe/services/contact_service.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminContactPage extends StatefulWidget {
  const AdminContactPage({super.key});

  @override
  AdminContactPageState createState() => AdminContactPageState();
}

  enum ContactMode { reading, deleting }

class AdminContactPageState extends State<AdminContactPage> {

  bool isLoading = false;
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
      Stack(
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
    : Stack(
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
                      fontSize: 30,
                      fontFamily: 'Satisfy-Regular',
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
    );
  }

  Future<void> readMessages() async {
    try {
      setState(() {
        isLoading = true;
      });

      var messagesData = await contactService.getAllMessages();

      messages = messagesData.map((contactModel) {
        return contactModel.toMap();
      }).toList();

      await Future.delayed(Duration(milliseconds: 25));

      setState(() {
        isLoading = false;
      });

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
          
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  offset: Offset(4, 4),
                  blurRadius: 6,
                ),
              ],
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.98,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isOpen = true;
                    selectedMessage = message;
                  });
                },
                child: Card(
                  elevation: 4.0,
                  color: const Color(0xFF5B59B4),
                  shadowColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.red,
                              child: Text(
                                _getInitials(message['firstName'], message['name']),
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
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '${message['subject']}',
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
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          );
        }
      );
  }

  Widget _buildDetailMessage(
    BuildContext context
  ) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  offset: Offset(4, 4),
                  blurRadius: 6,
                ),
              ],
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.98,
              child: Card(
                  elevation: 4.0,
                  color: const Color(0xFF5B59B4),
                  shadowColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
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
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white,
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
        ),
        SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF5B59B4),
            foregroundColor: Colors.white,
            side: BorderSide(
              color: Color(0xFF5B59B4),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
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
              fontSize: 15,
              fontWeight: FontWeight.bold,
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
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          onPressed: () {
            readMessages();
            isOpen = false;
          },
          child: Text(
            'Revenir à la liste',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],   
    );
  }
}