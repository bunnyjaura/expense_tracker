import 'package:expanse_tracker/view/utils/theme.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool isDark = false;

  ThemeData selectedTheme = lightTheme;
  void toggleTheme(bool x) {
    isDark =x;
    selectedTheme = x ? darkTheme : lightTheme;
    notifyListeners();
  
  }
}
