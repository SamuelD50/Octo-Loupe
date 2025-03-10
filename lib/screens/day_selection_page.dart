import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:octoloupe/components/custom_app_bar.dart';
import 'package:octoloupe/model/sport_filters_model.dart';
import 'package:octoloupe/model/culture_filters_model.dart';
import 'package:octoloupe/services/sport_filter_service.dart';
import 'package:octoloupe/services/culture_filter_service.dart';

class DaySelectionPage extends StatefulWidget {
  final List<Map<String, String>> selectedDays;
  final bool isSport;

  const DaySelectionPage({
    super.key,
    required this.selectedDays,
    required this.isSport,
  });

  @override
  DaySelectionPageState createState() => DaySelectionPageState();
}

class DaySelectionPageState extends State<DaySelectionPage> {
  late List<Map<String, String>> selectedDays;
  late Future<List<SportDay>> sportDaysReceiver;
  late Future<List<CultureDay>> cultureDaysReceiver;
  

  @override
  void initState() {
    super.initState();
    selectedDays = List.from(widget.selectedDays);
    sportDaysReceiver = SportFilterService().getSportDays();
    cultureDaysReceiver = CultureFilterService().getCultureDays();
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
                  FutureBuilder<List<SportDay>>(
                    future: sportDaysReceiver,
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
                          child: Text('Aucun jour trouvé')
                        );
                      }

                      final sportDays = snapshot.data!;

                      List<String> daysOrder = [
                        'Lundi',
                        'Mardi',
                        'Mercredi',
                        'Jeudi',
                        'Vendredi',
                        'Samedi',
                        'Dimanche'
                      ];

                      sportDays.sort((a, b) {
                        int indexA = daysOrder.indexOf(a.name);
                        int indexB = daysOrder.indexOf(b.name);
                        return indexA.compareTo(indexB);
                      });

                      return Column(
                        children: [
                          GridView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(2.0),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: MediaQuery.of(context).size.width < 250 ?
                              1 : MediaQuery.of(context).size.width < 600 ?
                              2 : 3, // Deux colonnes
                              crossAxisSpacing: 2.0,
                              mainAxisSpacing: 2.0,
                            ),
                            itemCount: sportDays.length,
                            itemBuilder: (context, index) {
                              final day = sportDays[index];
                              final isSelected = selectedDays.any((selected) =>
                                selected['id'] == day.id);

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      selectedDays.removeWhere((selected) =>
                                        selected['id'] == day.id);
                                      debugPrint('Désélectionné: ${day.name}');
                                    } else {
                                      if (day.id != null) {
                                        selectedDays.add({
                                          'id': day.id!,
                                          'name': day.name,
                                        });
                                        debugPrint('Sélectionné: ${day.name}');
                                      }
                                    }
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeInOut,
                                  decoration: BoxDecoration(
                                    color: isSelected ?
                                      Colors.blueAccent : Colors.transparent,
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
                                            day.imageUrl,
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
                                              day.name,
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
                          if (sportDays.isNotEmpty)
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
                                  Navigator.pop(context, selectedDays);
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
                  : FutureBuilder<List<CultureDay>>(
                    future: cultureDaysReceiver,
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
                          child: Text('Aucune jour trouvé')
                        );
                      }

                      final cultureDays = snapshot.data!;

                      List<String> daysOrder = [
                        'Lundi',
                        'Mardi',
                        'Mercredi',
                        'Jeudi',
                        'Vendredi',
                        'Samedi',
                        'Dimanche'
                      ];

                      cultureDays.sort(
                        (a, b) {
                          int indexA = daysOrder.indexOf(a.name);
                          int indexB = daysOrder.indexOf(b.name);
                          return indexA.compareTo(indexB);
                        }
                      );

                      return Column(
                        children: [
                          GridView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(2.0),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: MediaQuery.of(context).size.width < 250 ?
                              1 : MediaQuery.of(context).size.width < 600 ?
                              2 : 3, // Deux colonnes
                              crossAxisSpacing: 2.0,
                              mainAxisSpacing: 2.0,
                            ),
                            itemCount: cultureDays.length,
                            itemBuilder: (context, index) {
                              final day = cultureDays[index];
                              final isSelected = selectedDays.any((selected) =>
                                selected['id'] == day.id);

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      selectedDays.removeWhere((selected) =>
                                        selected['id'] == day.id);
                                      debugPrint('Désélectionné: ${day.id}');
                                    } else {
                                      if (day.id != null) {
                                        selectedDays.add({
                                          'id': day.id!,
                                          'name': day.name,
                                        });
                                        debugPrint('Sélectionné: ${day.name}');
                                      }
                                    }
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeInOut,
                                  decoration: BoxDecoration(
                                    color: isSelected ?
                                      Colors.blueAccent : Colors.transparent,
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
                                            day.imageUrl,
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
                                              day.name,
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
                          if (cultureDays.isNotEmpty)
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
                                  Navigator.pop(context, selectedDays);
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
