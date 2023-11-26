import 'package:expanse_tracker/database/theme_database.dart';
import 'package:expanse_tracker/view/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:expanse_tracker/models/theme_model.dart';

class ThemeProvider with ChangeNotifier {
  bool isDark = false;
  ThemeData selectedTheme = lightTheme;
  final ThemeDatabase _themeDatabase = ThemeDatabase();

  Future<void> initialize() async {
    await _themeDatabase.initThemeDatabase();
    final theme = await _themeDatabase.getTheme(1);
    isDark = theme != null && theme.themeId == 1;
    selectedTheme = isDark ? darkTheme : lightTheme;
    notifyListeners();
  }

  Future<void> toggleTheme(bool x) async {
    isDark = x;
    selectedTheme = x ? darkTheme : lightTheme;
    await _themeDatabase.insertOrUpdateTheme(ThemeModel(themeId: x ? 1 : 0)); 
    notifyListeners();
  }
}
