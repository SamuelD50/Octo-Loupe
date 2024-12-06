import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:octoloupe/components/custom_app_bar.dart';
import 'package:octoloupe/model/sport_filter_model.dart';
import 'package:octoloupe/model/culture_filter_model.dart';
import 'package:octoloupe/services/sport_activity_section.dart';
import 'package:octoloupe/services/culture_activity_section.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';
import 'package:path/path.dart';
import 'dart:io';

class AdminInterfacePage extends StatefulWidget {
  const AdminInterfacePage({super.key});

  @override
  AdminInterfacePageState createState() => AdminInterfacePageState();
}

enum SubFilterMode { adding, editing, deleting }

class AdminInterfacePageState extends State<AdminInterfacePage> {
  SubFilterMode _currentMode = SubFilterMode.adding;
  final _addSubFilterKey = GlobalKey<FormState>();
  final _editSubFilterKey = GlobalKey<FormState>();
  final _deleteSubFilterKey = GlobalKey<FormState>();
  int selectedSection = 0;
  String selectedFilter = "Par catégorie";
  String selectedSubFilterId = '';
  String selectedSubFilterIdForEditing = '';
  String selectedSubFilterIdForDeleting = '';
  List<dynamic> subFilters = [];
  bool isLoading = false;
  bool isAdding = false;
  bool isEditing = false;
  bool isDeleting = false;

  String? imageUrl;
  String? newImageUrl;
  TextEditingController nameController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();
  TextEditingController newNameController = TextEditingController();
  TextEditingController newImageUrlController = TextEditingController();
  
  Future<void> createSubFilter() async {
    setState(() {
      isLoading = true;
    });

    String name = nameController.text.trim();
    String imageUrl = imageUrlController.text.trim();
    
    try {
      if (selectedSection == 0) {
        if (selectedFilter == 'Par catégorie') {
          await SportService().addSportCategory(null, name, imageUrl);
        } else if (selectedFilter == 'Par âge') {
          await SportService().addSportAge(null, name, imageUrl);
        } else if (selectedFilter == 'Par jour') {
          await SportService().addSportDay(null, name, imageUrl);
        } else if (selectedFilter == 'Par horaire') {
          await SportService().addSportSchedule(null, name, imageUrl);
        } else if (selectedFilter == 'Par secteur') {
          await SportService().addSportSector(null, name, imageUrl);
        }
      } else {
        if (selectedFilter == 'Par catégorie') {
          await CultureService().addCultureCategory(null, name, imageUrl);
        } else if (selectedFilter == 'Par âge') {
          await CultureService().addCultureAge(null, name, imageUrl);
        } else if (selectedFilter == 'Par jour') {
          await CultureService().addCultureDay(null, name, imageUrl);
        } else if (selectedFilter == 'Par horaire') {
          await CultureService().addCultureSchedule(null, name, imageUrl);
        } else if (selectedFilter == 'Par secteur') {
          await CultureService().addCultureSector(null, name, imageUrl);
        }
      }
    } catch (e) {
      debugPrint('Error creating sub-filter: $e');
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
          debugPrint(subFilters.toString());
        } else if (selectedFilter == 'Par âge') {
          subFilters = await SportService().getSportAges();
          debugPrint(subFilters.toString());
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

      if (!subFilters.any((subFilter) => subFilter.id == selectedSubFilterIdForDeleting)) {
        setState(() {
          selectedSubFilterIdForDeleting = '';
        });
      }
    } catch (e) {
      debugPrint('Error reading sub-filters: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> updateSubFilter() async {
    setState(() {
      isLoading = true;
    });

    String newName = newNameController.text.trim();
    String newImageUrl = newImageUrlController.text.trim();
    
    try {
      if (selectedSection == 0) {
        if (selectedFilter == 'Par catégorie') {
          await SportService().updateSportCategory(selectedSubFilterId, newName, newImageUrl);
        } else if (selectedFilter == 'Par âge') {
          await SportService().updateSportAge(selectedSubFilterId, newName, newImageUrl);
        } else if (selectedFilter == 'Par jour') {
          await SportService().updateSportDay(selectedSubFilterId, newName, newImageUrl);
        } else if (selectedFilter == 'Par horaire') {
          await SportService().updateSportSchedule(selectedSubFilterId, newName, newImageUrl);
        } else if (selectedFilter == 'Par secteur') {
          await SportService().updateSportSector(selectedSubFilterId, newName, newImageUrl);
        }
      } else {
        if (selectedFilter == 'Par catégorie') {
          await CultureService().updateCultureCategory(selectedSubFilterId, newName, newImageUrl);
        } else if (selectedFilter == 'Par âge') {
          await CultureService().updateCultureAge(selectedSubFilterId, newName, newImageUrl);
        } else if (selectedFilter == 'Par jour') {
          await CultureService().updateCultureDay(selectedSubFilterId, newName, newImageUrl);
        } else if (selectedFilter == 'Par horaire') {
          await CultureService().updateCultureSchedule(selectedSubFilterId, newName, newImageUrl);
        } else if (selectedFilter == 'Par secteur') {
          await CultureService().updateCultureSector(selectedSubFilterId, newName, newImageUrl);
        }
      }
    } catch (e) {
      debugPrint('Error updating sub-filter: $e');
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
          await SportService().deleteSportCategory(selectedSubFilterId);
        } else if (selectedFilter == 'Par âge') {
          await SportService().deleteSportAge(selectedSubFilterId);
        } else if (selectedFilter == 'Par jour') {
          await SportService().deleteSportDay(selectedSubFilterId);
        } else if (selectedFilter == 'Par horaire') {
          await SportService().deleteSportSchedule(selectedSubFilterId);
        } else if (selectedFilter == 'Par secteur') {
          await SportService().deleteSportSector(selectedSubFilterId);
        }
      } else {
        if (selectedFilter == 'Par catégorie') {
          await CultureService().deleteCultureCategory(selectedSubFilterId);
        } else if (selectedFilter == 'Par âge') {
          await CultureService().deleteCultureAge(selectedSubFilterId);
        } else if (selectedFilter == 'Par jour') {
          await CultureService().deleteCultureDay(selectedSubFilterId);
        } else if (selectedFilter == 'Par horaire') {
          await CultureService().deleteCultureSchedule(selectedSubFilterId);
        } else if (selectedFilter == 'Par secteur') {
          await CultureService().deleteCultureSector(selectedSubFilterId);
        }
      }
    } catch (e) {
      debugPrint('Error deleting sub-filter: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  bool isNameDuplicated(String name) {
    return subFilters.any((subFilter) =>
      subFilter.name.toLowerCase() == name.toLowerCase() &&
      subFilter.id != selectedSubFilterIdForEditing);
  }

  @override
  void initState() {
    super.initState();
    selectedFilter = "Par catégorie";
    imageUrlController.addListener(() {
      setState(() {
        imageUrl = imageUrlController.text;
      });
    });
    newImageUrlController.addListener(() {
      setState(() {
        newImageUrl = newImageUrlController.text;
      });
    });
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
                  Text(
                    'Modifier l\'interface de l\'application',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children : [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF5B59B4),
                          foregroundColor: Colors.white,
                          side: BorderSide(color: Color(0xFF5B59B4)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _currentMode = SubFilterMode.adding;
                          });
                        },
                        child: Icon(Icons.add, size: 30),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF5B59B4),
                          foregroundColor: Colors.white,
                          side: BorderSide(color: Color(0xFF5B59B4)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _currentMode = SubFilterMode.editing;
                          });
                        },
                        child: Icon(Icons.edit, size: 30),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF5B59B4),
                          foregroundColor: Colors.white,
                          side: BorderSide(color: Color(0xFF5B59B4)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _currentMode = SubFilterMode.deleting;
                          });
                        },
                        child: Icon(Icons.remove, size: 30),
                      ),
                    ], 
                  ),
                  SizedBox(height: 16),

                  if (_currentMode == SubFilterMode.adding) _buildAddSubFilter(context),
                  if (_currentMode == SubFilterMode.editing) _buildEditSubFilter(context),
                  if (_currentMode == SubFilterMode.deleting) _buildDeleteSubFilter(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddSubFilter(BuildContext context) {
    return Form(
      key: _addSubFilterKey,
      child: Column(
        children: [
          ToggleButtons(
            isSelected: [selectedSection == 0, selectedSection == 1],
            onPressed: (int section) {
              setState(() {
                selectedSection = section;
                nameController.clear();
                imageUrlController.clear();
              });
            },
            color: Colors.black,
            selectedColor: Colors.white,
            fillColor: Color(0xFF5B59B4),
            borderColor: Color(0xFF5B59B4),
            selectedBorderColor: Color(0xFF5B59B4),
            borderRadius: BorderRadius.circular(20),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 1.0),
                child: Center(
                  child: Text('Sport')
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 1.0),
                child: Center(
                  child: Text('Culture')
                ),
              ),
            ],  
          ),
          const SizedBox(height: 16),
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
          const SizedBox(height: 16),
          if (imageUrlController.text.isNotEmpty)
            Container(
              height: 220,
              width: 220,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrlController.text),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: TextFormField(
              controller: imageUrlController,
              decoration: InputDecoration(
                labelText: 'Url de la nouvelle image',
                hintText: 'Entrez l\'url de l\'image',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un url valide';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Nom du nouveau sous-filtre',
                hintText: 'Entrez le nom du sous-filtre',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer le nom du sous-filtre';
                }
                if (isNameDuplicated(value)) {
                  return 'Un sous-filtre existe déjà avec ce nom';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF5B59B4),
              foregroundColor: Colors.white,
              side: BorderSide(color: Color(0xFF5B59B4)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            onPressed: () {
              if (_addSubFilterKey.currentState!.validate()) {
                createSubFilter();
                readSubFilters();
                nameController.clear();
                imageUrlController.clear();
              }
            },
            child: Text('Ajouter un nouveau sous-filtre'),
          ),
        ],
      ),
    );
  }

  Widget _buildEditSubFilter(BuildContext context) {
    return Form(
      key: _editSubFilterKey,
      child: Column(
        children: [
          ToggleButtons(
            isSelected: [selectedSection == 0, selectedSection == 1],
            onPressed: (int section) {
              setState(() {
                selectedSection = section;
                selectedSubFilterIdForEditing = '';
                newNameController.clear();
                newImageUrlController.clear();
              });
            },
            color: Colors.black,
            selectedColor: Colors.white,
            fillColor: Color(0xFF5B59B4),
            borderColor: Color(0xFF5B59B4),
            selectedBorderColor: Color(0xFF5B59B4),
            borderRadius: BorderRadius.circular(20),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 1.0),
                child: Center(
                  child: Text('Sport')
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 1.0),
                child: Center(
                  child: Text('Culture')
                ),
              ),
            ],  
          ),
          const SizedBox(height: 16),
          DropdownButton<String>(
            value: selectedFilter,
            onChanged: (String? newValue) {
              setState(() {
                selectedFilter = newValue!;
                newNameController.clear();
                newImageUrlController.clear();
                selectedSubFilterIdForEditing = '';
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
          const SizedBox(height: 16),
          DropdownButton<String>(
            value: selectedSubFilterIdForEditing.isEmpty && subFilters.isNotEmpty ? subFilters[0].id : selectedSubFilterIdForEditing,
            onChanged: (String? newValue) {
              setState(() {
                selectedSubFilterIdForEditing = newValue!;
                var selectedSubFilter = subFilters.firstWhere((subFilter) => subFilter.id == newValue);
                if (selectedSubFilter != null) {
                  newNameController.text = selectedSubFilter.name;
                  newImageUrlController.text = selectedSubFilter.imageUrl; 
                  selectedSubFilterId = selectedSubFilter.id;
                }
              });
              debugPrint('DebugPrint1 : $selectedSubFilterIdForEditing');
              debugPrint('DebugPrint2 : $newValue');
            },
            items: subFilters.map((subFilter) {
              return DropdownMenuItem<String>(
                value: subFilter.id,
                child: Text(subFilter.name),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          if (newImageUrlController.text.isEmpty && selectedSubFilterIdForEditing.isNotEmpty)
            Container(
              height: 220,
              width: 220,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    subFilters.firstWhere((subFilter) => subFilter.id == selectedSubFilterIdForEditing).imageUrl
                  ),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          if (newImageUrlController.text.isNotEmpty)
            Container(
              height: 220,
              width: 220,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(newImageUrlController.text),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          const SizedBox(height: 16),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child:TextFormField(
              controller: newImageUrlController,
              decoration: InputDecoration(
                labelText: 'Url de la nouvelle image',
                hintText: 'Entrez l\'url de l\'image',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Entrez un url valide';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child:TextFormField(
              controller: newNameController,
              decoration: InputDecoration(
                labelText: 'Nouveau nom du sous-filtre',
                hintText: 'Entrez un nouveau nom',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Entrez un nom valide';
                }
                if (isNameDuplicated(value)) {
                  return 'Un sous-filtre existe déjà avec ce nom';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF5B59B4),
              foregroundColor: Colors.white,
              side: BorderSide(color: Color(0xFF5B59B4)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            onPressed: () {
              if (_editSubFilterKey.currentState!.validate()) {
                updateSubFilter();
                readSubFilters();
                selectedSubFilterIdForEditing = '';
                newNameController.clear();
                newImageUrlController.clear();
              }
            },
            child: Text('Enregistrer les modifications'),
          ),  
        ],
      ),
    );
  }

  Widget _buildDeleteSubFilter(BuildContext context) {
    return Form(
      key: _deleteSubFilterKey,
      child: Column(
        children: [
          ToggleButtons(
            isSelected: [selectedSection == 0, selectedSection == 1],
            onPressed: (int section) {
              setState(() {
                selectedSection = section;
                selectedSubFilterIdForDeleting = '';
              });
            },
            color: Colors.black,
            selectedColor: Colors.white,
            fillColor: Color(0xFF5B59B4),
            borderColor: Color(0xFF5B59B4),
            selectedBorderColor: Color(0xFF5B59B4),
            borderRadius: BorderRadius.circular(20),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 1.0),
                child: Center(
                  child: Text('Sport')
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 1.0),
                child: Center(
                  child: Text('Culture')
                ),
              ),
            ],  
          ),
          const SizedBox(height: 16),
          DropdownButton<String>(
            value: selectedFilter,
            onChanged: (String? newValue) {
              setState(() {
                selectedFilter = newValue!;
                selectedSubFilterIdForDeleting = '';
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
          const SizedBox(height: 16),
          DropdownButton<String>(
            value: selectedSubFilterIdForDeleting.isEmpty && subFilters.isNotEmpty ? subFilters[0].id : selectedSubFilterIdForDeleting,
            onChanged: (String? newValue) {
              setState(() {
                selectedSubFilterIdForDeleting = newValue!;
                var selectedSubFilter = subFilters.firstWhere((subFilter) => subFilter.id == newValue);
                if (selectedSubFilter != null) {
                  imageUrl = selectedSubFilter.imageUrl;
                  selectedSubFilterId = selectedSubFilter.id;
                }
              });
              debugPrint('DebugPrint 1: $selectedSubFilterId');
            },
            items: subFilters.map((subFilter) {
              return DropdownMenuItem<String>(
                value: subFilter.id,
                child: Text(subFilter.name),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          if (selectedSubFilterIdForDeleting.isNotEmpty)
            Container(
              height: 220,
              width: 220,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    subFilters.firstWhere((subFilter) => subFilter.id == selectedSubFilterIdForDeleting).imageUrl
                  ),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          const SizedBox(height: 16),
          if (selectedSubFilterIdForDeleting.isNotEmpty)
            Text('Nom du sous-filtre: ${subFilters.firstWhere((subFilter) => subFilter.id == selectedSubFilterIdForDeleting).name}'),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF5B59B4),
              foregroundColor: Colors.white,
              side: BorderSide(color: Color(0xFF5B59B4)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            onPressed: () {
              deleteSubFilter();
              readSubFilters();
              selectedSubFilterIdForDeleting = '';
            },
            child: Text('Supprimer le sous-filtre'),
          ),
        ],
      ),
    );
  }
}