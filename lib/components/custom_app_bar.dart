import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  CustomAppBarState createState() => CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class CustomAppBarState extends State<CustomAppBar> {

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: ModalRoute.of(context)!.canPop ?
        IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: 'Retour',
        ) :
        Padding(
          padding: EdgeInsets.only(left: 5)
        ),
      title: Padding(
        padding: const EdgeInsets.only(right: 55),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/Octoloupe.webp'),
              backgroundColor: const Color(0xFF5B59B4),
              radius: 25,
            ),
            const SizedBox(width: 5),
            Text(
              'Octo\'Loupe',
              style: TextStyle(
                fontFamily: 'GreatVibes',
                color: Colors.white,
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF5B59B4),
      toolbarHeight: 70,
      actions: [
        
      ],
    );
  }
}