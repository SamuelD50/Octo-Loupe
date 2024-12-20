import 'package:flutter/material.dart';
import 'package:octoloupe/components/custom_app_bar.dart';
import 'package:octoloupe/screens/admin_add_admin_page.dart';
import 'package:octoloupe/screens/admin_interface_page.dart';
import 'package:octoloupe/screens/auth_page.dart';
import 'package:octoloupe/services/auth_service.dart';

class AdminCentralPage extends StatefulWidget {
  const AdminCentralPage({super.key});

  @override
  AdminCentralPageState createState() => AdminCentralPageState();
}

class AdminCentralPageState extends State<AdminCentralPage> {

  final AuthService _authService = AuthService();

  bool loading = false;
  void setLoading(bool value) {
    setState(() {
      loading = value;
    });
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
                  Padding(
                    padding: EdgeInsets.only(top: 32),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF5B59B4),
                          foregroundColor: Colors.white,
                          side: BorderSide(color: Color(0xFF5B59B4)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          )
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AdminInterfacePage()),
                          );
                        },
                        child: Text('Modifier l\'interface de l\'application'),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF5B59B4),
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Color(0xFF5B59B4)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      onPressed: () {
                        // Naviguer vers une autre page ici
                        /* Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ModifierInterfacePage()),
                        ); */
                      },
                      child: Text('Ajouter ou modifier une activité'),
                    ),
                  ),
                  SizedBox(height: 40),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF5B59B4), // Fill color
                        foregroundColor: Colors.white, // Text color
                        side: BorderSide(color: Color(0xFF5B59B4)), // Border color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0), // Border radius
                        ),
                      ),
                      onPressed: () {
                        // Naviguer vers une autre page ici
                        /* Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ModifierInterfacePage()),
                        ); */
                      },
                      child: Text('Mon profil utilisateur'),
                    ),
                  ),
                  SizedBox(height: 40),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF5B59B4), // Fill color
                        foregroundColor: Colors.white, // Text color
                        side: BorderSide(color: Color(0xFF5B59B4)), // Border color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0), // Border radius
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AdminAddAdminPage()),
                        );
                      },
                      child: Text('Ajouter un profil administrateur'),
                    ),
                  ),
                  SizedBox(height: 40),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF5B59B4), // Fill color
                        foregroundColor: Colors.white, // Text color
                        side: BorderSide(color: Color(0xFF5B59B4)), // Border color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0), // Border radius
                        ),
                      ),
                      onPressed: () {
                        _authService.deleteUser(
                          context: context,
                          setLoading: setLoading,
                        );
                      },
                      child: Text('Supprimer mon compte utilisateur'),
                    ),
                  ),
                  SizedBox(height: 40),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Fill color
                        foregroundColor: Colors.white, // Text color
                        side: BorderSide(color: Colors.red), // Border color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0), // Border radius
                        ),
                      ),
                      onPressed: () {
                        _authService.signOut(
                          context: context,
                          setLoading: setLoading,
                        );
                      },
                      child: Text('Se déconnecter'),
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