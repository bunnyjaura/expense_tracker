import 'package:expanse_tracker/models/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ThemeDatabase {
  void _onCreateTheme(Database db, int version) async {
    await db.execute('''
      CREATE TABLE theme(
        id INTEGER PRIMARY KEY,
        themeId INT
      )
    ''');
  }

  Future<Database> initThemeDatabase() async {
    String path = join(await getDatabasesPath(), 'theme_database.db');

    debugPrint('Theme Database path: $path');

    try {
      final db = await openDatabase(path, version: 1, onCreate: _onCreateTheme);
      return db;
    } catch (e) {
      debugPrint('Error opening theme database: $e');
      await deleteDatabase(path);
      final newDb =
          await openDatabase(path, version: 1, onCreate: _onCreateTheme);
      return newDb;
    }
  }

  Future<void> insertOrUpdateTheme(ThemeModel theme) async {
    Database db = await initThemeDatabase();

    final List<Map<String, dynamic>> existingThemes = await db.query(
      'theme',
      where: 'id = ?',
      whereArgs: [1],
    );

    if (existingThemes.isNotEmpty) {
      await db.update(
        'theme',
        theme.toMap(),
        where: 'id = ?',
        whereArgs: [1],
      );
    } else {
      await db.insert(
        'theme',
        theme.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<ThemeModel?> getTheme(int themeId) async {
    Database db = await initThemeDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'theme',
      where: 'themeId = ?',
      whereArgs: [themeId],
    );
    if (maps.isNotEmpty) {
      return ThemeModel.fromMap(maps.first);
    }
    return null;
  }
}
