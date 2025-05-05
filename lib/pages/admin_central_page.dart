import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:octoloupe/CRUD/user_crud.dart';
import 'package:octoloupe/components/custom_app_bar.dart';
import 'package:octoloupe/model/user_model.dart';
import 'package:octoloupe/pages/admin_activity_page.dart';
import 'package:octoloupe/pages/admin_add_admin_page.dart';
import 'package:octoloupe/pages/admin_interface_page.dart';
import 'package:octoloupe/pages/admin_contact_page.dart';
import 'package:octoloupe/pages/update_credentials_page.dart';
import 'package:octoloupe/services/auth_service.dart';

class AdminCentralPage extends StatefulWidget {
  const AdminCentralPage({super.key});

  @override
  AdminCentralPageState createState() => AdminCentralPageState();
}

class AdminCentralPageState extends State<AdminCentralPage> {
  Map<String, String> userData = {};
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

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }
  
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
                if (userData.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 32),
                    child: Text(
                      'Bonjour ${userData['firstName']}',
                      style: TextStyle(
                        fontFamily: 'Satisfy-Regular',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF5B59B4),
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Color(0xFF5B59B4)),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      )
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminInterfacePage()
                        ),
                      );
                    },
                    child: Text('Gestion de l\'interface',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ElevatedButton(
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminActivityPage()
                        ),
                      );
                    },
                    child: Text('Gestion des activités',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ElevatedButton(
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminContactPage()
                        ),
                      );
                    },
                    child: Text('Formulaire de contact',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ElevatedButton(
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
                      // Naviguer vers une autre page ici
                      /* Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ModifierInterfacePage()
                          ),
                        );
                      ); */
                    },
                    child: Text('Mon profil utilisateur',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ElevatedButton(
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateCredentialsPage(),
                        ),
                      );
                    },
                    child: Text('Modifier mes identifiants',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ElevatedButton(
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminAddAdminPage()
                        ),
                      );
                    },
                    child: Text('Ajouter un profil administrateur',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ElevatedButton(
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
                      _authService.deleteUser(
                        context: context,
                        setLoading: setLoading,
                      );
                    },
                    child: Text('Supprimer mon compte',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, 
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.red),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onPressed: () {
                      _authService.signOut(
                        context: context,
                        setLoading: setLoading,
                      );
                    },
                    child: Text('Se déconnecter',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
    );
  } 
}