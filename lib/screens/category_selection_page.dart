import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:octoloupe/components/custom_app_bar.dart';
import 'package:octoloupe/model/sport_filters_model.dart';
import 'package:octoloupe/model/culture_filters_model.dart';
import 'package:octoloupe/services/sport_filter_service.dart';
import 'package:octoloupe/services/culture_filter_service.dart';

class CategorySelectionPage extends StatefulWidget {
  final List<Map<String, String>>? selectedCategories;
  final bool isSport;

  const CategorySelectionPage({
    super.key,
    this.selectedCategories,
    required this.isSport,
  });

  @override
  CategorySelectionPageState createState() => CategorySelectionPageState();
}

class CategorySelectionPageState extends State<CategorySelectionPage> {
  late List<Map<String, String>> selectedCategories;
  late Future<List<SportCategory>> sportCategoriesReceiver;
  late Future<List<CultureCategory>> cultureCategoriesReceiver;

  @override
  void initState() {
    super.initState();
    selectedCategories = List.from(widget.selectedCategories ?? []);
    sportCategoriesReceiver = SportFilterService().getSportCategories();
    cultureCategoriesReceiver = CultureFilterService().getCultureCategories();
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
                  widget.isSport ?
                  FutureBuilder<List<SportCategory>>(
                    future: sportCategoriesReceiver,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SpinKitSpinningLines(
                            color: Colors.black,
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

                      return Column(
                        children: [
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(2.0),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: MediaQuery.of(context).size.width < 250 ?
                              1 : MediaQuery.of(context).size.width < 600 ?
                              2 : 3,
                              crossAxisSpacing: 2.0,
                              mainAxisSpacing: 2.0,
                            ),
                            itemCount: sportCategories.length,
                            itemBuilder: (context, index) {
                              final category = sportCategories[index];
                              final isSelected = selectedCategories.any((selected) =>
                                selected['id'] == category.id);

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      selectedCategories.removeWhere((selected) =>
                                        selected['id'] == category.id);
                                    } else {
                                      if (category.id != null) {
                                        selectedCategories.add({
                                          'id': category.id!,
                                          'name': category.name,
                                        });
                                      }
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
                                    elevation: isSelected ?
                                      2 : 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(16),
                                          child: Image.network(
                                            category.imageUrl,
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
                                              category.name,
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
                          ),
                          if (sportCategories.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(2),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF5B59B4),
                                  foregroundColor: Colors.white,
                                  side: BorderSide(color: Color(0xFF5B59B4)),
                                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context, selectedCategories);
                                },
                                child: Text('Valider',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  )
                  : FutureBuilder<List<CultureCategory>>(
                    future: cultureCategoriesReceiver,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SpinKitSpinningLines(
                            color: Colors.black,
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

                      return Column(
                        children: [
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(2.0),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: MediaQuery.of(context).size.width < 250 ?
                              1 : MediaQuery.of(context).size.width < 600 ?
                              2 : 3, // Deux colonnes
                              crossAxisSpacing: 2.0,
                              mainAxisSpacing: 2.0,
                            ),
                            itemCount: cultureCategories.length,
                            itemBuilder: (context, index) {
                              final category = cultureCategories[index];
                              final isSelected = selectedCategories.any((selected) =>
                                selected['id'] == category.id);

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isSelected) {
                                        selectedCategories.removeWhere((selected) =>
                                          selected['id'] == category.id);
                                      } else {
                                        if (category.id != null) {
                                          selectedCategories.add({
                                            'id': category.id!,
                                            'name': category.name,
                                          });
                                        }
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
                                      elevation: isSelected ?
                                        2 : 4,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(16),
                                            child: Image.network(
                                              category.imageUrl,
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
                                                category.name,
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
                          ),
                          if (cultureCategories.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(2),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF5B59B4),
                                  foregroundColor: Colors.white,
                                  side: BorderSide(color: Color(0xFF5B59B4)),
                                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.pop(context, selectedCategories);
                                },
                                child: Text('Valider',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
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