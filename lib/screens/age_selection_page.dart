import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';

class AgeSelectionPage extends StatefulWidget {
  final List<String> selectedAges;
  final bool isSport;

  const AgeSelectionPage({
    super.key,
    required this.selectedAges,
    required this.isSport});

  @override
  AgeSelectionPageState createState() => AgeSelectionPageState();
}

class AgeSelectionPageState extends State<AgeSelectionPage> {
  late List<String> selectedAges;

  @override
  void initState() {
    super.initState();
    selectedAges = List.from(widget.selectedAges);
  }

  final List<Map<String, String>> sportAges = [
    {"name": "3-7 ans", "image": "assets/images/ballon.jpg"},
    {"name": "8-11 ans", "image": "assets/images/nautique.jpg"},
    {"name": "12-17 ans", "image": "assets/images/combat.jpg"},
    {"name": "18 ans et +", "image": "assets/images/athlétisme.jpg"},
  ];

  final List<Map<String, String>> cultureAges = [
    {"name": "3-7 ans", "image": "assets/images/ballon.jpg"},
    {"name": "8-11 ans", "image": "assets/images/nautique.jpg"},
    {"name": "12-17 ans", "image": "assets/images/combat.jpg"},
    {"name": "18 ans et +", "image": "assets/images/athlétisme.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
    final ages = widget.isSport ? sportAges : cultureAges;
    
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
                itemCount: ages.length,
                itemBuilder: (context, index) {
                  final ageName = ages[index]["name"]!;
                  final isSelected = selectedAges.contains(ageName);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedAges.remove(ageName);
                          debugPrint('Désélectionné: $ageName');
                        } else {
                          selectedAges.add(ageName);
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
                                color:Colors.black54,
                                offset: Offset(2, 2),
                                blurRadius: 4,
                              ),
                            ],
                      ),
                      child: Card(
                        elevation: isSelected ? 2 : 4,
                        shape : RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                ages[index]["image"]!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              color: Colors.black54,
                              child: Center(
                                child: Text(
                                  ageName,
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
                Navigator.pop(context, selectedAges);
              },
              child: Text('Valider'),
            ),
          ],
        ),
      ),
    );
  }
}