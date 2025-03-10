import 'package:flutter/material.dart';
import 'package:octoloupe/screens/reset_password_page.dart';
import 'package:octoloupe/services/auth_service.dart';
import 'package:octoloupe/components/custom_app_bar.dart';
import 'package:octoloupe/components/loader_spinning.dart';

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

  final _formSignUpUserKey = GlobalKey<FormState>();
  //Controllers pour la partie Création de compte
  final firstNameController = TextEditingController();
  final nameController = TextEditingController();
  final newEmailController = TextEditingController();
  final newPasswordController = TextEditingController();

  bool loading = false;
  int _selectedIndex = 0;
  bool _isPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  int failedAttempts = 0;
  bool isButtonDisabled = false;

  final AuthService _authService = AuthService();

  void setLoading(bool value) {
    setState(() {
      loading = value;
    });
  }

  void _resetPassword() {
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(
        builder: (context) => ResetPasswordPage()
      ),
    );
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
  Widget build(
    BuildContext context
  ) {
    return loading ? Loading() : Scaffold(
      appBar: const CustomAppBar(),
      body: Stack(
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Text(
                      'Mon compte',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 32),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      EdgeInsetsGeometry padding;

                      if (constraints.maxWidth < 325) {
                        padding = EdgeInsets.symmetric(horizontal: 30.0, vertical: 1.0);
                      } else {
                        padding = EdgeInsets.symmetric(horizontal: 40.0, vertical: 1.0);
                      }

                      return ToggleButtons(
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
                        direction: constraints.maxWidth < 325 ?
                          Axis.vertical
                          : Axis.horizontal,
                        children: [
                          Container(
                            padding: padding,
                            child: Center(child: Text('Se connecter')),
                          ),
                          Container(
                            padding: padding,
                            child: Center(child: Text('Créer un compte')),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _selectedIndex == 0 ?
                  Form(
                    key: _formSignInKey,
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              labelText: 'E-mail',
                              hintText: 'Ex: abc@exemple.com',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer un email';
                              }
                              if (!RegExp(
                                r'^[^@]+@[^@]+\.[^@]+'
                              ).hasMatch(value)) {
                                return 'Veuillez entrer un e-mail valide';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.95,
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
                                return 'Veuillez entrer un mot de passe';
                              }
                              return null;
                            },
                          ),
                        ),
                        /* const SizedBox(height: 2), */
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.95,
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
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF5B59B4),
                            foregroundColor: Colors.white,
                            side: BorderSide(color: Color(0xFF5B59B4)),
                            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          onPressed: isButtonDisabled ?
                            null :
                            () {
                            if (_formSignInKey.currentState?.validate() ?? false) {
                              _authService.signIn(
                                emailController.text,
                                passwordController.text,
                                context: context,
                                setLoading: setLoading,
                              );
                            }
                          },
                          child: Text('Se connecter',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ) :
                  Form(
                    key: _formSignUpUserKey,
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.95,
                          child:TextFormField(
                            controller: firstNameController,
                            decoration: const InputDecoration(
                              labelText: 'Prénom',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer un prénom';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: TextFormField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              labelText: 'Nom',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer un nom';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.95,
                          child:TextFormField(
                            controller: newEmailController,
                            decoration: const InputDecoration(
                              labelText: 'E-mail',
                              hintText: 'Ex: abc@exemple.com',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer votre e-mail';
                              }
                              if (!RegExp(
                                r'^[^@]+@[^@]+\.[^@]+'
                              ).hasMatch(value)) {
                                return 'Veuillez entrer un email valide';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.95,
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
                                return 'Veuillez entrer un mot de passe';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF5B59B4),
                            foregroundColor: Colors.white,
                            side: BorderSide(color: Color(0xFF5B59B4)),
                            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          onPressed: () {
                            if (_formSignUpUserKey.currentState?.validate() ?? false) {
                              _authService.signUpUser(
                                newEmailController.text,
                                newPasswordController.text,
                                firstNameController.text,
                                nameController.text,
                                context: context,
                                setLoading: setLoading,
                              );
                            }
                          },
                          child: Text('Créer un compte',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 32),
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