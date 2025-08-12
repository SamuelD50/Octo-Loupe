import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:octoloupe/CRUD/user_crud.dart';
import 'package:octoloupe/services/auth_service.dart';

class NavbarProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int index, BuildContext context) async {
    if (_currentIndex == index) return;
    _currentIndex = index;
    notifyListeners();

    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        final currentUser = AuthService().getCurrentUser();
        if (currentUser == null) {
          context.go('/auth');
        } else {
          final user = await UserCRUD().getUser(currentUser.uid);
          if (!context.mounted) return;
          if (user == null) {
            context.go('/auth');
          } else if (user.role == 'admin') {
            context.go('/auth/admin');
          } else if (user.role == 'user') {
            context.go('/auth/user');
          }
        }
        break;
      case 2:
        context.go('/contact');
        break;
    }
  }
}
