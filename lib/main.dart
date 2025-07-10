import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:octoloupe/CRUD/user_crud.dart';
import 'package:octoloupe/model/user_model.dart';
import 'package:octoloupe/router/app_router.dart';
import 'package:octoloupe/router/router_config.dart';
import 'package:octoloupe/services/auth_service.dart';
import 'package:octoloupe/services/firebase_messaging_service.dart';
import 'package:octoloupe/services/local_notifications_services.dart';
import 'components/custom_app_bar.dart';
import 'components/custom_navbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'web_url_strategy_stub.dart'
  if (dart.library.html) 'web_url_strategy_real.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
/*   await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  ); */
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  configureWebUrlStrategy();

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  final localNotificationsService = LocalNotificationsService.instance();
  await localNotificationsService.init();

  final firebaseMessagingService = FirebaseMessagingService.instance();
  await firebaseMessagingService.init(localNotificationsService: localNotificationsService);
  
  runApp(
    const MyApp()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(
    BuildContext context
  ) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      showSemanticsDebugger: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins-Regular',
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: Colors.black,
          displayColor: Colors.black,
        ),  
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  final Widget child;
  
  const MainPage({
    super.key,
    required this.child,
  });

  @override
  Widget build(
    BuildContext context
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final canPop = GoRouter.of(context).canPop();
      if (canPopNotifier.value != canPop) {
        canPopNotifier.value = canPop;
      }
    });
    final currentIndex = _getCurrentIndex(context);
    return SafeArea(
      child: Scaffold(
        appBar: const CustomAppBar(),
        body: child,
        bottomNavigationBar: CustomNavBar(
          currentIndex: currentIndex,
          onItemSelected: (index) => _onItemTapped(context, index),
        ),
      ),
    );
  }
}

int _getCurrentIndex(
  BuildContext context,
) {
  final location = GoRouterState.of(context).uri.toString();

  if (location.startsWith('/home')) return 0;
  if (location.startsWith('/auth')) return 1;
  if (location.startsWith('/contact')) return 2;

  return 0;
}

void _onItemTapped(
  BuildContext context,
  int index,
) async {
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