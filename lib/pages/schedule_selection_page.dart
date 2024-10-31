import 'package:flutter/material.dart';

class ScheduleSelectionPage extends StatelessWidget {
  const ScheduleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sélectionner un Horaire')),
      body: Center(child: Text('Page de Sélection d\'Horaire')),
    );
  }
}