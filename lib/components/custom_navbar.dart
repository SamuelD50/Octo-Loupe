import 'package:octoloupe/screens/auth_page.dart';
import 'package:octoloupe/screens/contact_page.dart';
import 'package:octoloupe/screens/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class CustomNavBar extends StatelessWidget {
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  CustomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
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

  List<Widget> _buildScreens() {
    return [
      HomePage(),
      AuthPage(),
      ContactPage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.home),
        title: ("Accueil"),
        textStyle: TextStyle(fontSize:15),
        activeColorPrimary: const Color(0xFFF9BC50),
        inactiveColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(CupertinoIcons.person),
        title: ("Mon compte"),
        textStyle: TextStyle(fontSize:15),
        activeColorPrimary: const Color(0xFFF9BC50),
        inactiveColorPrimary: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.mail),
        title: ("Contact"),
        textStyle: TextStyle(fontSize:15),
        activeColorPrimary: const Color(0xFFF9BC50),
        inactiveColorPrimary: Colors.white,
      ),
    ];
  }
}