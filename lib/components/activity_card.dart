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
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 200,
                  width: 150,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
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
                    const SizedBox(height: 8),
                    Text(
                      '${place.titleAddress}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      '${place.streetAddress}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      '${place.postalCode} ${place.city}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    for (var schedule in schedules) ...[
                      Row(
                        children: [
                          Text(
                            '${schedule.day} :',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          for (var timeSlot in schedule.timeSlots) ...[
                            Text(
                              'De ${timeSlot.startHour} à ${timeSlot.endHour}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ]
                      ),
                    ],
                    const SizedBox(height: 10),
                    for (var pricing in pricings) ...[
                      Text(
                        '${pricing.profile} : ${pricing.pricing}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ]
                ),
              ),
            ],
          ),
        ),
      ),
    );  
  }
}