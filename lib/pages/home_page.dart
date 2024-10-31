import 'package:octoloupe/components/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'category_selection_page.dart';
import 'age_selection_page.dart';
import 'day_selection_page.dart';
import 'schedule_selection_page.dart';
import 'sector_selection_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<String> selectedCategories = [];
  List<String> selectedAges = [];
  List<String> selectedDays = [];
  List<String> selectedSchedules = [];
  List<String> selectedSectors = [];
  
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
                      final List<String>? categories = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CategorySelectionPage(selectedCategories: selectedCategories)),
                      );
                      if (categories != null) {
                        setState(() {
                          selectedCategories = categories;
                        });
                      }
                    },
                  ),
                  _buildCriteriaTile(
                    context,
                    Icons.accessibility_new,
                    'Par âge',
                    () async {
                      final List<String>? ages = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AgeSelectionPage(selectedAges: selectedAges)),
                      );
                      if (ages != null) {
                        setState(() {
                          selectedAges = ages;
                        });
                      }
                    },
                  ),
                  _buildCriteriaTile(
                    context,
                    Icons.date_range,
                    'Par jour',
                    () async {
                      final List<String>? days = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DaySelectionPage(selectedDays:selectedDays)),
                      );
                      if (days != null) {
                        setState(() {
                          selectedDays = days;
                        });
                      }
                    },
                  ),
                  _buildCriteriaTile(
                    context,
                    Icons.access_time,
                    'Par horaire',
                    () async {
                      final List<String>? schedules = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ScheduleSelectionPage(selectedSchedules:selectedSchedules)),
                      );
                      if (schedules != null) {
                        setState(() {
                          selectedSchedules = schedules;
                        });
                      }
                    },
                  ),
                  _buildCriteriaTile(
                    context,
                    Icons.apartment_rounded,
                    'Par secteur',
                    () async {
                      final List<String>? sectors = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SectorSelectionPage(selectedSectors:selectedSectors)),
                      );
                      if (sectors != null) {
                        setState(() {
                          selectedSectors = sectors;
                        });
                      }
                    },
                  ),
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
            if (selectedAges.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 8.0,
                  children: selectedAges.map((age) {
                    return Chip(
                      label: Text(age),
                      onDeleted: () {
                        setState(() {
                          selectedAges.remove(age);
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
            if (selectedDays.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 8.0,
                  children: selectedDays.map((day) {
                    return Chip(
                      label: Text(day),
                      onDeleted: () {
                        setState(() {
                          selectedDays.remove(day);
                        });
                      },
                    );
                  }).toList()
                ),
              ),
            ],
            if (selectedSchedules.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 8.0,
                  children: selectedSchedules.map((schedule) {
                    return Chip(
                      label: Text(schedule),
                      onDeleted: () {
                        setState(() {
                          selectedSchedules.remove(schedule);
                        });
                      },
                    );
                  }).toList()
                ),
              ),
            ],
            if (selectedSectors.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 8.0,
                  children: selectedSectors.map((sector) {
                    return Chip(
                      label: Text(sector),
                      onDeleted: () {
                        setState(() {
                          selectedSectors.remove(sector);
                        });
                      },
                    );
                  }).toList()
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

  Widget _buildCriteriaTile(BuildContext context, IconData icon, String label, Future<void> Function() pageBuilder) {
    return GestureDetector(
      onTap: pageBuilder,
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