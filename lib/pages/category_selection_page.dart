import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';

class CategorySelectionPage extends StatefulWidget {
  const CategorySelectionPage({super.key});

  @override
  CategorySelectionPageState createState() => CategorySelectionPageState();
}

class CategorySelectionPageState extends State<CategorySelectionPage> {

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

  List<String> selectedCategories = [];

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
        child: Column(
          children: [ 
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Deux colonnes
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final categoryName = categories[index]["name"]!;
                  final isSelected = selectedCategories.contains(categoryName);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedCategories.remove(categoryName);
                          debugPrint('Désélectionné: $categoryName');
                        } else {
                          selectedCategories.add(categoryName);
                          debugPrint('Sélectionné: $categoryName');
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blueAccent : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: isSelected
                          ? []
                          : [
                              BoxShadow(
                                color: Colors.black54,
                                offset: Offset(2, 2),
                                blurRadius: 4,
                              ),
                            ],
                      ),
                      child: Card(
                        elevation: isSelected ? 2 : 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                categories[index]["image"]!,
                                fit:BoxFit.cover,
                              ),
                            ),
                            Container(
                              color: Colors.black54,
                              child: Center(
                                child: Text(
                                  categoryName,
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
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, selectedCategories);
              },
              child: Text('Valider'),
            ),
          ],
        ),
      ),
    );
  }
}
        

/* 
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
} */