import 'package:flutter/material.dart';
import 'package:octoloupe/model/activity_model.dart';

class ActivityCard extends StatelessWidget {
  final String imageUrl;
  final String discipline;
  final Place place;
  final List<Schedule> schedules;
  final List<Pricing> pricings;
  final VoidCallback onTap;
  
  const ActivityCard({
    super.key,
    required this.imageUrl,
    required this.discipline,
    required this.place,
    required this.schedules,
    required this.pricings,
    required this.onTap,
  });

  @override
  Widget build(
    BuildContext context
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        color: const Color(0xFF5B59B4),
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 125,
                      height: 125,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 4,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          discipline,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${place.titleAddress}, ${place.streetAddress}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${place.postalCode} ${place.city}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        for (var schedule in schedules) ...[
                          Wrap(
                            spacing: 1.0,
                            children: [
                              Text(
                                '${schedule.day} : ',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              for (var timeSlot in schedule.timeSlots) ...[
                                if (timeSlot.startHour?.isNotEmpty == true && timeSlot.endHour?.isNotEmpty == true)
                                  Text(
                                    'De ${timeSlot.startHour} à ${timeSlot.endHour} ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  )
                                else if (timeSlot.startHour?.isNotEmpty == true && timeSlot.endHour?.isEmpty == true)
                                  Text(
                                    'A partir de ${timeSlot.startHour} ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  )
                                else if (timeSlot.startHour?.isEmpty == true && timeSlot.endHour?.isNotEmpty == true)
                                  Text(
                                    'Jusqu\'à ${timeSlot.endHour} ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  )
                                else if (timeSlot.startHour?.isEmpty == true && timeSlot.endHour?.isEmpty == true)
                                  Container(),
                              ],
                            ],
                          ),
                        ],
                        const SizedBox(height: 10),
                        for (var pricing in pricings) ...[
                          Text(
                            '${pricing.profile} : ${pricing.pricing} ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );  
  }
/*  @override
Widget build(BuildContext context) {
  return GestureDetector(
    onTap: onTap,
    child: Card(
      elevation: 4.0,
      color: const Color(0xFF5B59B4),
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(  // Utilisation de Column pour organiser les éléments verticalement
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Image circulaire en haut à gauche
                ClipOval(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Discipline
                      Text(
                        discipline,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Adresse compactée
                      Text(
                        '${place.titleAddress}, ${place.streetAddress}, ${place.postalCode} ${place.city}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Horaires
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: schedules.map((schedule) {
                          return Row(
                            children: [
                              Text(
                                '${schedule.day} :',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Compacter l'affichage des créneaux horaires
                              ...schedule.timeSlots.map((timeSlot) {
                                if (timeSlot.startHour?.isNotEmpty == true && timeSlot.endHour?.isNotEmpty == true) {
                                  return Text(
                                    'De ${timeSlot.startHour} à ${timeSlot.endHour}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white70,
                                    ),
                                  );
                                } else if (timeSlot.startHour?.isNotEmpty == true) {
                                  return Text(
                                    'A partir de ${timeSlot.startHour}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white70,
                                    ),
                                  );
                                } else if (timeSlot.endHour?.isNotEmpty == true) {
                                  return Text(
                                    'Jusqu\'à ${timeSlot.endHour}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white70,
                                    ),
                                  );
                                }
                                return Container();  // Pas de texte si les deux heures sont vides
                              }).toList(),
                            ],
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                      // Tarification
                      ...pricings.map((pricing) {
                        return Text(
                          '${pricing.profile} : ${pricing.pricing}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
 */

}