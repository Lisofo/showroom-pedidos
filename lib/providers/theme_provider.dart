import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  int _selectedColor = 0;

  int get selectedColor => _selectedColor;

  set selectedColor(int color){
    _selectedColor = color;
    notifyListeners();
  }
}