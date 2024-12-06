import 'package:flutter/material.dart';
import 'package:octoloupe/components/custom_app_bar.dart';
import 'package:octoloupe/screens/auth_page.dart';
import 'package:octoloupe/services/auth_service.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  ResetPasswordPageState createState() => ResetPasswordPageState();
}

class ResetPasswordPageState extends State<ResetPasswordPage> {

  bool loading = false;
  final AuthService _authService = AuthService();
  final _formResetPasswordKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  Future<void> _resetPassword() async {
    final String email = emailController.text.trim();

    if (email.isEmpty) {
      debugPrint('Veuillez entre votre email');
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      await _authService.sendPasswordResetEmail(email);

      setState(() {
        loading = false;
      });

      debugPrint('Reinitialisation email is sending to $email');

      if (!mounted) return;
      Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => AuthPage()),
    );

    } catch (e) {
      if (!mounted) return;

      setState(() {  
        loading = false;
      });
      debugPrint('Erreur: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [
                  Color(0xFF5D71FF),
                  Color(0xFFF365C7),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Form(
                    key: _formResetPasswordKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(
                            'Réinitialiser son mot de passe',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child:TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer votre email';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF5B59B4),
                            foregroundColor: Colors.white,
                            side: BorderSide(color: Color(0xFF5B59B4)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          onPressed: () => _resetPassword(),
                          child: Text('Envoyer un email de réinitilisation'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  } 
}