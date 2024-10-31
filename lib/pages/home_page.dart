import 'package:octoloupe/components/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'category_selection_page.dart';
import 'age_selection_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<String> selectedCategories = [];
  List<String> selectedAges = [];
  
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Je trouve mon activité',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ),
            // Barre de recherche
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Je recherche ...',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.search),
                ),
                onSubmitted: (value) {
                  debugPrint(value);
                },
              ),
            ),
            ToggleButtons(
              isSelected: [_selectedIndex == 0, _selectedIndex == 1],
              onPressed: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              color: Colors.black,
              selectedColor: Colors.white,
              fillColor: Color(0xFF5B59B4),
              borderColor: Color(0xFF5B59B4), // Suppression des bordures par défaut
              selectedBorderColor: Color(0xFF5B59B4),
              borderRadius: BorderRadius.circular(20.0), // Arrondir les coins
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 1.0),
                  child: Center(child: Text('Sport')),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 1.0),
                  child: Center(child: Text('Culture')),
                ),
              ],
            ),

            // Critères de sélection
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildCriteriaTile(
                    context,
                    Icons.category,
                    'Par catégorie',
                    () async {
                      final categories = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CategorySelectionPage(selectedCategories: selectedCategories)),
                      );
                      return categories;
                    },
                  ),
                  _buildCriteriaTile(
                    context,
                    Icons.accessibility_new,
                    'Par âge',
                    () async {
                      final ages = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AgeSelectionPage(selectedAges: selectedAges)),
                      );
                      return ages;
                    },
                  ),
                  /* _buildCriteriaTile(
                    context,
                    Icons.date_range,
                    'Par jour',
                    CategorySelectionPage(),
                  ),
                  _buildCriteriaTile(
                    context,
                    Icons.access_time,
                    'Par horaire',
                    CategorySelectionPage(),
                  ),
                  _buildCriteriaTile(
                    context,
                    Icons.apartment_rounded,
                    'Par secteur',
                    CategorySelectionPage(),
                  ), */
                ],
              ),
            ),
            if (selectedCategories.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 8.0,
                  children: selectedCategories.map((category) {
                    return Chip(
                      label: Text(category),
                      onDeleted: () {
                        setState(() {
                          selectedCategories.remove(category);
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                onPressed: () {
                  debugPrint("Bouton rechercher");
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text('Rechercher'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCriteriaTile(BuildContext context, IconData icon, String label, Future<List<String>> Function() pageBuilder) {
    return GestureDetector(
      onTap: () async {
        final categories = await pageBuilder();
        setState(() {
          selectedCategories = List<String>.from(categories);
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF5B59B4),
              ),
              padding: EdgeInsets.all(8),
              child: Icon(icon, color: Colors.white),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                label,
                style: TextStyle(color: Colors.black, fontSize: 18),
              ), 
            ),
          ],
        ),
      ),
    );
  }
}