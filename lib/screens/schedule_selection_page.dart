import 'package:flutter/material.dart';
import '../components/custom_app_bar.dart';

class ScheduleSelectionPage extends StatefulWidget {
  final List<String> selectedSchedules;
  final bool isSport;

  const ScheduleSelectionPage({
    super.key,
    required this.selectedSchedules,
    required this.isSport,
  });

  @override
  ScheduleSelectionPageState createState() => ScheduleSelectionPageState();
}

class ScheduleSelectionPageState extends State<ScheduleSelectionPage> {
  late List<String> selectedSchedules;

  @override
  void initState() {
    super.initState();
    selectedSchedules = List.from(widget.selectedSchedules);
  }

  final List<Map<String, String>> sportSchedules = [
    {"name": "8h-12h", "image": "assets/images/ballon.jpg"},
    {"name": "12h-14h", "image": "assets/images/nautique.jpg"},
    {"name": "14h-17h", "image": "assets/images/combat.jpg"},
    {"name": "17h-22h", "image": "assets/images/athlétisme.jpg"},
  ];

  final List<Map<String, String>> cultureSchedules = [
    {"name": "8h-12h", "image": "assets/images/ballon.jpg"},
    {"name": "12h-14h", "image": "assets/images/nautique.jpg"},
    {"name": "14h-17h", "image": "assets/images/combat.jpg"},
    {"name": "17h-22h", "image": "assets/images/athlétisme.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
    final schedules = widget.isSport ? sportSchedules : cultureSchedules;

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
                itemCount: schedules.length,
                itemBuilder: (context, index) {
                  final scheduleName = schedules[index]["name"]!;
                  final isSelected = selectedSchedules.contains(scheduleName);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedSchedules.remove(scheduleName);
                          debugPrint('Sélectionné: $scheduleName');
                        } else {
                          selectedSchedules.add(scheduleName);
                          debugPrint('Sélectionné: $scheduleName');
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
                                schedules[index]["image"]!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              color: Colors.black54,
                              child: Center(
                                child: Text(
                                  scheduleName,
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
                Navigator.pop(context, selectedSchedules);
              },
              child: Text('Valider'),
            ),
          ],
        ),
      )
    );
  }
}