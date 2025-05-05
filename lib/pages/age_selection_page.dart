import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:octoloupe/components/filter_card.dart';
import 'package:octoloupe/model/sport_filters_model.dart';
import 'package:octoloupe/model/culture_filters_model.dart';
import 'package:octoloupe/services/sport_filter_service.dart';
import 'package:octoloupe/services/culture_filter_service.dart';

class AgeSelectionPage extends StatefulWidget {
  final List<Map<String, String>>? selectedAges;
  final bool isSport;

  const AgeSelectionPage({
    super.key,
    this.selectedAges,
    required this.isSport,
  });

  @override
  AgeSelectionPageState createState() => AgeSelectionPageState();
}

class AgeSelectionPageState extends State<AgeSelectionPage> {
  late List<Map<String, String>> selectedAges;
  late Future<List<SportAge>> sportAgesReceiver;
  late Future<List<CultureAge>> cultureAgesReceiver;

  @override
  void initState() {
    super.initState();
    selectedAges = List.from(widget.selectedAges ?? []);
    sportAgesReceiver = SportFilterService().getSportAges();
    cultureAgesReceiver = CultureFilterService().getCultureAges();
  }

  List<T> sortAges<T>(List<T> ages) {
    int? getMinAge(String ageRange) {
      final startAge = ageRange.split('-');
      
      if (startAge.length == 1) {
        return null;
      }
      return int.tryParse(startAge[0].split(' ')[0]);
    }

    ages.sort(
      (a, b) {
        String nameA = a is SportAge ?
          a.name : (a is CultureAge ? a.name : '');
        String nameB = b is SportAge ?
          b.name : (b is CultureAge ? b.name : '');
        int? minAgeA = getMinAge(nameA);
        int? minAgeB = getMinAge(nameB);
        if (minAgeA == null && minAgeB != null) return 1;
        if (minAgeB == null && minAgeA != null) return -1;
        return (minAgeA ?? 0).compareTo(minAgeB ?? 0);
    });

    return ages;
  }

  @override
  Widget build(
    BuildContext context
  ) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth > 325 ? 20.0 : 14.0;
    
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
                Padding(
                  padding: EdgeInsets.only(top: 8)
                ),
                widget.isSport ?
                FutureBuilder<List<SportAge>>(
                  future: sportAgesReceiver,
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
                        child: Text('Aucun âge trouvé')
                      );
                    }

                    final sportAges = snapshot.data!;

                    final sortedAges = sortAges(sportAges);

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
                          itemCount: sortedAges.length,
                          itemBuilder: (context, index) {
                            final age = sortedAges[index];
                            final isSelected = selectedAges.any((selected) =>
                              selected['id'] == age.id);

                            return FilterCard(
                              name: age.name,
                              imageUrl: age.imageUrl,
                              isSelected: isSelected,
                              fontSize: fontSize,
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedAges.removeWhere((selected) =>
                                      selected['id'] == age.id);
                                  } else {
                                    if (age.id != null) {
                                      selectedAges.add({
                                        'id': age.id!,
                                        'name': age.name,
                                      });
                                    }
                                  }
                                });
                              },
                            );
                          },
                        ),
                        if (sportAges.isNotEmpty)
                          SizedBox(height: 8),
                        if (sportAges.isNotEmpty)
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
                              context.pop(selectedAges);
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
                : FutureBuilder<List<CultureAge>>(
                  future: cultureAgesReceiver,
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
                        child: Text('Aucune âge trouvé')
                      );
                    }

                    final cultureAges = snapshot.data!;

                    final sortedAges = sortAges(cultureAges);

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
                          itemCount: sortedAges.length,
                          itemBuilder: (context, index) {
                            final age = sortedAges[index];
                            final isSelected = selectedAges.any((selected) =>
                              selected['id'] == age.id);

                            return FilterCard(
                              name: age.name,
                              imageUrl: age.imageUrl,
                              isSelected: isSelected,
                              fontSize: fontSize,
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedAges.removeWhere((selected) =>
                                      selected['id'] == age.id);
                                  } else {
                                    if (age.id != null) {
                                      selectedAges.add({
                                        'id': age.id!,
                                        'name': age.name,
                                      });
                                    }
                                  }
                                });
                              },
                            );
                          },
                        ),
                        if (cultureAges.isNotEmpty)
                          SizedBox(height: 8),
                        if (cultureAges.isNotEmpty)
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
                              context.pop(selectedAges);
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