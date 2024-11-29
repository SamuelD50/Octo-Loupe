import 'package:flutter/material.dart';
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
  String selectedFilterId = '';
  List<dynamic> subFilters = [];
  bool isLoading = false;
  String? imageUrl;
  TextEditingController nameController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController newNameController = TextEditingController();
  TextEditingController newImageController = TextEditingController();
  
  /* Future<void> createSubFilter() async {
    setState(() {
      isLoading = true;
    });

    String name = nameController.text.trim();
    String image = imageController.text.trim();
    
    try {
      if (selectedSection == 0) {
        if (selectedFilter == 'Par catégorie') {
          String categoryId = DateTime.now().millisecondSinceEpoch.toString();
          await SportService().addSportCategory(categoryId, name, image);
        } else if (selectedFilter == 'Par âge') {
          String ageId = DateTime.now().millisecondSinceEpoch.toString();
          await SportService().addSportAge(ageId, name, image);
        } else if (selectedFilter == 'Par jour') {
          String dayId = DateTime.now().millisecondSinceEpoch.toString();
          await SportService().addSportDay(dayId, name, image);
        } else if (selectedFilter == 'Par horaire') {
          String scheduleId = DateTime.now().millisecondSinceEpoch.toString();
          await SportService().addSportSchedule(scheduleId, name, image);
        } else if (selectedFilter == 'Par secteur') {
          String sectorId = DateTime.now().millisecondSinceEpoch.toString();
          await SportService().addSportSector(sectorId, name, image);
        }
      } else {
        if (selectedFilter == 'Par catégorie') {
          String categoryId = DateTime.now().millisecondSinceEpoch.toString();
          await CultureService().addCultureCategory(categoryId, name, image);
        } else if (selectedFilter == 'Par âge') {
          String ageId = DateTime.now().millisecondSinceEpoch.toString();
          await CultureService().addCultureAge(ageId, name, image);
        } else if (selectedFilter == 'Par jour') {
          String dayId = DateTime.now().millisecondSinceEpoch.toString();
          await CultureService().addCultureDay(dayId, name, image);
        } else if (selectedFilter == 'Par horaire') {
          String scheduleId = DateTime.now().millisecondSinceEpoch.toString();
          await CultureService().addCultureSchedule(scheduleId, name, image);
        } else if (selectedFilter == 'Par secteur') {
          String sectorId = DateTime.now().millisecondSinceEpoch.toString();
          await CultureService().addCultureSector(sectorId, name, image);
        }
      }
    } catch (e) {
      debugPrint('Error creating filter: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  } */
  Future<void> createSubFilter() async {
    setState(() {
      isLoading = true;
    });

    String name = nameController.text.trim();
    String image = imageController.text.trim();

    try {
      if (selectedSection == 0) {
        // Section 'Sports'
        if (selectedFilter == 'Par catégorie') {
          await SportService().addSportCategory(null, name, image);  // ID généré automatiquement par Firestore
        } else if (selectedFilter == 'Par âge') {
          await SportService().addSportAge(null, name, image);  // ID généré automatiquement par Firestore
        } else if (selectedFilter == 'Par jour') {
          await SportService().addSportDay(null, name, image);  // ID généré automatiquement par Firestore
        } else if (selectedFilter == 'Par horaire') {
          await SportService().addSportSchedule(null, name, image);  // ID généré automatiquement par Firestore
        } else if (selectedFilter == 'Par secteur') {
          await SportService().addSportSector(null, name, image);  // ID généré automatiquement par Firestore
        }
      } else {
        // Section 'Cultures'
        if (selectedFilter == 'Par catégorie') {
          await CultureService().addCultureCategory(null, name, image);  // ID généré automatiquement par Firestore
        } else if (selectedFilter == 'Par âge') {
          await CultureService().addCultureAge(null, name, image);  // ID généré automatiquement par Firestore
        } else if (selectedFilter == 'Par jour') {
          await CultureService().addCultureDay(null, name, image);  // ID généré automatiquement par Firestore
        } else if (selectedFilter == 'Par horaire') {
          await CultureService().addCultureSchedule(null, name, image);  // ID généré automatiquement par Firestore
        } else if (selectedFilter == 'Par secteur') {
          await CultureService().addCultureSector(null, name, image);  // ID généré automatiquement par Firestore
        }
      }
    } catch (e) {
      debugPrint('Error creating filter: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> readSubFilters() async {
    setState(() {
      isLoading = true;
    });

    try {
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
    } catch (e) {
      debugPrint('Error reading filters: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /* Future<void> readSubFilter() async {
    setState(() {
      isLoading = true;
    });
    try {
      if (selectedSection == 0) {
        if (selectedFilter == 'Par catégorie') {
          subFilter = await SportService().getSportCategory(selectedFilterId);
        } else if (selectedFilter == 'Par âge') {
          subFilter = await SportService().getSportAge(selectedFilterId);
        } else if (selectedFilter == 'Par jour') {
          subFilter = await SportService().getSportDay(selectedFilterId);
        } else if (selectedFilter == 'Par horaire') {
          subFilter = await SportService().getSportSchedule(selectedFilterId);
        } else if (selectedFilter == 'Par secteur') {
          subFilter = await SportService().getSportSector(selectedFilterId);
        }
      } else {
        if (selectedFilter == 'Par catégorie') {
          subFilter = await CultureService().getCultureCategory(selectedFilterId);
        } else if (selectedFilter == 'Par âge') {
          subFilter = await CultureService().getCultureAge(selectedFilterId);
        } else if (selectedFilter == 'Par jour') {
          subFilter = await CultureService().getCultureDay(selectedFilterId);
        } else if (selectedFilter == 'Par horaire') {
          subFilter = await CultureService().getCultureSchedule(selectedFilterId);
        } else if (selectedFilter == 'Par secteur') {
          subFilter = await CultureService().getCultureSector(selectedFilterId);
        }
      }
    } catch (e) {
      debugPrint('Error fetching subfilter: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  } */

  Future<void> updateSubFilter() async {
    setState(() {
      isLoading = true;
    });

    String newName = newNameController.text.trim();
    String newImage = newImageController.text.trim();
    
    try {
      if (selectedSection == 0) {
        if (selectedFilter == 'Par catégorie') {
          await SportService().updateSportCategory(selectedFilterId, newName, newImage);
        } else if (selectedFilter == 'Par âge') {
          await SportService().updateSportAge(selectedFilterId, newName, newImage);
        } else if (selectedFilter == 'Par jour') {
          await SportService().updateSportDay(selectedFilterId, newName, newImage);
        } else if (selectedFilter == 'Par horaire') {
          await SportService().updateSportSchedule(selectedFilterId, newName, newImage);
        } else if (selectedFilter == 'Par secteur') {
          await SportService().updateSportSector(selectedFilterId, newName, newImage);
        }
      } else {
        if (selectedFilter == 'Par catégorie') {
          await CultureService().updateCultureCategory(selectedFilterId, newName, newImage);
        } else if (selectedFilter == 'Par âge') {
          await CultureService().updateCultureAge(selectedFilterId, newName, newImage);
        } else if (selectedFilter == 'Par jour') {
          await CultureService().updateCultureDay(selectedFilterId, newName, newImage);
        } else if (selectedFilter == 'Par horaire') {
          await CultureService().updateCultureSchedule(selectedFilterId, newName, newImage);
        } else if (selectedFilter == 'Par secteur') {
          await CultureService().updateCultureSector(selectedFilterId, newName, newImage);
        }
      }
    } catch (e) {
      debugPrint('Error updating subfilter: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteSubFilter() async {
    setState(() {
      isLoading = true;
    });

    try {
      if (selectedSection == 0) {
        if (selectedFilter == 'Par catégorie') {
          await SportService().deleteSportCategory(selectedFilterId);
        } else if (selectedFilter == 'Par âge') {
          await SportService().deleteSportAge(selectedFilterId);
        } else if (selectedFilter == 'Par jour') {
          await SportService().deleteSportDay(selectedFilterId);
        } else if (selectedFilter == 'Par horaire') {
          await SportService().deleteSportSchedule(selectedFilterId);
        } else if (selectedFilter == 'Par secteur') {
          await SportService().deleteSportSector(selectedFilterId);
        }
      } else {
        if (selectedFilter == 'Par catégorie') {
          await CultureService().deleteCultureCategory(selectedFilterId);
        } else if (selectedFilter == 'Par âge') {
          await CultureService().deleteCultureAge(selectedFilterId);
        } else if (selectedFilter == 'Par jour') {
          await CultureService().deleteCultureDay(selectedFilterId);
        } else if (selectedFilter == 'Par horaire') {
          await CultureService().deleteCultureSchedule(selectedFilterId);
        } else if (selectedFilter == 'Par secteur') {
          await CultureService().deleteCultureSchedule(selectedFilterId);
        }
      }
    } catch (e) {
      debugPrint('Error deleting subfilter: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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


  @override
  void initState() {
    super.initState();
    readSubFilters();
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
                  DropdownButton<String>(
                    value: selectedFilterId.isEmpty ? null : selectedFilterId,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedFilterId = newValue!;
                      });
                    },
                    items: subFilters.map((subFilter) {
                      return DropdownMenuItem<String>(
                        value: subFilter.id,
                        child: Text(subFilter.name),
                      );
                    }).toList(),
                  ),
                  if (isLoading)
                    Center(
                      child: SpinKitSpinningLines(
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                  if (selectedFilterId.isNotEmpty) ...[
                    imageUrl == null ?
                      GestureDetector(
                        onTap: pickImage,
                        child: Container(
                          height: 200,
                          width: 200,
                          color: Colors.grey,
                          child: Center(
                            child: Icon(
                              Icons.add_a_photo, size: 50,
                            )
                          ),
                        ),
                      )
                    : /* Image.file(File(imageUrl!)), */
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Nom du filtre',
                        hintText: 'Entrez le nom du sous-filtre',  
                      ),
                      onChanged: (value) {

                      },
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: updateSubFilter,
                          child: Text('Enregistrer les modifications'),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: deleteSubFilter,
                          child: Text('Supprimer ce filtre'),
                        ),
                      ],
                    ),
                  ],
                  ElevatedButton(
                    onPressed: createSubFilter,
                    child: Text('Ajouter un nouveau sous-filtre'),
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

/* 
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:octoloupe/components/custom_app_bar.dart';
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
  String selectedFilterId = '';
  List<dynamic> subFilters = [];
  bool isLoading = false;
  String? imageUrl;
  TextEditingController nameController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  
  final sportService = SportService();
  final cultureService = CultureService();

  Future<void> readSubFilters() async {
    setState(() {
      isLoading = true;
    });

    try {
      if (selectedSection == 0) {
        if (selectedFilter == 'Par catégorie') {
          subFilters = await sportService.getSportCategories();
        } else if (selectedFilter == 'Par âge') {
          subFilters = await sportService.getSportAges();
        } else if (selectedFilter == 'Par jour') {
          subFilters = await sportService.getSportDays();
        } else if (selectedFilter == 'Par horaire') {
          subFilters = await sportService.getSportSchedules();
        } else if (selectedFilter == 'Par secteur') {
          subFilters = await sportService.getSportSectors();
        }
      } else {
        if (selectedFilter == 'Par catégorie') {
          subFilters = await cultureService.getCultureCategories();
        } else if (selectedFilter == 'Par âge') {
          subFilters = await cultureService.getCultureAges();
        } else if (selectedFilter == 'Par jour') {
          subFilters = await cultureService.getCultureDays();
        } else if (selectedFilter == 'Par horaire') {
          subFilters = await cultureService.getCultureSchedules();
        } else if (selectedFilter == 'Par secteur') {
          subFilters = await cultureService.getCultureSectors();
        }
      }
    } catch (e) {
      debugPrint('Error fetching subfilters: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addNewFilter() async {
    if (selectedSection == 0) {
      if (selectedFilter == 'Par catégorie') {
        await sportService.addSportCategory('Nouvelle catégorie', imageUrl ?? '');
      } else if (selectedFilter == 'Par âge') {
        await sportService.addSportAge('Nouvel âge', imageUrl ?? '');
      } else if (selectedFilter == 'Par jour') {
        await sportService.addSportDay('Nouveau jour', imageUrl ?? '');
      } else if (selectedFilter == 'Par horaire') {
        await sportService.addSportSchedule('Nouvel horaire', imageUrl ?? '');
      } else if (selectedFilter == 'Par secteur') {
        await sportService.addSportSector('Nouveau secteur', imageUrl ?? '');
      }
      // Ajouter des conditions similaires pour les autres types de filtre
    } else {
      if (selectedFilter == 'Par catégorie') {
        await cultureService.addCultureCategory('Nouvelle catégorie', imageUrl ?? '');
      } else if (selectedFilter == 'Par âge') {
        await cultureService.addCultureAge('Nouvel âge', imageUrl ?? '');
      } else if (selectedFilter == 'Par jour') {
        await cultureService.addCultureDay('Nouveau jour', imageUrl ?? '');
      } else if (selectedFilter == 'Par horaire') {
        await cultureService.addCultureSchedule('Nouvel horaire', imageUrl ?? '');
      } else if (selectedFilter == 'Par secteur') {
        await cultureService.addCultureSector('Nouveau secteur', imageUrl ?? '');
      }
    }
    // Rafraîchir la liste des sous-filtres après ajout
    readSubFilters();
  }

  // Méthode pour sélectionner une image
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageUrl = pickedFile.path;
      });
    }
  }

  Future<void> saveChanges() async {
    if (selectedSection == 0) {
      if (selectedFilter == 'Par catégorie') {
        await sportService.updateSportCategory(selectedFilterId, 'New Name', imageUrl ?? '');
      } else if (selectedFilter == 'Par âge') {
        await sportService.updateSportAge(selectedFilterId, 'Nouvel âge', imageUrl ?? '');
      } else if (selectedFilter == 'Par jour') {
        await sportService.updateSportDay(selectedFilterId, 'Nouveau jour', imageUrl ?? '');
      } else if (selectedFilter == 'Par horaire') {
        await sportService.updateSportSchedule(selectedFilterId, 'Nouvel horaire', imageUrl ?? '');
      } else if (selectedFilter == 'Par secteur') {
        await sportService.updateSportSector(selectedFilterId, 'Nouveau secteur', imageUrl ?? '');
      }
    } else {
      if (selectedFilter == 'Par catégorie') {
        await cultureService.updateCultureCategory(selectedFilterId, 'New Name', imageUrl ?? '');
      } else if (selectedFilter == 'Par âge') {
        await cultureService.updateCultureAge(selectedFilterId, 'Nouvel âge', imageUrl ?? '');
      } else if (selectedFilter == 'Par jour') {
        await cultureService.updateCultureDay(selectedFilterId, 'Nouveau jour', imageUrl ?? '');
      } else if (selectedFilter == 'Par horaire') {
        await cultureService.updateCultureSchedule(selectedFilterId, 'Nouvel horaire', imageUrl ?? '');
      } else if (selectedFilter == 'Par secteur') {
        await cultureService.updateCultureSector(selectedFilterId, 'Nouveau secteur', imageUrl ?? '');
      }
    }
  }

  // Méthode pour supprimer un sous-filtre
  Future<void> deleteFilter() async {
    if (selectedSection == 0) {
      if (selectedFilter == 'Par catégorie') {
        await sportService.deleteSportCategory(selectedFilterId);
      } else if (selectedFilter == 'Par âge') {
        await sportService.deleteSportAge(selectedFilterId);
      } else if (selectedFilter == 'Par jour') {
        await sportService.deleteSportDay(selectedFilterId);
      } else if (selectedFilter == 'Par horaire') {
        await sportService.deleteSportSchedule(selectedFilterId);
      } else if (selectedFilter == 'Par secteur') {
        await sportService.deleteSportSector(selectedFilterId);
      }
    } else {
      if (selectedFilter == 'Par catégorie') {
        await cultureService.deleteCultureCategory(selectedFilterId);
      } else if (selectedFilter == 'Par âge') {
        await cultureService.deleteCultureAge(selectedFilterId);
      } else if (selectedFilter == 'Par jour') {
        await cultureService.deleteCultureDay(selectedFilterId);
      } else if (selectedFilter == 'Par horaire') {
        await cultureService.deleteCultureSchedule(selectedFilterId);
      } else if (selectedFilter == 'Par secteur') {
        await cultureService.deleteCultureSector(selectedFilterId);
      }
    }

    // Rafraîchir la liste des sous-filtres après suppression
    readSubFilters();
  }

  @override
  void initState() {
    super.initState();
    readSubFilters();
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
                        readSubFilters();
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
                  // Dropdown pour le sous-filtre
                  DropdownButton<String>(
                    value: selectedFilterId.isEmpty ? null : selectedFilterId,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedFilterId = newValue!;
                      });
                    },
                    items: subFilters.map((subFilter) {
                      return DropdownMenuItem<String>(
                        value: subFilter.id, // Assurez-vous que chaque sous-filtre a un `id`
                        child: Text(subFilter.name),
                      );
                    }).toList(),
                  ),
                  if (isLoading)
                    Center(
                      child: SpinKitSpinningLines(
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                  // Si un sous-filtre est sélectionné
                  if (selectedFilterId.isNotEmpty) ...[
                    imageUrl == null
                      ? GestureDetector(
                          onTap: pickImage,
                          child: Container(
                            height: 200,
                            width: 200,
                            color: Colors.grey[300],
                            child: Center(child: Icon(Icons.add_a_photo, size: 50)),
                          ),
                        )
                      : Image.file(File(imageUrl!)),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Nom',
                        hintText: 'Entrez le nom du sous-filtre',
                      ),
                      onChanged: (value) {
                        // Mise à jour du nom du sous-filtre
                      },
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: saveChanges,
                          child: Text('Enregistrer les modifications'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: deleteFilter,
                          child: Text('Supprimer ce filtre'),
                        ),
                      ],
                    ),
                  ],
                  // Ajouter un nouveau sous-filtre
                  ElevatedButton(
                    onPressed: addNewFilter,
                    child: Text('Ajouter un nouveau sous-filtre'),
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