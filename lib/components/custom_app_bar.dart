import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:octoloupe/router/app_router.dart';
import 'package:octoloupe/router/router_config.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);
  
  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder<bool>(
      valueListenable: canPopNotifier,
      builder: (context, canPop, _) {
        return AppBar(
          leading: canPop ?
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
                size: 25,
              ),
              onPressed: () {
                GoRouter.of(context).pop();
              },
              tooltip: 'Retour',
            ) :
            Padding(
              padding: EdgeInsets.only(left: 5),
            ),
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
                    context.go('/legalNotices');
                    break;
                  case 1:
                    context.go('/GCU');
                    break;
                  case 2:
                    context.go('/GCS');
                    break;
                  case 3:
                    context.go('/privacyPolicy');
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
                    'CGU'
                  ),
                ),
                const PopupMenuItem(
                  value: 2,
                  child: Text(
                    'CGV'
                  ),
                ),
                const PopupMenuItem(
                  value: 3,
                  child: Text(
                    'Politique de confidentialité'
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}