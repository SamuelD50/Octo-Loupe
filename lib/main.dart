import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:octoloupe/screens/admin_central_page.dart';
import 'package:octoloupe/screens/auth_page.dart';
import 'package:octoloupe/screens/contact_page.dart';
import 'package:octoloupe/screens/home_page.dart';
import 'components/custom_app_bar.dart';
import 'components/custom_navbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:octoloupe/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  NotificationService().initNotification();
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      showSemanticsDebugger: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: TextTheme(
          displaySmall: TextStyle(
            fontFamily: 'Poppins-Regular',
            color: Colors.black,
          ),
          displayMedium: TextStyle(
            fontFamily: 'Poppins-Regular',
            color: Colors.black,
          ),
          displayLarge: TextStyle(
            fontFamily: 'Poppins-Regular',
            color: Colors.black,
          ),
          headlineSmall: TextStyle(
            fontFamily: 'Poppins-Regular',
            color: Colors.black,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'Poppins-Regular',
            color: Colors.black,
          ),
          headlineLarge: TextStyle(
            fontFamily: 'Poppins-Regular',
            color: Colors.black,
          ),
          titleSmall: TextStyle(
            fontFamily: 'Poppins-Regular',
            color: Colors.black,
          ),
          titleMedium: TextStyle(
            fontFamily: 'Poppins-Regular',
            color: Colors.black,
          ),
          titleLarge: TextStyle(
            fontFamily: 'Poppins-Regular',
            color: Colors.black,
          ),
          bodySmall: TextStyle(
            fontFamily: 'Poppins-Regular',
            color: Colors.black,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Poppins-Regular',
            color: Colors.black,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Poppins-Regular',
            color: Colors.black,
          ),
          labelSmall: TextStyle(
            fontFamily: 'Poppins-Regular',
            color: Colors.black,
          ),
          labelMedium: TextStyle(
            fontFamily: 'Poppins-Regular',
            color: Colors.black,
          ),
          labelLarge: TextStyle(
            fontFamily: 'Poppins-Regular',
            color: Colors.black,
          ),
        ),  
      ),
      home: const MainPage(),
      initialRoute: '/',
      routes: {
        '/HomePage': (context) => HomePage(),
        '/AuthPage': (context) => AuthPage(),
        '/ContactPage': (context) => ContactPage(),
        '/AdminCentralPage': (context) => AdminCentralPage(),
      }
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(
    BuildContext context
  ) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Container(),
      bottomNavigationBar: CustomNavBar(),
    );
  }
}