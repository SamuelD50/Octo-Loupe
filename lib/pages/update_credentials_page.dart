import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:octoloupe/CRUD/user_crud.dart';
import 'package:octoloupe/components/custom_app_bar.dart';
import 'package:octoloupe/components/loading.dart';
import 'package:octoloupe/model/user_model.dart';
import 'package:octoloupe/services/auth_service.dart';

class UpdateCredentialsPage extends StatefulWidget {
  const UpdateCredentialsPage({super.key});

  @override
  UpdateCredentialsPageState createState() => UpdateCredentialsPageState();
}

class UpdateCredentialsPageState extends State<UpdateCredentialsPage> {
  Map<String, String> userData = {};
  int _selectedIndex = 0;
  final _updateEmailKey = GlobalKey<FormState>();
  final emailResetController = TextEditingController();
  final passwordControllerForUpdatingEmail = TextEditingController();
  bool _isPasswordForResetingEmailVisible = false;

  final _updatePasswordKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final currentPasswordControllerForUpdatingPassword = TextEditingController();
  bool _isCurrentPasswordForResetingPasswordVisible = false;
  final newPasswordControllerForUpdatingPassword = TextEditingController();
  bool _isNewPasswordForResetingPasswordVisible = false;
  final AuthService _authService = AuthService();
  bool isLoading = false;
  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }
  
  Future<void> fetchUserData() async {
    try {
      setState(() {
        isLoading = true;
      });

      String? uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid != null) {
        UserModel? user = await UserCRUD().getUser(uid);
        if (user != null) {
          userData = {
            'email': user.email,
            'firstName': user.firstName,
            'name': user.name,
          };

          emailController.text = user.email;
        }
      }

      await Future.delayed(Duration(milliseconds: 25));

      setState(() {
        isLoading = false;
      });

    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  String email = '';
  
  @override
  void initState() {
    super.initState();
    fetchUserData();
    emailController.addListener(() {
      setState(() {
        email = emailController.text;
      });
    });
  }

  @override
  Widget build(
    BuildContext context
  ) {
    return isLoading ? Loading() :
    Stack(
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
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: Text(
                    'Modifier mes identifiants',
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
                LayoutBuilder(
                  builder: (context, constraints) {

                    return ToggleButtons(
                      isSelected: [_selectedIndex == 0, _selectedIndex == 1],
                      onPressed: (int index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      color: Colors.black,
                      selectedColor: Colors.white,
                      fillColor: Color(0xFF5B59B4),
                      borderColor: Color(0xFF5B59B4),
                      selectedBorderColor: Color(0xFF5B59B4),
                      borderRadius:  BorderRadius.circular(30.0),
                      direction: constraints.maxWidth < 375 ?
                        Axis.vertical
                        : Axis.horizontal,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 1.0),
                          child: Center(
                            child: Text(
                              'Email',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 1.0),
                          child: Center(
                            child: Text(
                              'Mot de passe',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                _selectedIndex == 0 ? _buildUpdateEmail() : _buildUpdatePassword(),
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                )
              ]
            ),
          ),
        ),
      ],
    );
  }

  /* //Update email
  Future<void> updateEmail(String newEmail) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.verifyBeforeUpdateEmail(newEmail);
        debugPrint('Email updated successfully');
      } else {
        debugPrint('No user is currently signed in');
      }
    } catch (e) {
      throw Exception('Error updating email: $e');
    }
  } */

  Widget _buildUpdateEmail() {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Form(
            key: _updateEmailKey,
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.98,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'E-mail actuel : ',
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      /* SizedBox(width: 5), */
                      Text(
                        userData['email'] ?? '',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ]
                    
                  )
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.98,
                  child: TextFormField(
                    controller: passwordControllerForUpdatingEmail,
                    obscureText: !_isPasswordForResetingEmailVisible,
                    decoration: InputDecoration(
                      labelText: 'Mot de passe actuel',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordForResetingEmailVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordForResetingEmailVisible = !_isPasswordForResetingEmailVisible;
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
                const SizedBox(height: 16),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.98,
                  child: TextFormField(
                    controller: emailResetController,
                    decoration: InputDecoration(
                      labelText: 'Nouvel e-mail',
                      hintText: 'Ex: abc@exemple.com',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
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
                    if (_updateEmailKey.currentState?.validate() ?? false) {
                      _authService.updateEmail(
                        emailResetController.text,
                        passwordControllerForUpdatingEmail.text,
                        context: context,
                        setLoading: setLoading,
                      );
                      emailResetController.clear();
                      passwordControllerForUpdatingEmail.clear();
                      fetchUserData();
                    }
                  },
                  child: Text('Modifier l\'email',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],

    );
  }

  /* //Update user password
  Future<void> updatePassword(
    String newPassword, {
      required BuildContext context,
      required Function(bool) setLoading
    }
  ) async {
    try {
      setLoading(true);

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);

        await Future.delayed(Duration(milliseconds: 25));

        setLoading(false);

        if (context.mounted) {
          CustomSnackBar(
            message: 'Le mot de passe a été mis à jour',
            backgroundColor: Colors.green,
          ).showSnackBar(context);
        }
      } 
    } catch (e) {
      setLoading(false);

      if (context.mounted) {
        CustomSnackBar(
          message: 'Erreur lors de la mise à jour du mot de passe',
          backgroundColor: Colors.red,
        ).showSnackBar(context);
      }
      throw Exception('Error updating password: $e');
    }
  } */

  Widget _buildUpdatePassword() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Form(
          key: _updatePasswordKey,
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.98,
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'E-mail actuel',
                    hintText: 'Ex: abc@exemple.com',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre email';
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
                width: MediaQuery.of(context).size.width * 0.98,
                child: TextFormField(
                  controller: currentPasswordControllerForUpdatingPassword,
                  obscureText: !_isCurrentPasswordForResetingPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe actuel',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isCurrentPasswordForResetingPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isCurrentPasswordForResetingPasswordVisible = !_isCurrentPasswordForResetingPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre mot de passe actuel';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.98,
                child: TextFormField(
                  controller: newPasswordControllerForUpdatingPassword,
                  obscureText: !_isNewPasswordForResetingPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Nouveau mot de passe',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isNewPasswordForResetingPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isNewPasswordForResetingPasswordVisible = !_isNewPasswordForResetingPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre nouveau mot de passe';
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
                  if (_updatePasswordKey.currentState?.validate() ?? false) {
                    _authService.updatePassword(
                      emailController.text,
                      currentPasswordControllerForUpdatingPassword.text,
                      newPasswordControllerForUpdatingPassword.text,
                      context: context,
                      setLoading: setLoading,
                    );
                    currentPasswordControllerForUpdatingPassword.clear();
                    newPasswordControllerForUpdatingPassword.clear();
                    fetchUserData();
                  }
                },
                child: Text('Modifier le mot de passe',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          )

        )
      ],

    );
  }

}