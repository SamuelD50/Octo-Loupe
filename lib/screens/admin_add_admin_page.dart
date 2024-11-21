import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:octoloupe/components/custom_app_bar.dart';
import 'package:octoloupe/screens/admin_central_page.dart';
import 'package:octoloupe/services/authentication.dart';

class AdminAddAdminPage extends StatefulWidget {
  const AdminAddAdminPage({super.key});

  @override
  AdminAddAdminPageState createState() => AdminAddAdminPageState();
}

class AdminAddAdminPageState extends State<AdminAddAdminPage> {

  final _formSignUpAdminKey = GlobalKey<FormState>();
  //Controller pour la créationd de compte admin
  final firstNameAdminController = TextEditingController();
  final nameAdminController = TextEditingController();
  final newEmailAdminController = TextEditingController();
  final newPasswordAdminController = TextEditingController();

  bool loading = false;

  bool _isNewPasswordVisible = false;

  final AuthService _authService = AuthService();
  
  Future<void> _signUpAdmin() async {
    final firstName = firstNameAdminController.text.trim();
    final name = nameAdminController.text.trim();
    final email = newEmailAdminController.text.trim();
    final password = newPasswordAdminController.text.trim();

    if (firstName.isEmpty || name.isEmpty || email.isEmpty || password.isEmpty) {
      debugPrint('Veuillez remplir tous les champs');
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      UserCredential? userCredential = await _authService.createUserWithEmailAndPassword(
        email, password, firstName, name, 'admin',
      );

      if(!mounted) return;

      setState(() {
        loading = false;
      });

      if (userCredential != null) {
        debugPrint('Compte administrateur créé avec succès');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminCentralPage()),
        );
      } else {
        debugPrint('Echec de la création de compte administrateur');
      }
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
                    key: _formSignUpAdminKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(
                            'Ajouter un profil administrateur',
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
                            controller: firstNameAdminController,
                            decoration: const InputDecoration(
                              labelText: 'Prénom',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer votre prénom';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextFormField(
                            controller: nameAdminController,
                            decoration: const InputDecoration(
                              labelText: 'Nom',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer votre nom';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child:TextFormField(
                            controller: newEmailAdminController,
                            decoration: const InputDecoration(
                              labelText: 'E-mail',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer votre e-mail';
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                return 'Veuillez entrer un e-mail valide';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextFormField(
                            controller: newPasswordAdminController,
                            obscureText: !_isNewPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'Mot de passe',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isNewPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isNewPasswordVisible = !_isNewPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer votre mot de passe';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: () => _signUpAdmin(),
                          child: const Text('Créer un compte'),
                        ),
                        const SizedBox(height: 32),
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