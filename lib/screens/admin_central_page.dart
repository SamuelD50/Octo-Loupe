import 'package:flutter/material.dart';
import 'package:octoloupe/components/custom_app_bar.dart';

class AdminCentralPage extends StatefulWidget {
  const AdminCentralPage({super.key});

  @override
  AdminCentralPageState createState() => AdminCentralPageState();
}

class AdminCentralPageState extends State<AdminCentralPage> {
  

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
                  SizedBox(
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
                        /* Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ModifierInterfacePage()),
                        ); */
                      },
                      child: Text('Modifier l\'interface de l\'application'),
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
                  SizedBox(height: 20),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  } 
}