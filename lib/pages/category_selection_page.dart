import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:octoloupe/components/filter_card.dart';
import 'package:octoloupe/components/loading.dart';
import 'package:octoloupe/model/sport_filters_model.dart';
import 'package:octoloupe/model/culture_filters_model.dart';
import 'package:octoloupe/providers/filter_provider.dart';
import 'package:octoloupe/services/sport_filter_service.dart';
import 'package:octoloupe/services/culture_filter_service.dart';
import 'package:provider/provider.dart';

class CategorySelectionPage extends StatefulWidget {
  final bool isSport;
  final List<Map<String, String>>? selectedCategories;
  
  const CategorySelectionPage({
    super.key,
    required this.isSport,
    this.selectedCategories,
  });

  @override
  CategorySelectionPageState createState() => CategorySelectionPageState();
}

class CategorySelectionPageState extends State<CategorySelectionPage> {
  late Future<List<SportCategory>> sportCategoriesReceiver;
  late Future<List<CultureCategory>> cultureCategoriesReceiver;

  @override
  void initState() {
    super.initState();
    sportCategoriesReceiver = SportFilterService().getSportCategories();
    cultureCategoriesReceiver = CultureFilterService().getCultureCategories();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final readFilterProvider = context.read<FilterProvider>();
      readFilterProvider.setSection(widget.isSport ? 0 : 1);
      if (widget.selectedCategories != null) {
        readFilterProvider.setSelectedCategories(
          selectedSection: widget.isSport ? 0 : 1,
          selectedCategories: widget.selectedCategories,
        );
      }
    });
  }

  @override
  Widget build(
    BuildContext context
  ) {
    final watchFilterProvider = context.watch<FilterProvider>();

    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth > 325 ? 20.0 : 14.0;
    final crossAxisCount = screenWidth < 250 ? 1 : screenWidth < 600 ? 2 : 3;

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
                const Padding(
                  padding: EdgeInsets.only(top: 8)
                ),
                widget.isSport ?
                  FutureBuilder<List<SportCategory>>(
                    future: sportCategoriesReceiver,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Loading();
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Erreur: ${snapshot.error}')
                        );
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('Aucune catégorie trouvée')
                        );
                      }

                      final sportCategories = snapshot.data!..sort((a, b) => a.name.compareTo(b.name));

                      return Column(
                        children: [
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(2.0),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 2.0,
                              mainAxisSpacing: 2.0,
                            ),
                            itemCount: sportCategories.length,
                            itemBuilder: (context, index) {
                              final category = sportCategories[index];
                              final isSelected = watchFilterProvider.selectedSportCategories.any((selected) =>
                                selected.id == category.id);

                              return Semantics(
                                button: true,
                                selected: isSelected,
                                label: category.name,
                                hint: isSelected ?
                                  'Sélectionné, tapez pour désélectionner'
                                  : 'Non sélectionné, tapez pour sélectionner',
                                  child: Focus(
                                    child: FilterCard(
                                      name: category.name,
                                      imageUrl: category.imageUrl,
                                      isSelected: isSelected,
                                      fontSize: fontSize,
                                      onTap: () {
                                        final selectedCategories = watchFilterProvider.selectedSportCategories
                                          .map((category) => {
                                            'id': category.id!,
                                            'name': category.name,
                                          }).toList();

                                        if (isSelected) {
                                          selectedCategories
                                            .removeWhere((selected) => selected['id'] == category.id);
                                        } else {
                                          if (category.id != null) {
                                            selectedCategories.add({
                                              'id': category.id!,
                                              'name': category.name,
                                            });
                                          }
                                        }

                                        watchFilterProvider.setSelectedCategories(
                                          selectedSection: 0,
                                          selectedCategories: selectedCategories,
                                        );
                                      },
                                    ),
                                  ),
                              );
                            },
                          ),
                          if (sportCategories.isNotEmpty)
                            SizedBox(height: 8),
                          if (sportCategories.isNotEmpty)
                            ElevatedButton(
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
                                final readFilterProvider = context.read<FilterProvider>();
                                final selectedCategories = readFilterProvider.selectedSportCategories
                                  .map((category) => {
                                    'id': category.id!,
                                    'name': category.name
                                  }).toList();
                                context.pop(selectedCategories);
                              },
                              child: Text('Valider',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 8)
                          ),
                        ],
                      );
                    },
                  )
                : FutureBuilder<List<CultureCategory>>(
                  future: cultureCategoriesReceiver,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Loading();
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Erreur: ${snapshot.error}')
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('Aucune catégorie trouvée')
                      );
                    }

                    final cultureCategories = snapshot.data!..sort((a, b) => a.name.compareTo(b.name));

                    return Column(
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(2.0),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 2.0,
                            mainAxisSpacing: 2.0,
                          ),
                          itemCount: cultureCategories.length,
                          itemBuilder: (context, index) {
                            final category = cultureCategories[index];
                            final isSelected = watchFilterProvider.selectedCultureCategories.any((selected) =>
                              selected.id == category.id);

                            return Semantics(
                              button: true,
                              selected: isSelected,
                              label: category.name,
                              hint: isSelected ?
                                'Sélectionné, tapez pour désélectionnner'
                                : 'Non sélectionné, tapez pour sélectionner',
                                child: Focus(
                                  child: FilterCard(
                                    name: category.name,
                                    imageUrl: category.imageUrl,
                                    isSelected: isSelected,
                                    fontSize: fontSize,
                                    onTap: () {
                                      final selectedCategories = watchFilterProvider.selectedCultureCategories
                                        .map((category) => {
                                          'id': category.id!,
                                          'name': category.name,
                                        }).toList();

                                      if (isSelected) {
                                        selectedCategories
                                          .removeWhere((selected) => selected['id'] == category.id);
                                      } else {
                                        if (category.id != null) {
                                          selectedCategories.add({
                                            'id': category.id!,
                                            'name': category.name,
                                          });
                                        }
                                      }

                                      watchFilterProvider.setSelectedCategories(
                                        selectedSection: 1,
                                        selectedCategories: selectedCategories,
                                      );
                                    },
                                  ),
                                ),
                            );
                          },
                        ),
                        if (cultureCategories.isNotEmpty)
                          SizedBox(height: 8),
                        if (cultureCategories.isNotEmpty)
                          ElevatedButton(
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
                              final readFilterProvider = context.read<FilterProvider>();
                              final selectedCategories = readFilterProvider.selectedCultureCategories
                                .map((category) => {
                                  'id': category.id!,
                                  'name': category.name,
                                }).toList();
                              context.pop(selectedCategories);
                            },
                            child: Text('Valider',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 8)
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
    );
  }
}