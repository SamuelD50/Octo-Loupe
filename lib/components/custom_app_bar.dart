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
        IconButton(
          icon: Icon(
            notificationsEnabled ? Icons.notifications : Icons.notifications_off,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              notificationsEnabled = !notificationsEnabled;
            });
            debugPrint(notificationsEnabled ? 'Notifications activées' : 'Notifications désactivées');
          },
        ),
      ],
    );
  }
}