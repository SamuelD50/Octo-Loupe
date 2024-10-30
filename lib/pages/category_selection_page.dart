import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';

class CategoriesPage extends StatelessWidget {
  CategoriesPage({super.key});

  final List<Map<String, String>> categories = [
    {"name": "Ballon", "image": "assets/images/ballon.jpg"},
    {"name": "Nautique", "image": "assets/images/nautique.jpg"},
    {"name": "Combat", "image": "assets/images/combat.jpg"},
    {"name": "Athlétisme", "image": "assets/images/athlétisme.jpg"},
    {"name": "Raquette", "image": "assets/images/raquette.jpg"},
    {"name": "Collectif", "image": "assets/images/collectif.jpg"},
    {"name": "Individuel", "image": "assets/images/individuel.jpg"},
    {"name": "Cyclisme", "image": "assets/images/cyclisme.jpg"},
    {"name": "Equestre", "image": "assets/images/equestre.jpg"},
    {"name": "Glisse", "image": "assets/images/glisse.jpg"},
    {"name": "Plein air", "image": "assets/images/plein_air.jpg"},
    {"name": "Mécanique", "image": "assets/images/mecanique.jpg"},
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
          itemCount: categories.length,
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
                      categories[index]["image"]!,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      color: Colors.black54,
                      child: Center(
                        child: Text(
                          categories[index]["name"]!,
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
        

// Exemple de page pour afficher les sports d'une catégorie
class SportsPage extends StatelessWidget {
  final String category;

  const SportsPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Text(
            'Sports de la catégorie:', // Affiche le texte avec la catégorie
            style: TextStyle(
              fontSize: 24, // Taille de la police
              color: Colors.white, // Couleur du texte
              fontWeight: FontWeight.bold, // Épaisseur de la police
            ),
            textAlign: TextAlign.center, // Centre le texte
          ),
        ),
      ),
    );
  }
}