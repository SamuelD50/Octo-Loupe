/* import 'package:flutter/material.dart';
import 'package:octoloupe/components/custom_app_bar.dart';
import 'package:octoloupe/model/sport_filter_model.dart';
import 'package:octoloupe/model/culture_filter_model.dart';
import 'package:octoloupe/services/sport_activity_section.dart';
import 'package:octoloupe/services/culture_activity_section.dart';

class AdminInterfacePage extends StatefulWidget {
  const AdminInterfacePage({super.key});

  @override
  AdminInterfacePageState createState() => AdminInterfacePageState();
}

class AdminInterfacePageState extends State<AdminInterfacePage> {
  int _selectedSection = 0;

  String _selectedFilter = "Par catégorie";
  String? _selectedCategory;
  String? _selectedAge;
  String? _selectedDay;
  String? _selectedSchedule;
  String? _selectedSector;

  List<SportCategory> sportCategories = [];
  List<SportAge> sportAges = [];
  List<SportDay> sportDays = [];
  List<SportSchedule> sportSchedules = [];
  List<SportSector> sportSectors = [];

  List<CultureCategory> cultureCategories = [];
  List<CultureAge> cultureAges = [];
  List<CultureDay> cultureDays = [];
  List<CultureSchedule> cultureSchedules = [];
  List<CultureSector> cultureSectors = [];

  final SportService _sportService = SportService();
  final CultureService _cultureService = CultureService();

  // Charger les catégories et autres filtres selon la section (Sport / Culture)
  Future<void> loadFilters() async {
    if (_selectedSection == 0) {
      // Charger les filtres pour Sport
      sportCategories = await _sportService.getSportCategories();
      sportAges = await _sportService.getSportAges();
      sportDays = await _sportService.getSportDays();
      sportSchedules = await _sportService.getSportSchedules();
      sportSectors = await _sportService.getSportSectors();
    } else {
      // Charger les filtres pour Culture
      cultureCategories = await _cultureService.getCultureCategories();
      cultureAges = await _cultureService.getCultureAges();
      cultureDays = await _cultureService.getCultureDays();
      cultureSchedules = await _cultureService.getCultureSchedules();
      cultureSectors = await _cultureService.getCultureSectors();
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadFilters(); // Charger les filtres par défaut (Sport)
  }

  @override
  Widget build(BuildContext context) {
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
                  ToggleButtons(
                    isSelected: [_selectedSection == 0, _selectedSection == 1],
                    onPressed: (int section) {
                      setState(() {
                        _selectedSection = section;
                      });
                    },
                    color: Colors.black,
                    selectedColor: Colors.white,
                    fillColor: Color(0xFF5B59B4),
                    borderColor: Color(0xFF5B59B4),
                    selectedBorderColor: Color(0xFF5B59B4),
                    borderRadius: BorderRadius.circular(20.0),
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
                  
                ],
              ),
            ),
          ),
        ],
      ),
    );
  } 
}
 */

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:octoloupe/model/sport_filter_model.dart';
import 'package:octoloupe/model/culture_filter_model.dart';
import 'package:octoloupe/services/sport_activity_section.dart';
import 'package:octoloupe/services/culture_activity_section.dart';

class AdminInterfacePage extends StatefulWidget {
  const AdminInterfacePage({super.key});

  @override
  AdminInterfacePageState createState() => AdminInterfacePageState();
}

class AdminInterfacePageState extends State<AdminInterfacePage> {
  int _selectedSection = 0; // 0 pour Sport, 1 pour Culture
  String _selectedFilter = "Par catégorie"; // Choix du filtre principal
  String? _selectedCategory;
  String? _selectedAge;
  String? _selectedDay;
  String? _selectedSchedule;
  String? _selectedSector;

  // Variables pour les catégories et filtres
  List<SportCategory> sportCategories = [];
  List<SportAge> sportAges = [];
  List<SportDay> sportDays = [];
  List<SportSchedule> sportSchedules = [];
  List<SportSector> sportSectors = [];

  List<CultureCategory> cultureCategories = [];
  List<CultureAge> cultureAges = [];
  List<CultureDay> cultureDays = [];
  List<CultureSchedule> cultureSchedules = [];
  List<CultureSector> cultureSectors = [];

  // Services pour charger les filtres
  final SportService _sportService = SportService();
  final CultureService _cultureService = CultureService();

  // Variables pour l'ajout ou la modification d'un sous-filtre
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  String? _newSubFilterName;

  // Charger les filtres selon la section choisie
  Future<void> loadFilters() async {
    if (_selectedSection == 0) {
      // Charger les filtres pour Sport
      sportCategories = await _sportService.getSportCategories();
      sportAges = await _sportService.getSportAges();
      sportDays = await _sportService.getSportDays();
      sportSchedules = await _sportService.getSportSchedules();
      sportSectors = await _sportService.getSportSectors();
    } else {
      // Charger les filtres pour Culture
      cultureCategories = await _cultureService.getCultureCategories();
      cultureAges = await _cultureService.getCultureAges();
      cultureDays = await _cultureService.getCultureDays();
      cultureSchedules = await _cultureService.getCultureSchedules();
      cultureSectors = await _cultureService.getCultureSectors();
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadFilters(); // Charger les filtres par défaut (Sport)
  }

  // Fonction pour choisir une image depuis la galerie
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  // Fonction pour ajouter un sous-filtre
  void _addSubFilter() {
    if (_newSubFilterName != null && _newSubFilterName!.isNotEmpty && _selectedImage != null) {
      // Ajouter un sous-filtre ici, par exemple en l'ajoutant à Firestore ou une liste locale.
      print('Sous-filtre ajouté : ${_newSubFilterName}, image: ${_selectedImage?.path}');
    } else {
      // Afficher un message d'erreur si le nom ou l'image est manquant
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Nom et image obligatoires")));
    }
  }

  // Fonction pour supprimer un sous-filtre
  void _deleteSubFilter(String filterName) {
    // Supprimer le sous-filtre
    print('Sous-filtre supprimé : $filterName');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Interface")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Choix entre Sport et Culture
            ToggleButtons(
              isSelected: [_selectedSection == 0, _selectedSection == 1],
              onPressed: (int section) {
                setState(() {
                  _selectedSection = section;
                  loadFilters(); // Recharger les filtres
                });
              },
              color: Colors.black,
              selectedColor: Colors.white,
              fillColor: Color(0xFF5B59B4),
              borderColor: Color(0xFF5B59B4),
              selectedBorderColor: Color(0xFF5B59B4),
              borderRadius: BorderRadius.circular(20.0),
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

            // Choisir un filtre principal (Par catégorie, Par âge, ...)
            DropdownButton<String>(
              value: _selectedFilter,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedFilter = newValue!;
                });
              },
              items: ["Par catégorie", "Par âge", "Par jour", "Par horaire", "Par secteur"]
                  .map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
            ),

            // Afficher les sous-filtres selon le filtre choisi
            if (_selectedFilter == "Par catégorie") ...[
              DropdownButton<String>(
                value: _selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                hint: Text("Choisir une catégorie"),
                items: (_selectedSection == 0
                    ? sportCategories.map((category) => category.name).toList()
                    : cultureCategories.map((category) => category.name).toList())
                    .map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
              ),
            ],

            // Formulaire pour ajouter/modifier un sous-filtre
            TextField(
              decoration: InputDecoration(labelText: "Nom du sous-filtre"),
              onChanged: (value) {
                _newSubFilterName = value;
              },
            ),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text(_selectedImage == null ? "Choisir une image" : "Modifier l'image"),
            ),

            ElevatedButton(
              onPressed: _addSubFilter,
              child: Text("Ajouter le sous-filtre"),
            ),
          ],
        ),
      ),
    );
  }
}