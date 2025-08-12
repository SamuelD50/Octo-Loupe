import 'package:flutter/material.dart';
import 'package:octoloupe/model/activity_model.dart';

// This component allows to create a brief overview of the activity in the form of card

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

  String? formatTimeSlot(TimeSlot timeSlot) {
    if (timeSlot.startHour?.isNotEmpty == true && timeSlot.endHour?.isNotEmpty == true) {
      return 'De ${timeSlot.startHour} à ${timeSlot.endHour}';
    } else if (timeSlot.startHour?.isNotEmpty == true && timeSlot.endHour?.isEmpty == true) {
      return 'A partir de ${timeSlot.startHour}';
    } else if (timeSlot.startHour?.isEmpty == true && timeSlot.endHour?.isNotEmpty == true) {
      return 'Jusqu\'à ${timeSlot.endHour}';
    }
    return null;
  }

  @override
  Widget build(
    BuildContext context
  ) {
    return Semantics(
      label: 'Carte d\'activité pour $discipline à ${place.city}',
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 4.0,
          color: const Color(0xFF5B59B4),
          shadowColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        width: 125,
                        height: 125,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 4,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Semantics(
                            label: 'Image illustrant $discipline',
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Image.asset(
                                  'assets/images/ActivityByDefault.webp',
                                  fit: BoxFit.cover,
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/ActivityByDefault.webp',
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                      )
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
                                for (var timeSlot in schedule.timeSlots)
                                  if (formatTimeSlot(timeSlot) != null)
                                    Text(
                                      formatTimeSlot(timeSlot)!,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
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
      ),
    );  
  }
}