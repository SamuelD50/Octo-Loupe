import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';

class AgeSelectionPage extends StatelessWidget {
  AgeSelectionPage({super.key});

  final List<Map<String, String>> ages = [
    {"name": "0-2 ans", "image": "assets/images/ballon.jpg"},
    {"name": "2-4 ans", "image": "assets/images/nautique.jpg"},
    {"name": "4-7 ans", "image": "assets/images/combat.jpg"},
    {"name": "7-11 ans", "image": "assets/images/athlétisme.jpg"},
    {"name": "11-15 ans", "image": "assets/images/raquette.jpg"},
    {"name": "15-18 ans", "image": "assets/images/collectif.jpg"},
    {"name": "Adulte", "image": "assets/images/individuel.jpg"},
    {"name": "Senior", "image": "assets/images/cyclisme.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Deux colonnes
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: ages.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                /* // Naviguer vers la page des sports pour cette catégorie
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SportsPage(category: categories[index]["name"]!),
                  ),
                ); */
              },
              child: Card(
                elevation: 4,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      ages[index]["image"]!,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      color: Colors.black54,
                      child: Center(
                        child: Text(
                          ages[index]["name"]!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}