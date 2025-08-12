import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class ActivityMapProvider extends ChangeNotifier {
  LatLng? selectedMarkerPosition;
  String? _selectedDiscipline;

  String? get selectedDiscipline => _selectedDiscipline;

  void selectMarker(
    LatLng position,
    String discipline,
  ) {
    selectedMarkerPosition = position;
    _selectedDiscipline = discipline;
    notifyListeners();
  }

  void clearSelection() {
    selectedMarkerPosition = null;
    _selectedDiscipline = null;
    notifyListeners();
  }
}