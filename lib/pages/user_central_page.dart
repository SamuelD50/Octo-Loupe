import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:octoloupe/CRUD/user_crud.dart';
import 'package:octoloupe/components/custom_app_bar.dart';
import 'package:octoloupe/model/user_model.dart';
import 'package:octoloupe/pages/update_credentials_page.dart';
import 'package:octoloupe/services/auth_service.dart';


class UserCentralPage extends StatefulWidget {
  const UserCentralPage({super.key});

  @override
  UserCentralPageState createState() => UserCentralPageState();
}

class UserCentralPageState extends State<UserCentralPage> {
  Map<String, String> userData = {};
  
  final AuthService _authService = AuthService();
  bool isLoading = false;
  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }

  void initState() {
    super.initState();
    fetchUserData();
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

  /* bool notificationsEnabled = true;

  void _toggleNotifications(
    BuildContext context
  ) {
    setState(() {
      notificationsEnabled = !notificationsEnabled;
    });

    final snackBar = SnackBar(
      content: Text(notificationsEnabled ?
        'Notifications activées' : 'Notifications désactivées'
      ),
      duration: const Duration(seconds: 5),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    debugPrint(notificationsEnabled ?
      'Notifications activées' : 'Notifications désactivées'
    );
  } */

 UserCRUD userCRUD = UserCRUD();

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
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.black,
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
                        )
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
                        // Naviguer vers une autre page ici
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
      ),
    );
  } 
}


/*                   //
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.amber,
                      ),
                      child: IconButton(
                        icon: Icon(
                          notificationsEnabled ?
                            Icons.notifications_active : Icons.notifications_off,
                          color: Colors.white,
                        ),
                        onPressed: () => _toggleNotifications(context),
                      ),
                    ),
                  ),
                  // */