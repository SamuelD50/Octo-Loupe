/* import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:octoloupe/components/custom_app_bar.dart';
import 'package:octoloupe/model/sport_filter_model.dart';
import 'package:octoloupe/model/culture_filter_model.dart';
import 'package:octoloupe/services/sport_activity_section.dart';
import 'package:octoloupe/services/culture_activity_section.dart';
import 'dart:convert';

class AdminInterfacePage extends StatefulWidget {
  const AdminInterfacePage({super.key});

  @override
  AdminInterfacePageState createState() => AdminInterfacePageState();
}

class AdminInterfacePageState extends State<AdminInterfacePage> {
  int selectedSection = 0;
  String selectedFilter = "Par catégorie";
  late List<dynamic> subFilter = [];
  bool isLoading = false;
  String? imageUrl;

  Future<void> createSubFilter() async {
    setState(() {
      isLoading = true;
    });

    if (selectedSection == 0) {
      if (selectedFilter == 'Par catégorie') {
        subFilter = await SportService().addSportCategory(name, image);
      } else if (selectedFilter == 'Par âge') {
        subFilter = await SportService().addSportAge();
      } else if (selectedFilter == 'Par jour') {
        subFilter = await SportService().addSportDay();
      } else if (selectedFilter == 'Par horaire') {
        subFilter = await SportService().addSportSchedule();
      } else if (selectedFilter == 'Par secteur') {
        subFilter = await SportService().addSportSector();
      }
    } else {
      if (selectedFilter == 'Par catégorie') {
        subFilter = await CultureService().addCultureCategory();
      } else if (selectedFilter == 'Par âge') {
        subFilter = await CultureService().addCultureAge();
      } else if (selectedFilter == 'Par jour') {
        subFilter = await CultureService().addCultureDay();
      } else if (selectedFilter == 'Par horaire') {
        subFilter = await CultureService().addCultureSchedule();
      } else if (selectedFilter == 'Par secteur') {
        subFilter = await CultureService().addCultureSector();
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> readSubFilters() async {
    setState(() {
      isLoading = true;
    });

    if (selectedSection == 0) {
      if (selectedFilter == 'Par catégorie') {
        subFilters = await SportService().getSportCategories();
      } else if (selectedFilter == 'Par âge') {
        subFilters = await SportService().getSportAges();
      } else if (selectedFilter == 'Par jour') {
        subFilters = await SportService().getSportDays();
      } else if (selectedFilter == 'Par horaire') {
        subFilters = await SportService().getSportSchedules();
      } else if (selectedFilter == 'Par secteur') {
        subFilters = await SportService().getSportSectors();
      }
    } else {
      if (selectedFilter == 'Par catégorie') {
        subFilters = await CultureService().getCultureCategories();
      } else if (selectedFilter == 'Par âge') {
        subFilters = await CultureService().getCultureAges();
      } else if (selectedFilter == 'Par jour') {
        subFilters = await CultureService().getCultureDays();
      } else if (selectedFilter == 'Par horaire') {
        subFilters = await CultureService().getCultureSchedules();
      } else if (selectedFilter == 'Par secteur') {
        subFilters = await CultureService().getCultureSectors();
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> updateSubFilter() async {
    setState(() {
      isLoading = true;
    });

    if (selectedSection == 0) {
      if (selectedFilter == 'Par catégorie') {
        subFilter = await SportService().updateSportCategory();
      } else if (selectedFilter == 'Par âge') {
        subFilter = await SportService().updateSportAge();
      } else if (selectedFilter == 'Par jour') {
        subFilter = await SportService().updateSportDay();
      } else if (selectedFilter == 'Par horaire') {
        subFilter = await SportService().updateSportSchedule();
      } else if (selectedFilter == 'Par secteur') {
        subFilter = await SportService().updateSportSector();
      }
    } else {
      if (selectedFilter == 'Par catégorie') {
        subFilter = await CultureService().updateCultureCategory();
      } else if (selectedFilter == 'Par âge') {
        subFilter = await CultureService().updateCultureAge();
      } else if (selectedFilter == 'Par jour') {
        subFilter = await CultureService().updateCultureDay();
      } else if (selectedFilter == 'Par horaire') {
        subFilter = await CultureService().updateCultureSchedule();
      } else if (selectedFilter == 'Par secteur') {
        subFilter = await CultureService().updateCultureSector();
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteSubFilter() async {
    setState(() {
      isLoading = true;
    });

    if (selectedSection == 0) {
      if (selectedFilter == 'Par catégorie') {
        subFilter = await SportService().deleteSportCategory();
      } else if (selectedFilter == 'Par âge') {
        subFilter = await SportService().deleteSportAge();
      } else if (selectedFilter == 'Par jour') {
        subFilters = await SportService().deleteSportDay();
      } else if (selectedFilter == 'Par horaire') {
        subFilters = await SportService().deleteSportSchedule();
      } else if (selectedFilter == 'Par secteur') {
        subFilters = await SportService().deleteSportSector();
      }
    } else {
      if (selectedFilter == 'Par catégorie') {
        subFilters = await CultureService().deleteCultureCategory();
      } else if (selectedFilter == 'Par âge') {
        subFilters = await CultureService().deleteCultureAge();
      } else if (selectedFilter == 'Par jour') {
        subFilters = await CultureService().deleteCultureDay();
      } else if (selectedFilter == 'Par horaire') {
        subFilters = await CultureService().deleteCultureSchedule();
      } else if (selectedFilter == 'Par secteur') {
        subFilters = await CultureService().deleteCultureSchedule();
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageUrl = pickedFile.path;
      });
    }
  }


/*   List<SportCategory> sportCategories = [];
  List<SportAge> sportAges = [];
  List<SportDay> sportDays = [];
  List<SportSchedule> sportSchedules = [];
  List<SportSector> sportSectors = [];

  List<CultureCategory> cultureCategories = [];
  List<CultureAge> cultureAges = [];
  List<CultureDay> cultureDays = [];
  List<CultureSchedule> cultureSchedules = [];
  List<CultureSector> cultureSectors = []; */


  @override
  void initState() {
    super.initState();
    loadSubFilters();
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
                    isSelected: [selectedSection == 0, selectedSection == 1],
                    onPressed: (int section) {
                      setState(() {
                        selectedSection = section;
                        getSubFilters();
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
                  DropdownButton<String>(
                    value: selectedFilter,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedFilter = newValue!;
                        readSubFilters();
                      });
                    },
                    items: ['Par catégorie', 'Par âge', 'Par jour', 'Par horaire', 'Par secteur']
                      .map((String filter) {
                        return DropdownMenuItem<String>(
                          value: filter,
                          child: Text(filter),
                        );
                      }).toList(),
                  ),
                  if (isLoading) ...[
                    Center(
                      child: SpinKitSpinningLines(
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                  ] else if (subFilters.isEmpty) ...[
                    GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Color(0xFF5B59B4),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                          ),
                          child: Center(
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        );
                      },
                    ),
                  ] else ...[
                    GridView.builder(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: subFilters.length+1,
                      itemBuilder: (context, index) {
                        if (index < subFilters.length) {
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    subFilters[index].image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Center(
                                    child: Text(
                                      subFilters[index].name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      )
                                    ),
                                  )
                                )
                              ],
                            )
                          );
                        } else {
                          return Card(
                            color: Color(0xFF5B59B4),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 24,
                              )
                            )
                          );
                        }    
                      }
                    ),
                  ]
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:octoloupe/services/sport_activity_section.dart'; // Importer le service
import 'package:octoloupe/model/sport_filter_model.dart'; // Importer le modèle

class AdminInterfacePage extends StatefulWidget {
  const AdminInterfacePage({super.key});

  @override
  AdminInterfacePageState createState() => AdminInterfacePageState();
}

class AdminInterfacePageState extends State<AdminInterfacePage> {
  final SportService sportService = SportService();
  late List<SportCategory> sportCategories;
  late List<SportAge> sportAges;
  late List<SportDay> sportDays;
  late List<SportSchedule> sportSchedules;
  late List<SportSector> sportSectors;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    sportCategories = await sportService.getSportCategories();
    sportAges = await sportService.getSportAges();
    sportDays = await sportService.getSportDays();
    sportSchedules = await sportService.getSportSchedules();
    sportSectors = await sportService.getSportSectors();
    setState(() {}); // Rafraîchit l'interface après avoir chargé les données
  }

  // Fonction pour afficher un dialog pour ajouter un filtre
  Future<void> _showAddFilterDialog(String filterType) async {
    final nameController = TextEditingController();
    final imageController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ajouter un $filterType'),
          content: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nom'),
              ),
              TextField(
                controller: imageController,
                decoration: InputDecoration(labelText: 'URL de l\'image'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                // Ajoute le filtre en fonction du type sélectionné
                final name = nameController.text;
                final image = imageController.text;

                if (name.isNotEmpty && image.isNotEmpty) {
                  if (filterType == 'category') {
                    await sportService.addSportCategory(name, image);
                  } else if (filterType == 'age') {
                    await sportService.addSportAge(name, image);
                  } else if (filterType == 'day') {
                    await sportService.addSportDay(name, image);
                  } else if (filterType == 'schedule') {
                    await sportService.addSportSchedule(name, image);
                  } else if (filterType == 'sector') {
                    await sportService.addSportSector(name, image);
                  }
                  _loadData(); // Recharge les données après ajout
                  Navigator.pop(context);
                }
              },
              child: Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  // Fonction pour afficher un dialog pour mettre à jour un filtre
  Future<void> _showUpdateFilterDialog(String filterType, String id, String currentName, String currentImage) async {
    final nameController = TextEditingController(text: currentName);
    final imageController = TextEditingController(text: currentImage);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Mettre à jour le $filterType'),
          content: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nom'),
              ),
              TextField(
         actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                final name = nameController.text;
                final image = imageController.text;

                if (name.isNotEmpty && image.isNotEmpty) {
                  if (filterType == 'category') {
                    await sportService.updateSportCategory(id, name, image);
                  } else if (filterType == 'age') {
                    await sportService.updateSportAge(id, name, image);
                  } else if (filterType == 'day') {
                    await sportService.updateSportDay(id, name, image);
                  } else if (filterType == 'schedule') {
                    await sportService.updateSportSchedule(id, name, image);
                  } else if (filterType == 'sector') {
                    await sportService.updateSportSector(id, name, image);
                  }
                  _loadData(); // Recharge les données après mise à jour
                  Navigator.pop(context);
                }
              },
              child: Text('Mettre à jour'),
            ),
          ],
        );
      },
    );
  }

  // Fonction pour supprimer un filtre
  Future<void> _showDeleteFilterDialog(String filterType, String id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Supprimer ce $filterType'),
          content: Text('Êtes-vous sûr de vouloir supprimer cet élément ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                if (filterType == 'category') {
                  await sportService.deleteSportCategory(id);
                } else if (filterType == 'age') {
                  await sportService.deleteSportAge(id);
                } else if (filterType == 'day') {
                  await sportService.deleteSportDay(id);
                } else if (filterType == 'schedule') {
                  await sportService.deleteSportSchedule(id);
                } else if (filterType == 'sector') {
                  await sportService.deleteSportSector(id);
                }
                _loadData(); // Recharge les données après suppression
                Navigator.pop(context);
              },
              child: Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Interface'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: [
          // Categories Section
          _buildFilterSection('Categories', sportCategories, 'category'),

          // Ages Section
          _buildFilterSection('Ages', sportAges, 'age'),

          // Days Section
          _buildFilterSection('Days', sportDays, 'day'),

          // Schedules Section
          _buildFilterSection('Schedules', sportSchedules, 'schedule'),

          // Sectors Section
          _buildFilterSection('Sectors', sportSectors, 'sector'),
        ],
      ),
    );
  }

  // Fonction pour afficher les sections de filtres
  Widget _buildFilterSection(String sectionName, List<dynamic> filters, String filterType) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text(sectionName),
            trailing: IconButton(
              icon: Icon(Icons.add),
              onPressed: () => _showAddFilterDialog(filterType),
            ),
          ),
          Divider(),
          ...filters.map((filter) {
            if (filter is SportCategory) {
              // Traitement spécifique pour SportCategory
              String id = filter.id;
              String name = filter.name;
              String image = filter.image;
              return ListTile(
                title: Text(name),
                subtitle: Text('Image: $image'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _showUpdateFilterDialog(filterType, id, name, image),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _showDeleteFilterDialog(filterType, id),
                    ),
                  ],
                ),
              );
            } else if (filter is SportAge) {
              // Traitement spécifique pour SportAge
              String id = filter.id;
              String name = filter.name;
              String image = filter.image;
              return ListTile(
                title: Text(name),
                subtitle: Text('Image: $image'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _showUpdateFilterDialog(filterType, id, name, image),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _showDeleteFilterDialog(filterType, id),
                    ),
                  ],
                ),
              );
            }
            // Ajoutez des conditions similaires pour les autres types de filtres (SportDay, SportSchedule, SportSector)
            return SizedBox.shrink(); // Retourne un widget vide si le type n'est pas reconnu
          }).toList(),
        ],
      ),
    );
  }
}                controller: imageController,
                decoration: InputDecoration(labelText: 'URL de l\'image'),
              ),
            ],
          ),
 
