import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  CustomAppBarState createState() => CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class CustomAppBarState extends State<CustomAppBar> {
  bool notificationsEnabled = true;

  void _toggleNotifications(BuildContext context) {
    setState(() {
      notificationsEnabled = !notificationsEnabled;
    });

    final snackBar = SnackBar(
      content: Text(notificationsEnabled
        ? 'Notifications activées'
        : 'Notifications désactivées'),
      duration: const Duration(seconds: 5),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    debugPrint(notificationsEnabled ? 'Notifications activées' : 'Notifications désactivées');
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/Octo_Loupe.png'),
            radius: 20,
          ),
          const SizedBox(width: 10),
          const Text(
            'Octo\'Loupe',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF5B59B4),
      toolbarHeight: 70,
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.amber,
            ),
            child: IconButton(
              icon: Icon(
                notificationsEnabled ? Icons.notifications_active : Icons.notifications_off,
                color: Colors.white,
              ),
              onPressed: () => _toggleNotifications(context),
            ),
          ),
        ),
      ],
    );
  }
}