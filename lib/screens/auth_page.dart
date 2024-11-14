import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:octoloupe/services/authentication.dart';
import '../components/custom_app_bar.dart';
import '../components/loader_spinning.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  AuthPageState createState() => AuthPageState();
}

//https://www.youtube.com/watch?v=KQKiZx5N_J0

class AuthPageState extends State<AuthPage> {

  final _formSignInKey = GlobalKey<FormState>();
  //Controllers pour la partie Connexion
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    nameController.dispose();
    newEmailController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

 // Toggle SignIn/SignOut?

 // Loading?

  final _formSignUpKey = GlobalKey<FormState>();
  //Controllers pour la partie Création de compte
  final firstNameController = TextEditingController();
  final nameController = TextEditingController();
  final newEmailController = TextEditingController();
  final newPasswordController = TextEditingController();

  bool loading = false;

  final AuthService _authService = AuthService();

  Future<void> _signIn() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      debugPrint('Veuillez entre votre email et mot de passe');
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      UserCredential? userCredential = await _authService.signInWithEmailAndPassword(email, password);

      if (!mounted) return;

      setState(() {
        loading = false;
      });

      if (userCredential != null) {
        debugPrint('Connexion réussie');
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        debugPrint('Connexion failed');
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {  
        loading = false;
      });
      debugPrint('Erreur: $e');
    }
  }

  Future<void> _signUp() async {
    final firstName = firstNameController.text.trim();
    final name = nameController.text.trim();
    final email = newEmailController.text.trim();
    final password = newPasswordController.text.trim();

    if (firstName.isEmpty || name.isEmpty || email.isEmpty || password.isEmpty) {
      debugPrint('Veuillez remplir tous les champs');
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      UserCredential? userCredential = await _authService.createUserWithEmailAndPassword(
        email, password, firstName, name, 'user',
      );

      if (!mounted) return;

      setState(() {
        loading = false;
      });

      if (userCredential != null) {
        debugPrint('Compte créé avec succès');
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        debugPrint('Echec de la création de compte');
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
    return loading ? Loading() : Scaffold(
      appBar: const CustomAppBar(),
      body: Container(
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Connexion',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formSignInKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
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
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Mot de passe',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre mot de passe';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _signIn(),
                        child: const Text('Se connecter'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                const Divider(
                  color: Colors.white,
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),

                const SizedBox(height: 32),

                Text(
                  'Créer un compte',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formSignUpKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: firstNameController,
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
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: nameController,
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
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: newEmailController,
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
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: newPasswordController,
                        decoration: const InputDecoration(
                          labelText: 'Mot de passe',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre mot de passe';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _signUp(),
                        child: const Text('Créer un compte'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}