import 'package:flutter/material.dart';

class SectorSelectionPage extends StatelessWidget {
  const SectorSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sélectionner un Secteur')),
      body: Center(child: Text('Page de Sélection de Secteur')),
    );
  }
}