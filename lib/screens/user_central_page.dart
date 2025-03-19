import 'package:flutter/material.dart';
import 'package:octoloupe/components/custom_app_bar.dart';


class UserCentralPage extends StatefulWidget {
  const UserCentralPage({super.key});

  @override
  UserCentralPageState createState() => UserCentralPageState();
}

class UserCentralPageState extends State<UserCentralPage> {

  bool notificationsEnabled = true;

  void _toggleNotifications(
    BuildContext context
  ) {
    setState(() {
      notificationsEnabled = !notificationsEnabled;
    });

    final snackBar = SnackBar(
      content: Text(notificationsEnabled ?
        'Notifications activées' : 'Notifications désactivées'
      ),
      duration: const Duration(seconds: 5),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    debugPrint(notificationsEnabled ?
      'Notifications activées' : 'Notifications désactivées'
    );
  }

  @override
  Widget build(
    BuildContext context
  ) {
    return Scaffold(
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
                  //
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.amber,
                      ),
                      child: IconButton(
                        icon: Icon(
                          notificationsEnabled ?
                            Icons.notifications_active : Icons.notifications_off,
                          color: Colors.white,
                        ),
                        onPressed: () => _toggleNotifications(context),
                      ),
                    ),
                  ),
                  //
                ],
              ),
            ),
          ),
        ],
      ),
    );
  } 
}