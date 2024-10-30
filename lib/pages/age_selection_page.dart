import 'package:flutter/material.dart';

class AgeSelectionPage extends StatelessWidget {
  const AgeSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sélectionner un Âge')),
      body: Center(child: Text('Page de Sélection d\'Âge')),
    );
  }
}