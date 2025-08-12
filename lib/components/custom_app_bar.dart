import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:octoloupe/router/app_router.dart';

// This component constitutes the application's appBar

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  List<PopupMenuItem<int>> _buildPopupItems() => const [
    PopupMenuItem(
      value: 0,
      child: Text(
        'Mentions légales'
      ),
    ),
    PopupMenuItem(
      value: 1,
      child: Text(
        'CGU'
      ),
    ),
    PopupMenuItem(
      value: 2,
      child: Text(
        'Politique de confidentialité'
      ),
    ),
  ];
  
  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder<bool>(
      valueListenable: canPopNotifier,
      builder: (context, canPop, _) {
        return AppBar(
          leading: canPop ?
            Semantics(
              label: 'Bouton retour',
              button: true,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Colors.white,
                  size: 25,
                ),
                onPressed: () {
                  GoRouter.of(context).pop();
                },
                tooltip: 'Retour',
              ),
            ) :
            const SizedBox.shrink(),
          title: Padding(
            padding: const EdgeInsets.only(right: 55),
            child: Semantics(
              label: 'Application Octo\'Loupe',
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/icons/icon_app.webp'),
                    backgroundColor: Color(0xFF5B59B4),
                    radius: 22.5,
                  ),
                  SizedBox(width: 5),
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
          ),
          backgroundColor: const Color(0xFF5B59B4),
          toolbarHeight: 60,
          actions: [
            PopupMenuButton(
              tooltip: 'Informations légales',
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
                    context.go('/privacyPolicy');
                    break;
                }
              },
              itemBuilder: (_) => _buildPopupItems(),
            ),
          ],
        );
      },
    );
  }
}