import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';

class DaySelectionPage extends StatefulWidget {
  final List<String> selectedDays;
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
  late List<String> selectedDays;

  @override
  void initState() {
    super.initState();
    selectedDays = List.from(widget.selectedDays);
  }

  final List<Map<String, String>> sportDays =[
    {"name": "Lundi", "image": "assets/images/ballon.jpg"},
    {"name": "Mardi", "image": "assets/images/nautique.jpg"},
    {"name": "Mercredi", "image": "assets/images/combat.jpg"},
    {"name": "Jeudi", "image": "assets/images/athlétisme.jpg"},
    {"name": "Vendredi", "image": "assets/images/raquette.jpg"},
    {"name": "Samedi", "image": "assets/images/collectif.jpg"},
    {"name": "Dimanche", "image": "assets/images/individuel.jpg"},
  ];

  final List<Map<String, String>> cultureDays =[
    {"name": "Lundi", "image": "assets/images/ballon.jpg"},
    {"name": "Mardi", "image": "assets/images/nautique.jpg"},
    {"name": "Mercredi", "image": "assets/images/combat.jpg"},
    {"name": "Jeudi", "image": "assets/images/athlétisme.jpg"},
    {"name": "Vendredi", "image": "assets/images/raquette.jpg"},
    {"name": "Samedi", "image": "assets/images/collectif.jpg"},
    {"name": "Dimanche", "image": "assets/images/individuel.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
    final days = widget.isSport ? sportDays : cultureDays;
    
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
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: days.length,
                itemBuilder: (context, index) {
                  final dayName = days[index]["name"]!;
                  final isSelected = selectedDays.contains(dayName);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedDays.remove(dayName);
                          debugPrint('Désélectionné: $dayName');
                        } else {
                          selectedDays.add(dayName);
                          debugPrint('Séléctionné: $dayName');
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
                                days[index]["image"]!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              color: Colors.black54,
                              child: Center(
                                child: Text(
                                  dayName,
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
              )
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, selectedDays);
              },
              child: Text('Valider'),
            ),
          ],
        ),
      )
    );
  }
}