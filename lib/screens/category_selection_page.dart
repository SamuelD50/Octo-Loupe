import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../components/custom_app_bar.dart';
import 'package:octoloupe/model/sport_filters_model.dart';
import 'package:octoloupe/model/culture_filters_model.dart';
import 'package:octoloupe/services/sport_filter_service.dart';
import 'package:octoloupe/services/culture_filter_service.dart';

class CategorySelectionPage extends StatefulWidget {
  final List<String> selectedCategories;
  final bool isSport;

  const CategorySelectionPage({
    super.key,
    required this.selectedCategories,
    required this.isSport,
  });

  @override
  CategorySelectionPageState createState() => CategorySelectionPageState();
}

class CategorySelectionPageState extends State<CategorySelectionPage> {
  late List<String> selectedCategories;
  late Future<List<SportCategory>> sportCategoriesFunction;
  late Future<List<CultureCategory>> cultureCategoriesFunction;


  @override
  void initState() {
    super.initState();
    selectedCategories = List.from(widget.selectedCategories);
    sportCategoriesFunction = SportFilterService().getSportCategories();
    cultureCategoriesFunction = CultureFilterService().getCultureCategories();
  }

  @override
  Widget build(
    BuildContext context
  ) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth > 325 ? 20.0 : 14.0;

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
                  widget.isSport ?
                  FutureBuilder<List<SportCategory>>(
                    future: sportCategoriesFunction,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SpinKitSpinningLines(
                            color: Colors.white,
                            size: 60,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Erreur: ${snapshot.error}')
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('Aucune catégorie trouvée')
                        );
                      }

                      final sportCategories = snapshot.data!;

                      sportCategories.sort(
                        (a, b) => a.name.compareTo(b.name)
                      );

                      return GridView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: MediaQuery.of(context).size.width < 250 ?
                          1 : MediaQuery.of(context).size.width < 600 ?
                          2 : 3,
                          crossAxisSpacing: 12.0,
                          mainAxisSpacing: 12.0,
                        ),
                        itemCount: sportCategories.length,
                        itemBuilder: (context, index) {
                          final categoryName = sportCategories[index].name;
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
                                borderRadius: BorderRadius.circular(16),
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
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.network(
                                        sportCategories[index].imageUrl,
                                        fit:BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Center(
                                        child: Text(
                                          categoryName,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: fontSize,
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
                      );
                    },
                  )
                  : FutureBuilder<List<CultureCategory>>(
                    future: cultureCategoriesFunction,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SpinKitSpinningLines(
                            color: Colors.white,
                            size: 60,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Erreur: ${snapshot.error}')
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('Aucune catégorie trouvée')
                        );
                      }

                      final cultureCategories = snapshot.data!;

                      cultureCategories.sort(
                        (a, b) => a.name.compareTo(b.name)
                      );

                      return GridView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: MediaQuery.of(context).size.width < 250 ?
                          1 : MediaQuery.of(context).size.width < 600 ?
                          2 : 3, // Deux colonnes
                          crossAxisSpacing: 12.0,
                          mainAxisSpacing: 12.0,
                        ),
                        itemCount: cultureCategories.length,
                        itemBuilder: (context, index) {
                          final categoryName = cultureCategories[index].name;
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
                                borderRadius: BorderRadius.circular(16),
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
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.network(
                                        cultureCategories[index].imageUrl,
                                        fit:BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Center(
                                        child: Text(
                                          categoryName,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: fontSize,
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
                      );
                    },
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF5B59B4),
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Color(0xFF5B59B4)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context, selectedCategories);
                    },
                    child: Text('Valider'),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}