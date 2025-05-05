import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:octoloupe/components/custom_app_bar.dart';
import 'package:octoloupe/pages/auth_page.dart';
import 'package:octoloupe/services/auth_service.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  ResetPasswordPageState createState() => ResetPasswordPageState();
}

class ResetPasswordPageState extends State<ResetPasswordPage> {

  void setLoading(bool value) {
    setState(() {
      loading = value;
    });
  }
  
  bool loading = false;
  final AuthService _authService = AuthService();
  final _formResetPasswordKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  Widget build(
    BuildContext context
  ) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white24,
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
                        padding: const EdgeInsets.only(top: 32),
                        child: Text(
                          'Réinitialiser son mot de passe',
                          style: TextStyle(
                            fontFamily: 'Satisfy-Regular',
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.98,
                        child:TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Ex: abc@exemple.com',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer votre email';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF5B59B4),
                          foregroundColor: Colors.white,
                          side: BorderSide(color: Color(0xFF5B59B4)),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        onPressed: () {
                          if (_formResetPasswordKey.currentState?.validate() ?? false) {
                            _authService.sendPasswordResetEmail(
                              emailController.text,
                              context: context,
                              setLoading: setLoading,
                            );
                            context.pop('/auth');
                          }  
                        },
                        child: Text(
                          'Envoyer un email de réinitilisation',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 32),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  } 
}