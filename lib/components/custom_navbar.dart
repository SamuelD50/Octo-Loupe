import 'package:go_router/go_router.dart';
import 'package:octoloupe/pages/auth_page.dart';
import 'package:octoloupe/pages/contact_page.dart';
import 'package:octoloupe/pages/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/* class CustomNavBar extends StatelessWidget {
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  CustomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: [],
      items: _navBarsItems(context),
      onItemSelected: (index) {
        switch (index) {
          case 0:
            context.go('/home');
            break;
          case 1:
            context.go('/auth');
            break;
          case 2:
            context.go('/contact');
            break;
        }
      },
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardAppears: true,
      popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      backgroundColor: const Color(0xFF5B59B4),
      isVisible: true,
      animationSettings: const NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimationSettings(
          animateTabTransition: true,
          duration: Duration(milliseconds: 200),
          screenTransitionAnimationType: ScreenTransitionAnimationType.fadeIn,
        ),
      ),
      confineToSafeArea: true,
      navBarHeight: 70,
      navBarStyle: NavBarStyle.simple,
    );
  }

  /* List<Widget> _buildScreens() {
    return [
      HomePage(),
      AuthPage(),
      ContactPage(),
    ];
  } */

  List<PersistentBottomNavBarItem> _navBarsItems(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth < 225 ? 13 : 15;
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.home),
        title: ("Accueil"),
        textStyle: TextStyle(fontSize: fontSize),
        activeColorPrimary: const Color(0xFFF9BC50),
        inactiveColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.person),
        title: ("Compte"),
        textStyle: TextStyle(fontSize: fontSize),
        activeColorPrimary: const Color(0xFFF9BC50),
        inactiveColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.mail),
        title: ("Contact"),
        textStyle: TextStyle(fontSize: fontSize),
        activeColorPrimary: const Color(0xFFF9BC50),
        inactiveColorPrimary: Colors.white,
      ),
    ];
  }
} */

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onItemSelected;

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
      items: [
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
      ],
    );
  }
}

