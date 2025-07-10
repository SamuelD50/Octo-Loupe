import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//This component is used to build the navBar

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onItemSelected;

  static const List<BottomNavigationBarItem> _items = [
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.home),
      label: 'Accueil',
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.person),
      label: 'Compte',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.mail),
      label: 'Contact',
    ),
  ];

  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(
    BuildContext context
  ) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onItemSelected,
      backgroundColor: const Color(0xFF5B59B4),
      selectedItemColor: const Color(0xFFF9BC50),
      unselectedItemColor: Colors.white,
      items: _items,
      type: BottomNavigationBarType.fixed,
    );
  }
}