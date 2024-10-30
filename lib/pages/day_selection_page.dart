import 'package:flutter/material.dart';

class DaySelectionPage extends StatelessWidget {
  const DaySelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sélectionner un Jour')),
      body: Center(child: Text('Page de Sélection de Jour')),
    );
  }
}