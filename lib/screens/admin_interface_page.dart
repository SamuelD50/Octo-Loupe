import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:octoloupe/components/custom_app_bar.dart';
import 'package:octoloupe/components/snackbar.dart';
import 'package:octoloupe/services/sport_filter_service.dart';
import 'package:octoloupe/services/culture_filter_service.dart';

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
  
  Future<void> createSubFilter({
    required BuildContext context
  }) async {
    String name = nameController.text.trim();
    String imageUrl = imageUrlController.text.trim();
    
    try {
      setState(() {
        isLoading = true;
      });

      if (selectedSection == 0) {
        if (selectedFilter == 'Par catégorie') {
          await SportFilterService().addSportCategory(
            null,
            name,
            imageUrl
          );
        } else if (selectedFilter == 'Par âge') {
          await SportFilterService().addSportAge(
            null,
            name,
            imageUrl
          );
        } else if (selectedFilter == 'Par jour') {
          await SportFilterService().addSportDay(
            null,
            name,
            imageUrl
          );
        } else if (selectedFilter == 'Par horaire') {
          await SportFilterService().addSportSchedule(
            null,
            name,
            imageUrl
          );
        } else if (selectedFilter == 'Par secteur') {
          await SportFilterService().addSportSector(
            null,
            name,
            imageUrl
          );
        }
      } else {
        if (selectedFilter == 'Par catégorie') {
          await CultureFilterService().addCultureCategory(
            null,
            name,
            imageUrl
          );
        } else if (selectedFilter == 'Par âge') {
          await CultureFilterService().addCultureAge(
            null,
            name,
            imageUrl
          );
        } else if (selectedFilter == 'Par jour') {
          await CultureFilterService().addCultureDay(
            null,
            name,
            imageUrl
          );
        } else if (selectedFilter == 'Par horaire') {
          await CultureFilterService().addCultureSchedule(
            null,
            name,
            imageUrl
          );
        } else if (selectedFilter == 'Par secteur') {
          await CultureFilterService().addCultureSector(
            null,
            name,
            imageUrl
          );
        }
      }

      await Future.delayed(Duration(milliseconds: 25));

      setState(() {
        isLoading = false;
      });

      if (context.mounted) {
        CustomSnackBar(
          message: 'Filtre créé',
          backgroundColor: Colors.green,
        ).showSnackBar(context);
      }
    } catch (e) {
      debugPrint('Error creating sub-filter: $e');

      setState(() {
        isLoading = false;
      });

      if (context.mounted) {
        CustomSnackBar(
          message: 'Echec de la création du filtre',
          backgroundColor: Colors.red,
        ).showSnackBar(context);
      }
    }
  }

  Future<void> readSubFilters() async {
    try {
      setState(() {
        isLoading = true;
      });

      if (selectedSection == 0) {
        if (selectedFilter == 'Par catégorie') {
          subFilters = await SportFilterService().getSportCategories();
          debugPrint(subFilters.toString());
        } else if (selectedFilter == 'Par âge') {
          subFilters = await SportFilterService().getSportAges();
          debugPrint(subFilters.toString());
        } else if (selectedFilter == 'Par jour') {
          subFilters = await SportFilterService().getSportDays();
        } else if (selectedFilter == 'Par horaire') {
          subFilters = await SportFilterService().getSportSchedules();
        } else if (selectedFilter == 'Par secteur') {
          subFilters = await SportFilterService().getSportSectors();
        }
      } else {
        if (selectedFilter == 'Par catégorie') {
          subFilters = await CultureFilterService().getCultureCategories();
        } else if (selectedFilter == 'Par âge') {
          subFilters = await CultureFilterService().getCultureAges();
        } else if (selectedFilter == 'Par jour') {
          subFilters = await CultureFilterService().getCultureDays();
        } else if (selectedFilter == 'Par horaire') {
          subFilters = await CultureFilterService().getCultureSchedules();
        } else if (selectedFilter == 'Par secteur') {
          subFilters = await CultureFilterService().getCultureSectors();
        }
      }

      if (!subFilters.any(
        (subFilter) => subFilter.id == selectedSubFilterIdForDeleting)
      ) {
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

  Future<void> updateSubFilter({
    required BuildContext context
  }) async {
    
    String newName = newNameController.text.trim();
    String newImageUrl = newImageUrlController.text.trim();
    
    try {
      setState(() {
        isLoading = true;
      });

      if (selectedSection == 0) {
        if (selectedFilter == 'Par catégorie') {
          await SportFilterService().updateSportCategory(
            selectedSubFilterId,
            newName,
            newImageUrl
          );
        } else if (selectedFilter == 'Par âge') {
          await SportFilterService().updateSportAge(
            selectedSubFilterId,
            newName,
            newImageUrl
          );
        } else if (selectedFilter == 'Par jour') {
          await SportFilterService().updateSportDay(
            selectedSubFilterId,
            newName,
            newImageUrl
          );
        } else if (selectedFilter == 'Par horaire') {
          await SportFilterService().updateSportSchedule(
            selectedSubFilterId,
            newName,
            newImageUrl
          );
        } else if (selectedFilter == 'Par secteur') {
          await SportFilterService().updateSportSector(
            selectedSubFilterId,
            newName,
            newImageUrl
          );
        }
      } else {
        if (selectedFilter == 'Par catégorie') {
          await CultureFilterService().updateCultureCategory(
            selectedSubFilterId,
            newName,
            newImageUrl
          );
        } else if (selectedFilter == 'Par âge') {
          await CultureFilterService().updateCultureAge(
            selectedSubFilterId,
            newName,
            newImageUrl
          );
        } else if (selectedFilter == 'Par jour') {
          await CultureFilterService().updateCultureDay(
            selectedSubFilterId,
            newName,
            newImageUrl
          );
        } else if (selectedFilter == 'Par horaire') {
          await CultureFilterService().updateCultureSchedule(
            selectedSubFilterId,
            newName,
            newImageUrl
          );
        } else if (selectedFilter == 'Par secteur') {
          await CultureFilterService().updateCultureSector(
            selectedSubFilterId,
            newName,
            newImageUrl
          );
        }
      }

      await Future.delayed(Duration(milliseconds: 25));

      setState(() {
        isLoading = false;
      });

      if (context.mounted) {
        CustomSnackBar(
          message: 'Filtre mis à jour',
          backgroundColor: Colors.green,
        ).showSnackBar(context);
      }
    } catch (e) {
      debugPrint('Error updating sub-filter: $e');

      setState(() {
        isLoading = false;
      });

      if (context.mounted) {
        CustomSnackBar(
          message: 'Echec de la mise à jour du filtre',
          backgroundColor: Colors.red,
        ).showSnackBar(context);
      }
    }
  }

  Future<void> deleteSubFilter({
    required BuildContext context
  }) async {
    try {
      setState(() {
        isLoading = true;
      });

      if (selectedSection == 0) {
        if (selectedFilter == 'Par catégorie') {
          await SportFilterService().deleteSportCategory(
            selectedSubFilterId
          );
        } else if (selectedFilter == 'Par âge') {
          await SportFilterService().deleteSportAge(
            selectedSubFilterId
          );
        } else if (selectedFilter == 'Par jour') {
          await SportFilterService().deleteSportDay(
            selectedSubFilterId
          );
        } else if (selectedFilter == 'Par horaire') {
          await SportFilterService().deleteSportSchedule(
            selectedSubFilterId
          );
        } else if (selectedFilter == 'Par secteur') {
          await SportFilterService().deleteSportSector(
            selectedSubFilterId
          );
        }
      } else {
        if (selectedFilter == 'Par catégorie') {
          await CultureFilterService().deleteCultureCategory(
            selectedSubFilterId
          );
        } else if (selectedFilter == 'Par âge') {
          await CultureFilterService().deleteCultureAge(
            selectedSubFilterId
          );
        } else if (selectedFilter == 'Par jour') {
          await CultureFilterService().deleteCultureDay(
            selectedSubFilterId
          );
        } else if (selectedFilter == 'Par horaire') {
          await CultureFilterService().deleteCultureSchedule(
            selectedSubFilterId
          );
        } else if (selectedFilter == 'Par secteur') {
          await CultureFilterService().deleteCultureSector(
            selectedSubFilterId
          );
        }
      }

      await Future.delayed(Duration(milliseconds: 25));

      setState(() {
        isLoading = false;
      });

      if (context.mounted) {
        CustomSnackBar(
          message: 'Filtre supprimé',
          backgroundColor: Colors.green,
        ).showSnackBar(context);
      }
    } catch (e) {
      debugPrint('Error deleting sub-filter: $e');

      setState(() {
        isLoading = false;
      });

      if (context.mounted) {
        CustomSnackBar(
          message: 'Echec de la suppression du filtre',
          backgroundColor: Colors.red,
        ).showSnackBar(context);
      }
    }
  }

  bool isNameDuplicated(String name) {
    return subFilters.any(
      (subFilter) => subFilter.name.toLowerCase() == name.toLowerCase() &&
      subFilter.id != selectedSubFilterIdForEditing,
    );
  }

  List<dynamic> sortSubFilters(
    List<dynamic> subFilters,
    String selectedFilter
  ) {
    switch (selectedFilter) {
      case 'Par catégorie':
        subFilters.sort(
          (a,b) => a.name.compareTo(b.name)
        );
        break;

      case 'Par âge':
        subFilters.sort(
          (a, b) {
            int minAgeA = _getMinAgeFromAgeRange(a.name);
            int minAgeB = _getMinAgeFromAgeRange(b.name);
            return minAgeA.compareTo(minAgeB);
          }
        );
        break;

      case 'Par horaire':
        subFilters.sort(
          (a, b) {
            int startTimeA = _getStartTimeFromSchedule(a.name);
            int startTimeB = _getStartTimeFromSchedule(b.name);
            return startTimeA.compareTo(startTimeB);
          }
        );
        break;

      case 'Par jour':
        subFilters.sort(
          (a, b) {
            return _getDayIndex(a.name).compareTo(_getDayIndex(b.name));
          }
        );
        break;

      case 'Par secteur':
      subFilters.sort(
        (a, b) => a.name.compareTo(b.name)
      );
      break;

      default:
        subFilters.sort(
          (a, b) => a.name.compareTo(b.name)
        );
    }

    return subFilters;
  }

  int _getMinAgeFromAgeRange(String ageRange) {
    RegExp regExp = RegExp(
      r'(\d+)(?=[\s\-])'
    );
    Match? match = regExp.firstMatch(ageRange);
    if (match != null) {
      return int.parse(match.group(1)!);
    }
    return 99;
  }

  int _getStartTimeFromSchedule(String schedule) {
    RegExp regExp = RegExp(
      r'(\d+)h'
    );
    Match? match = regExp.firstMatch(schedule);
    if (match != null) {
      return int.parse(match.group(1)!);
    }
    return 99;
  }

  int _getDayIndex(String day) {
    Map<String, int> dayOrder = {
      'Lundi': 0,
      'Mardi': 1,
      'Mercredi': 2,
      'Jeudi': 3,
      'Vendredi': 4,
      'Samedi': 5,
      'Dimanche': 6,
    };

    return dayOrder[day] ?? 99;
  }


  @override
  void initState() {
    super.initState();
    selectedFilter = "Par catégorie";
    subFilters = [];
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
                  Padding(
                    padding: EdgeInsets.only(top: 32),
                    child: Text(
                      'Gérer l\'interface de l\'application',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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
                            selectedFilter = 'Par catégorie';
                            subFilters = [];
                            readSubFilters();
                          });
                        },
                        child: Icon(Icons.add, size: 30, color: Colors.white),
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
                            selectedFilter = 'Par catégorie';
                            subFilters = [];
                            readSubFilters();
                          });
                        },
                        child: Icon(Icons.edit, size: 30, color: Colors.white),
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
                            selectedFilter = 'Par catégorie';
                            subFilters = [];
                            readSubFilters();
                          });
                        },
                        child: Icon(Icons.remove, size: 30, color: Colors.white),
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

  Widget _buildAddSubFilter(
    BuildContext context
  ) {
    return Form(
      key: _addSubFilterKey,
      child: Column(
        children: [
          ToggleButtons(
            isSelected: [selectedSection == 0, selectedSection == 1],
            onPressed: (int section) {
              setState(() {
                selectedSection = section;
                selectedFilter = 'Par catégorie';
                subFilters = [];
                nameController.clear();
                imageUrlController.clear();
                readSubFilters();
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
                subFilters = [];
                readSubFilters();
              });
            },
            items: [
              'Par catégorie',
              'Par âge',
              'Par jour',
              'Par horaire',
              'Par secteur'
            ]
            .map((String filter) {
              return DropdownMenuItem<String>(
                value: filter,
                child: Text(filter),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          if (imageUrlController.text.isNotEmpty)
            isLoading ?
              Center(
                child: SpinKitSpinningLines(
                  color: Colors.white,
                  size: 60,
                ),
              )
            : Container(
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
                hintText: 'Ex: https://www.example.com/image.jpg',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer une image url';
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
                hintText: 'Ex: Running',
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
                createSubFilter(
                  context: context,
                );
                selectedFilter = "Par catégorie";
                subFilters = [];
                nameController.clear();
                imageUrlController.clear();
                readSubFilters();
              }
            },
            child: Text('Ajouter le sous-filtre'),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildEditSubFilter(
    BuildContext context
  ) {
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
                selectedFilter = 'Par catégorie';
                subFilters = [];
                newNameController.clear();
                newImageUrlController.clear();
                readSubFilters();
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
                subFilters = [];
                readSubFilters();
              });
            },
            items: [
              'Par catégorie',
              'Par âge',
              'Par jour',
              'Par horaire',
              'Par secteur'
            ]
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
                var selectedSubFilter = subFilters.firstWhere(
                  (subFilter) => subFilter.id == newValue
                );
                if (selectedSubFilter != null) {
                  newNameController.text = selectedSubFilter.name;
                  newImageUrlController.text = selectedSubFilter.imageUrl; 
                  selectedSubFilterId = selectedSubFilter.id;
                }
              });
            },
            items: sortSubFilters(
              subFilters, selectedFilter
            ).map((subFilter) {
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
            isLoading ?
              Center(
                child: SpinKitSpinningLines(
                  color: Colors.white,
                  size: 60,
                ),
              )
            : Container(
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
                hintText: 'Ex: https://www.example.com/image.jpg',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer une image url';
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
                hintText: 'Ex: Running',
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
                updateSubFilter(
                  context: context,
                );
                selectedSubFilterIdForEditing = '';
                selectedFilter = 'Par catégorie';
                subFilters = [];
                newNameController.clear();
                newImageUrlController.clear();
                readSubFilters();
              }
            },
            child: Text('Modifier le sous-filtre'),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 32),
          ), 
        ],
      ),
    );
  }

  Widget _buildDeleteSubFilter(
    BuildContext context
  ) {
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
                selectedFilter = 'Par catégorie';
                subFilters = [];
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
                subFilters = [];
                readSubFilters();
              });
            },
            items: [
              'Par catégorie',
              'Par âge',
              'Par jour',
              'Par horaire',
              'Par secteur'
            ]
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
                var selectedSubFilter = subFilters.firstWhere(
                  (subFilter) => subFilter.id == newValue
                );
                if (selectedSubFilter != null) {
                  imageUrl = selectedSubFilter.imageUrl;
                  selectedSubFilterId = selectedSubFilter.id;
                }
              });
              debugPrint('DebugPrint 1: $selectedSubFilterId');
            },
            items: sortSubFilters(
              subFilters, selectedFilter
            ).map((subFilter) {
              return DropdownMenuItem<String>(
                value: subFilter.id,
                child: Text(subFilter.name),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          if (selectedSubFilterIdForDeleting.isNotEmpty)
            isLoading ?
              Center(
                child: SpinKitSpinningLines(
                  color: Colors.white,
                  size: 60,
                ),
              )
            : Container(
              height: 220,
              width: 220,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    subFilters.firstWhere(
                      (subFilter) => subFilter.id == selectedSubFilterIdForDeleting
                    ).imageUrl
                  ),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          const SizedBox(height: 16),
          if (selectedSubFilterIdForDeleting.isNotEmpty)
            Text('Nom du sous-filtre: ${subFilters.firstWhere(
              (subFilter) => subFilter.id == selectedSubFilterIdForDeleting
            ).name}'),
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
              deleteSubFilter(
                context: context,
              );
              selectedSubFilterIdForDeleting = '';
              selectedFilter = 'Par catégorie';
              subFilters = [];
              readSubFilters();
            },
            child: Text('Supprimer le sous-filtre'),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 32),
          ),
        ],
      ),
    );
  }
}