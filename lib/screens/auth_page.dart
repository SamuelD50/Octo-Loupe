import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:octoloupe/model/user_model.dart';
import 'package:octoloupe/screens/admin_central_page.dart';
import 'package:octoloupe/screens/home_page.dart';
import 'package:octoloupe/screens/reset_password_page.dart';
import 'package:octoloupe/services/auth_service.dart';
import 'package:octoloupe/services/database.dart';
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

  final _formSignUpKey = GlobalKey<FormState>();
  //Controllers pour la partie Création de compte
  final firstNameController = TextEditingController();
  final nameController = TextEditingController();
  final newEmailController = TextEditingController();
  final newPasswordController = TextEditingController();

  bool loading = false;
  int _selectedIndex = 0;
  bool _isPasswordVisible = false;
  bool _isNewPasswordVisible = false;

  final AuthService _authService = AuthService();

  Future<void> _signIn() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (_formSignInKey.currentState?.validate() ?? false) {
      setState(() {
        loading = true;
      });

      try {
        UserCredential? userCredential = await _authService.signInWithEmailAndPassword(email, password);

        setState(() {
          loading = false;
        });

        if (userCredential != null) {
          debugPrint('Connected');

          User? user = userCredential.user;
          if (user != null) {
            DatabaseService databaseService = DatabaseService(user.uid);
            UserModel? userDoc = await databaseService.getUser();

            if (userDoc?.role == 'admin') {
              debugPrint('Redirection vers AdminPage');
              if (!mounted) return;
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(builder: (context) => AdminCentralPage()),
              );
            } else {
              debugPrint('Redirection vers HomePage');
              if (!mounted) return;
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            }
          }
        } else {
          debugPrint('Incorrect username/password pair');
        }
      } catch (e) {
        setState(() {  
          loading = false;
        });
        debugPrint('Error: $e');
      }
    } else {
      debugPrint('Connection failed');
    }
  }

  void _resetPassword() {
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => ResetPasswordPage()),
    );
  }

  Future<void> _signUp() async {
    final firstName = firstNameController.text.trim();
    final name = nameController.text.trim();
    final email = newEmailController.text.trim();
    final password = newPasswordController.text.trim();

    if (_formSignUpKey.currentState?.validate() ?? false) {
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
          debugPrint('Account created successfully');
          Navigator.pushReplacementNamed(context, '/HomePage');
        } else {
          debugPrint('Failed to create account');
        }
      } catch (e) {
        if (!mounted) return;

        setState(() {
          loading = false;
        });
        debugPrint('Error: $e');
      }
    } else {
      debugPrint('Form validation failed');
    }
  }

  void _clearFormFields() {
    emailController.clear();
    passwordController.clear();
    firstNameController.clear();
    nameController.clear();
    newEmailController.clear();
    newPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Mon compte',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ToggleButtons(
                    isSelected: [_selectedIndex == 0, _selectedIndex == 1],
                    onPressed: (int index) {
                      setState(() {
                        _selectedIndex = index;
                        _clearFormFields();
                      });
                    },
                    color: Colors.black,
                    selectedColor: Colors.white,
                    fillColor: Color(0xFF5B59B4),
                    borderColor: Color(0xFF5B59B4),
                    selectedBorderColor: Color(0xFF5B59B4),
                    borderRadius:  BorderRadius.circular(20.0),
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 1),
                        child: Center(child: Text('Se connecter')),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 1),
                        child: Center(child: Text('Créer un compte')),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _selectedIndex == 0 ?
                  Form(
                    key: _formSignInKey,
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextFormField(
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
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'Mot de passe',
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
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
                        const SizedBox(height: 5),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                              onPressed: _resetPassword,
                              child: const Text(
                                'Mot de passe oublié ?',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
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
                          onPressed: () => _signIn(),
                          child: Text('Se connecter'),
                        ),
                      ],
                    ),
                  ) :
                  Form(
                    key: _formSignUpKey,
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child:TextFormField(
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
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextFormField(
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
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child:TextFormField(
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
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextFormField(
                            controller: newPasswordController,
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF5B59B4),
                            foregroundColor: Colors.white,
                            side: BorderSide(color: Color(0xFF5B59B4)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          onPressed: () => _signUp(),
                          child: Text('Créer un compte'),
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