import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:octoloupe/components/custom_app_bar.dart';
import 'package:octoloupe/screens/admin_central_page.dart';
import 'package:octoloupe/services/auth_service.dart';

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
  void setLoading(bool value) {
    setState(() {
      loading = value;
    });
  }

  bool _isNewPasswordVisible = false;

  final AuthService _authService = AuthService();

  @override
  Widget build(
    BuildContext context
  ) {
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
                          padding: EdgeInsets.only(top: 32),
                          child: Text(
                            'Ajouter un profil administrateur',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextFormField(
                            controller: firstNameAdminController,
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
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: TextFormField(
                            controller: nameAdminController,
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
                          width: MediaQuery.of(context).size.width * 0.9,
                          child:TextFormField(
                            controller: newEmailAdminController,
                            decoration: const InputDecoration(
                              labelText: 'E-mail',
                              hintText: 'Ex: abc@exemple.com',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer un e-mail';
                              }
                              if (
                                !RegExp(r'^[^@]+@[^@]+\.[^@]+'
                              ).hasMatch(value)) {
                                return 'Veuillez entrer un e-mail valide';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
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
                                  _isNewPasswordVisible ?
                                    Icons.visibility : Icons.visibility_off,
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          onPressed: () {
                            if (_formSignUpAdminKey.currentState?.validate() ?? false) {
                              _authService.signUpAdmin(
                                newEmailAdminController.text,
                                newPasswordAdminController.text,
                                firstNameAdminController.text,
                                nameAdminController.text,
                                context: context,
                                setLoading: setLoading,
                              );
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AdminCentralPage()
                              ),
                            );
                          },
                          child: Text('Créer un compte'),
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
      ),
    );
  } 
}