/* import 'package:flutter/material.dart';
import 'package:octoloupe/model/activity_model.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({super.key, required this.activity});

  final ActivityModel activity;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shadowColor: Colors.amber,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          /* Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(activity.imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ), */
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity.discipline),
                const SizedBox(height: 16),
                Text(activity.information),
                const SizedBox(height: 16),
                Text('Lieu: ${activity.place.title}'),
                const Text('Horaires: '),
                for (var schedule in activity.schedules) ...[
                  Text('${schedule.day}:'),
                  for (var timeSlot in schedule.timeSlots)
                    Text(' ${timeSlot.startHour} - ${timeSlot.endHour}'),
                ],
                const Text('Prix: '),
                for (var pricing in activity.pricings)
                  Text('${pricing.profile} : ${pricing.pricing}€'),
                TextButton(
                  child: const Text('En savoir plus'),
                  onPressed: () {
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
} */