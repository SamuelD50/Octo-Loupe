import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:octoloupe/CRUD/user_crud.dart';
import 'package:octoloupe/components/snackbar.dart';
import 'package:octoloupe/model/activity_model.dart';
import 'package:octoloupe/model/culture_filters_model.dart';
import 'package:octoloupe/model/sport_filters_model.dart';
import 'package:octoloupe/model/topic_model.dart';
import 'package:octoloupe/model/user_model.dart';

class UserNotificationsPage extends StatefulWidget {
  const UserNotificationsPage({super.key});

  @override
  UserNotificationsPageState createState() => UserNotificationsPageState();
}

class UserNotificationsPageState extends State<UserNotificationsPage> {

  List<SportCategory> selectedSportCategories = [];
  List<SportSector> selectedSportSectors = [];

  List<CultureCategory> selectedCultureCategories = [];
  List<CultureSector> selectedCultureSectors = [];

  int _selectedSection = 0;
  List<TopicModel>? topicsSport = [];
  List<TopicModel>? topicsCulture = [];
  UserModel? user;

  void _resetFilters() {
    setState(() {
      if (_selectedSection == 0) {
        selectedSportCategories = [];
        selectedSportSectors = [];
      } else {
        selectedCultureCategories = [];
        selectedCultureSectors = [];
      }
    });
  }

  Map<String, List<Map<String, String>>> filters = {};

  // Collect filters to search for matching activities
  void collectFilters() {
    filters.clear();
    
    if (_selectedSection == 0) {
      if (selectedSportCategories.isNotEmpty) {
        filters['categories'] = selectedSportCategories.map(
          (e) => {
            'id': e.id!,
            'name': e.name
          }
        ).toList();
      }
      if (selectedSportSectors.isNotEmpty) {
        filters['sectors'] = selectedSportSectors.map(
          (e) => {
            'id': e.id!,
            'name': e.name
          }
        ).toList();
      }
    } else {
      if (selectedCultureCategories.isNotEmpty) {
        filters['categories'] = selectedCultureCategories.map(
          (e) => {
            'id': e.id!,
            'name': e.name
          }
        ).toList();
      }
      if (selectedCultureSectors.isNotEmpty) {
        filters['sectors'] = selectedCultureSectors.map(
          (e) => {
            'id': e.id!,
            'name': e.name
          }
        ).toList();
      }
    }
  }
  
  void applyFilters() {
    setState(() {
      if (user?.topicsSport != null) {
        for (final topicSport in user!.topicsSport!) {
          for (final topicCategory in topicSport.topicCategories) {
            if (!selectedSportCategories.any(
              (category) => category.id == topicCategory.id)
            ) {
              selectedSportCategories.add(
                SportCategory(
                  id: topicCategory.id,
                  name: topicCategory.name,
                  imageUrl: '',
                )
              );
              debugPrint('TopicCategory L120: id=${topicCategory.id} name=${topicCategory.name}');
            }
          }

          debugPrint('SelectedSportCategories L124: ${selectedSportCategories[0].name}');

          for (final topicSector in topicSport.topicSectors) {
            if (!selectedSportSectors.any(
              (sector) => sector.id == topicSector.id)
            ) {
              selectedSportSectors.add(
                SportSector(
                  id: topicSector.id,
                  name: topicSector.name,
                  imageUrl: '',
                )
              );
            }
          }
        }
      }

      if (user?.topicsCulture != null) {
        for (final topicCulture in user!.topicsCulture!) {
          for (final topicCategory in topicCulture.topicCategories) {
            if (!selectedCultureCategories.any(
              (category) => category.id == topicCategory.id)
            ) {
              selectedCultureCategories.add(
                CultureCategory(
                  id: topicCategory.id,
                  name: topicCategory.name,
                  imageUrl: '',
                )
              );
            }
          }

          for (final topicSector in topicCulture.topicSectors) {
            if (!selectedCultureSectors.any(
              (sector) => sector.id == topicSector.id)
            ) {
              selectedCultureSectors.add(
                CultureSector(
                  id: topicSector.id,
                  name: topicSector.name,
                  imageUrl: '',
                )
              );
            }
          }
        }
      }
    });
  }

  Future<void> _loadCurrentUser() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final userData = await UserCRUD().getUser(uid);

    if (userData != null) {
      setState(() {
        user = userData;
        topicsSport = user!.topicsSport;
        topicsCulture = user!.topicsCulture;
      });

      applyFilters();
    } else {
      CustomSnackBar(
        backgroundColor: Colors.red,
        message: 'Aucun utilisateur trouvé',
      );
    }
  }

  List<String> _generateTopicNames(
    List<TopicCategory> topicCategories,
    List<TopicSector> topicSectors,
  ) {
    final List<String> result = [];

    for (final topicCategory in topicCategories) {  
      for (final topicSector in topicSectors) {
        final categoryName = topicCategory.name
          .toLowerCase()
          .replaceAll(RegExp(r'[^a-zA-Z0-9\-_.~%]'), '-');

        final sectorName = topicSector.name
          .toLowerCase()
          .replaceAll(RegExp(r'[^a-zA-Z0-9\-_.~%]'), '-');

        result.add('${categoryName}_${sectorName}');
      }
    }
    return result;
  }

  /* bool compareSelectedTopicsToDatabaseTopics(
    List<TopicCategory> topicCategories,
    List<TopicSector> topicSectors,
    TopicModel databaseTopics,  
  ) {
    final selectedCategoryIds = topicCategories.map(
      (selectedCategoryId) => selectedCategoryId.id)
      .toSet();

    final databaseCategoryIds = databaseTopics.topicCategories.map(
      (databaseCategoryId) => databaseCategoryId.id)
      .toSet();

    final selectedSectorsIds = topicSectors.map(
      (selectedSectorId) => selectedSectorId.id)
      .toSet();
    final databaseSectorIds = databaseTopics.topicSectors.map(
      (databaseSectorId) => databaseSectorId.id)
      .toSet();

    return selectedCategoryIds.length == databaseCategoryIds.length &&
      selectedCategoryIds.containsAll(databaseCategoryIds) &&
      selectedSectorsIds.length == databaseSectorIds.length &&
      selectedSectorsIds.containsAll(databaseSectorIds);
  } */

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  @override
  Widget build(
    BuildContext context
  ) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white24,
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
                    'Notifications par centres d\'intérêt',
                    style: TextStyle(
                      fontFamily: 'Satisfy-Regular',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 32),
                LayoutBuilder(
                  builder: (context, constraints) {
                    EdgeInsetsGeometry padding;

                    if (constraints.maxWidth < 325) {
                      padding = EdgeInsets.symmetric(horizontal: 30.0, vertical: 1.0);
                    } else {
                      padding = EdgeInsets.symmetric(horizontal: 30.0, vertical: 1.0);
                    }

                    return ToggleButtons(
                      isSelected: [_selectedSection == 0, _selectedSection == 1],
                      onPressed: (int section) {
                        setState(() {
                          _selectedSection = section;
                          _resetFilters();
                          applyFilters();
                        });
                      },
                      color: Colors.black,
                      selectedColor: Colors.white,
                      fillColor: Color(0xFF5B59B4),
                      borderColor: Color(0xFF5B59B4),
                      selectedBorderColor: Color(0xFF5B59B4),
                      borderRadius: BorderRadius.circular(30.0),
                      direction: constraints.maxWidth < 325 ?
                        Axis.vertical
                        : Axis.horizontal,
                      children: [
                        Container(
                          padding: padding,
                          child: Center(
                            child: Text(
                              'Sport',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: padding,
                          child: Center(
                            child: Text(
                              'Culture',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    children: [
                    //Filter button by categories
                      _buildCriteriaTile(
                        context,
                        Icons.category,
                        'Par catégorie',
                        () async {
                          final List<Map<String, String>>? selectedCategories = await context.push(
                            '/home/categories',
                            extra: {
                              'isSport': _selectedSection == 0,
                              'selectedCategories': _selectedSection == 0 ?
                                selectedSportCategories.map((category) => {
                                  'id': category.id ?? '',
                                  'name': category.name,
                                }).toList()
                                : selectedCultureCategories.map((category) => {
                                  'id': category.id ?? '',
                                  'name': category.name,
                                }).toList(),
                            }
                          );

                          setState(() {
                            if (selectedCategories != null) {
                              if (_selectedSection == 0) {
                                selectedSportCategories = selectedCategories
                                  .map((category) => SportCategory.fromMap(category))
                                  .toList();
                              } else {
                                selectedCultureCategories = selectedCategories
                                  .map((category) => CultureCategory.fromMap(category))
                                  .toList();
                              }
                            }
                          });
                        },
                        isSport: _selectedSection == 0,
                      ),
                      //Filter button by sectors
                      _buildCriteriaTile(
                        context,
                        Icons.apartment_rounded,
                        'Par secteur',
                        () async {
                          final List<Map<String, String>>? selectedSectors = await context.push(
                            '/home/sectors',
                            extra: {
                              'isSport': _selectedSection == 0,
                              'selectedSectors': _selectedSection == 0 ?
                                selectedSportSectors.map((sector) => {
                                  'id': sector.id ?? '',
                                  'name': sector.name,
                                }).toList()
                                : selectedCultureSectors.map((sector) => {
                                  'id': sector.id ?? '',
                                  'name': sector.name,
                                }).toList(),
                            }
                          );
                            
                          setState(() {
                            if (selectedSectors != null) {
                              if (_selectedSection == 0) {
                                selectedSportSectors = selectedSectors
                                  .map((sector) => SportSector.fromMap(sector))
                                  .toList();
                              } else {
                                selectedCultureSectors = selectedSectors
                                  .map((sector) => CultureSector.fromMap(sector))
                                  .toList();
                              }
                            }
                          });
                        },
                        isSport: _selectedSection == 0,
                      ),
                    ],
                  ),
                ),
                //Buttons to search for activities or reset filters (Row/Column)
                LayoutBuilder(
                  builder: (context, constraints) {
                    return constraints.maxWidth > 325 ?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF5B59B4),
                              foregroundColor: Colors.white,
                              side: BorderSide(color: Color(0xFF5B59B4)),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            onPressed: () async {
                              collectFilters();

                              final topicCategories = (filters['categories'] as List?)
                                ?.map((e) => TopicCategory.fromMap(e as Map<String, dynamic>))
                                .toList();

                              final hasCategories = topicCategories != null && topicCategories.isNotEmpty;

                              final topicSectors = (filters['sectors'] as List?)
                                ?.map((e) => TopicSector.fromMap(e as Map<String, dynamic>))
                                .toList();

                              final hasSectors = topicSectors != null && topicSectors.isNotEmpty;

                              final newTopicNames = (hasCategories && hasSectors) ?
                                _generateTopicNames(topicCategories, topicSectors) : null;

                              TopicModel? interests;
                              if (hasCategories && hasSectors) {
                                interests = TopicModel(
                                  topicCategories: topicCategories,
                                  topicSectors: topicSectors,
                                  topicNames: newTopicNames,
                                );
                              }
                              
                              setState(() {
                                if (_selectedSection == 0) {
                                  topicsSport = interests != null ? [interests] : null;
                                } else {
                                  topicsCulture = interests != null ? [interests] : null;
                                }
                              });

                              final fcmToken = await FirebaseMessaging.instance.getToken();

                              final oldTopicNames = _selectedSection == 0
                                ? user?.topicsSport?.expand((t) => t.topicNames ?? []).toList() ?? []
                                : user?.topicsCulture?.expand((t) => t.topicNames ?? []).toList() ?? [];

                              debugPrint('OldTopicNames: ${oldTopicNames.toString()}');

                              for (final oldTopic in oldTopicNames) {
                                await FirebaseMessaging.instance.unsubscribeFromTopic(oldTopic);
                                debugPrint('Désabonné de $oldTopic');
                              }

                              if (newTopicNames != null && newTopicNames.isNotEmpty) {
                                for (final newTopicName in newTopicNames) {
                                  await FirebaseMessaging.instance.subscribeToTopic(newTopicName);
                                  debugPrint('Abonné à $newTopicName');
                                }
                              }

                              final updatedUser = UserModel(
                                uid: user!.uid,
                                email: user!.email,
                                firstName: user!.firstName,
                                name: user!.name,
                                role: user!.role,
                                fcmToken: fcmToken,
                                topicsSport: _selectedSection == 0 ? topicsSport : null,
                                topicsCulture: _selectedSection == 1 ? topicsCulture : null,
                              );

                              try {
                                UserCRUD userCRUD = UserCRUD();
                                await userCRUD.updateUser(user!.uid, updatedUser);
                                CustomSnackBar(
                                  message: 'Centres d\'intérêt mis à jour',
                                  backgroundColor: Colors.green,
                                ).showSnackBar(context);
                              } catch (e) {
                                CustomSnackBar(
                                  message: 'Erreur lors de la mise à jour des centres d\'intérêt',
                                  backgroundColor: Colors.red,
                                ).showSnackBar(context);
                              }
                            },
                            child: Text('S\'abonner',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 32),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF5B59B4),
                              foregroundColor: Colors.white,
                              side: BorderSide(color: Color(0xFF5B59B4)),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            onPressed: () {
                              _resetFilters();
                              CustomSnackBar(
                                message: 'Filtres réinitialisés !',
                                backgroundColor: Colors.amber,
                              ).showSnackBar(context);
                            },
                            child: Text('Réinitialiser',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ) :
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF5B59B4),
                              foregroundColor: Colors.white,
                              side: BorderSide(color: Color(0xFF5B59B4)),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            onPressed: () async {
                              collectFilters();

                              final topicCategories = (filters['categories'] as List)
                                .map((e) => TopicCategory.fromMap(e as Map<String, String>))
                                .toList();

                              final topicSectors = (filters['sectors'] as List)
                                .map((e) => TopicSector.fromMap(e as Map<String, String>))
                                .toList();

                              final topicNames = _generateTopicNames(topicCategories, topicSectors);

                              final interests = TopicModel(
                                topicCategories: topicCategories,
                                topicSectors: topicSectors,
                                topicNames: topicNames,
                              );


                              setState(() {
                                if (_selectedSection == 0) {
                                  topicsSport = [interests];
                                } else {
                                  topicsCulture = [interests];
                                }
                              });

                              final fcmToken = await FirebaseMessaging.instance.getToken();

                              final updatedUser = UserModel(
                                uid: user!.uid,
                                email: user!.email,
                                firstName: user!.firstName,
                                name: user!.name,
                                role: user!.role,
                                fcmToken: fcmToken,
                                topicsSport: _selectedSection == 0 ? topicsSport : null,
                                topicsCulture: _selectedSection == 1 ? topicsCulture : null,
                              );

                              try {
                                UserCRUD userCRUD = UserCRUD();
                                await userCRUD.updateUser(user!.uid, updatedUser);
                                debugPrint("User updated successfully");
                              } catch (e) {
                                debugPrint('Error updating user');
                              }
                            },
                            child: Text('S\'abonner',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF5B59B4),
                              foregroundColor: Colors.white,
                              side: BorderSide(color: Color(0xFF5B59B4)),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            onPressed: () {
                              _resetFilters();
                              CustomSnackBar(
                                message: 'Filtres réinitialisés !',
                                backgroundColor: Colors.amber,
                              ).showSnackBar(context);
                            },
                            child: Text('Réinitialiser',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      );
                  }
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                ),
              ],
            ),
          )
        )
      ],
    );
  }

  //Widget buttons to filters
  Widget _buildCriteriaTile(
    BuildContext context,
    IconData icon,
    String label,
    Future<void> Function() pageBuilder,
    {required bool isSport}
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: BorderSide(
                color: Color(0xFF5B59B4),
                width: 2,
              )
            ),
            padding: EdgeInsets.zero,
          ),
          onPressed: () {
            pageBuilder();
          },
          child: Row(
            children: [
              //Sport section organization
              if (isSport) ...[
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF5B59B4),
                  ),
                  child: Icon(
                    icon,
                    size: 24,
                    color: Colors.white
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ] else ...[
                //Culture section organization
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 15),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF5B59B4),
                  ),
                  child: Icon(
                    icon,
                    size: 24,
                    color: Colors.white
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}