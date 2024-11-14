import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';

class SectorSelectionPage extends StatefulWidget {
  final List<String> selectedSectors;
  final bool isSport;

  const SectorSelectionPage({
    super.key,
    required this.selectedSectors,
    required this.isSport,
  });

  @override
  SectorSelectionPageState createState() => SectorSelectionPageState();
}

class SectorSelectionPageState extends State<SectorSelectionPage> {
  late List<String> selectedSectors;

  @override
  void initState() {
    super.initState();
    selectedSectors = List.from(widget.selectedSectors);
  }

  final List<Map<String, String>> sportSectors = [
    {"name": "Equeurdreville-Haineville", "image": "assets/images/ballon.jpg"},
    {"name": "Cherbourg-Centre", "image": "assets/images/nautique.jpg"},
    {"name": "Tourlaville", "image": "assets/images/combat.jpg"},
    {"name": "Querqueville", "image": "assets/images/athlétisme.jpg"},
  ];

  final List<Map<String, String>> cultureSectors = [
    {"name": "Equeurdreville-Haineville", "image": "assets/images/ballon.jpg"},
    {"name": "Cherbourg-Centre", "image": "assets/images/nautique.jpg"},
    {"name": "Tourlaville", "image": "assets/images/combat.jpg"},
    {"name": "Querqueville", "image": "assets/images/athlétisme.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
    final sectors = widget.isSport ? sportSectors : cultureSectors;
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
                itemCount: sectors.length,
                itemBuilder: (context, index) {
                  final sectorName = sectors[index]["name"]!;
                  final isSelected = selectedSectors.contains(sectorName);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedSectors.remove(sectorName);
                          debugPrint('Sélectionné: $sectorName');
                        } else {
                          selectedSectors.add(sectorName);
                          debugPrint('Sélectionné: $sectorName');
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
                                sectors[index]["image"]!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              color: Colors.black54,
                              child: Center(
                                child: Text(
                                  sectorName,
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
                Navigator.pop(context, selectedSectors);
              },
              child: Text('Valider'),
            ),
          ],
        ),
      )
    );
  }
}