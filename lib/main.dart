import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:octoloupe/screens/admin_central_page.dart';

import 'package:octoloupe/screens/auth_page.dart';
import 'package:octoloupe/screens/contact_page.dart';
import 'package:octoloupe/screens/home_page.dart';
import 'components/custom_app_bar.dart';
import 'components/custom_navbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Container(),
      bottomNavigationBar: CustomNavBar(),
    );
  }
}