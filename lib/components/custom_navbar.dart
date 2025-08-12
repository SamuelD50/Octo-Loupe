import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:octoloupe/providers/navbar_provider.dart';
import 'package:provider/provider.dart';

//This component is used to build the navBar

class CustomNavbar extends StatelessWidget {
  const CustomNavbar({
    super.key,
  });

  static const List<BottomNavigationBarItem> _items = [
    BottomNavigationBarItem(
      icon: Icon(
        CupertinoIcons.home,
        semanticLabel: 'Accueil',
      ),
      label: 'Accueil',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        CupertinoIcons.person,
        semanticLabel: 'Compte',  
      ),
      label: 'Compte',
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.mail,
        semanticLabel: 'Contact',
      ),
      label: 'Contact',
    ),
  ];

  @override
  Widget build(
    BuildContext context
  ) {
    final navbarProvider = context.watch<NavbarProvider>();

    return Selector<NavbarProvider, int>(
      selector: (_, provider) => provider.currentIndex,
      builder: (_, currentIndex, __) {
        return BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => context.read<NavbarProvider>().setIndex(index, context),
          backgroundColor: const Color(0xFF5B59B4),
          selectedItemColor: const Color(0xFFF9BC50),
          unselectedItemColor: Colors.white,
          items: _items,
          type: BottomNavigationBarType.fixed,
        );
      },
    );
  }
}