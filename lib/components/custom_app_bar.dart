import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:octoloupe/pages/home_page.dart';
import 'package:octoloupe/pages/legal_notices_page.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  CustomAppBarState createState() => CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class CustomAppBarState extends State<CustomAppBar> {

  @override
  Widget build(BuildContext context) {
    final bool canGoBack = context.canPop();
    return AppBar(
      leading: canGoBack ?
        IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
            size: 25,
          ),
          onPressed: () {
            context.pop();
          },
          tooltip: 'Retour',
        ) :
        Padding(
          padding: EdgeInsets.only(left: 5),
        ),
      /* ModalRoute.of(context)!.canPop ?
        IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
            size: 25,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: 'Retour',
        ) :
        Padding(
          padding: EdgeInsets.only(left: 5)
        ), */
      title: Padding(
        padding: const EdgeInsets.only(right: 55),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/icons/icon_app.webp'),
              backgroundColor: const Color(0xFF5B59B4),
              radius: 22.5,
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
      toolbarHeight: 60,
      actions: [
        PopupMenuButton(
          icon: const Icon(
            Icons.settings,
            color: Colors.white,
          ),
          onSelected: (value) {
            switch (value) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LegalNoticesPage()),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
                break;
              case 3:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 0,
              child: Text(
                'Mentions légales'
              ),
            ),
            const PopupMenuItem(
              value: 1,
              child: Text(
                'Test'
              ),
            ),
            const PopupMenuItem(
              value: 2,
              child: Text(
                'Test'
              ),
            ),
            const PopupMenuItem(
              value: 3,
              child: Text(
                'Test'
              ),
            ),
          ],
        ),
      ],
    );
  }
}
