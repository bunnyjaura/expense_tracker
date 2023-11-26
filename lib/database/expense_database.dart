import 'package:expanse_tracker/models/expense_model.dart';
import 'package:expanse_tracker/models/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database? _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    _db ??= await initDatabase();
    return _db!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'expenses.db');

    debugPrint('Database path: $path');

    try {
      final db = await openDatabase(path, version: 1, onCreate: _onCreate);
      return db;
    } catch (e) {
      debugPrint('Error opening database: $e');
      await deleteDatabase(path);
      final newDb = await openDatabase(path, version: 1, onCreate: _onCreate);
      return newDb;
    }
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE expenses(
        id INTEGER PRIMARY KEY,
        uid TEXT,
        category TEXT,
        amount TEXT,
        date TEXT,
        description TEXT,
        title TEXT
      )
    ''');
  }

  Future<int> saveExpenseData(ExpenseData expense) async {
    try {
      Database database = await db;
      return await database.rawInsert(
          'INSERT INTO expenses(uid ,category, amount, date, description, title) '
          'VALUES (?, ?, ?, ?, ?, ?)',
          [
            expense.uid,
            expense.category,
            expense.amount,
            expense.date.toIso8601String(),
            expense.description,
            expense.title
          ]);
    } catch (e) {
      debugPrint('Error saving expense data: $e');
      return -1;
    }
  }

  Future<int> updateExpenseData(ExpenseData expense) async {
    try {
      Database database = await db;
      return await database.rawUpdate(
        'UPDATE expenses SET category = ?, amount = ?, date = ?, description = ?, title = ? WHERE uid = ?',
        [
          expense.category,
          expense.amount,
          expense.date.toIso8601String(),
          expense.description,
          expense.title,
          expense.uid
        ],
      );
    } catch (e) {
      debugPrint('Error updating expense data: $e');
      return -1;
    }
  }

  Future<ExpenseData?> fetchExpenseDataById(String uid) async {
    try {
      Database database = await db;
      List<Map<String, dynamic>> maps = await database.query(
        'expenses',
        where: 'uid = ?',
        whereArgs: [uid],
      );

      if (maps.isNotEmpty) {
        return ExpenseData(
          uid: maps.first['uid'].toString(),
          category: maps.first['category'].toString(),
          amount: maps.first['amount'].toString(),
          date: DateTime.parse(maps.first['date'] as String),
          description: maps.first['description'].toString(),
          title: maps.first['title'].toString(),
        );
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching expense data by UID: $e');
      return null;
    }
  }

  Future<List<ExpenseData>> getExpenseData() async {
    Database database = await db;
    List<Map<String, dynamic>> result =
        await database.rawQuery('SELECT * FROM expenses');
    List<ExpenseData> expenseList = [];

    if (result.isEmpty) {
      debugPrint('No expense data found in the database');
      return expenseList;
    }

    for (Map<String, dynamic> expenseMap in result) {
      ExpenseData expense = ExpenseData(
        uid: expenseMap['uid'].toString(),
        category: expenseMap['category'],
        amount: expenseMap['amount'],
        date: DateTime.parse(expenseMap['date']),
        description: expenseMap['description'],
        title: expenseMap['title'],
      );
      expenseList.add(expense);
    }

    return expenseList;
  }

  Future<int?> deleteExpenseById(String uid) async {
    Database database = await db;
    try {
      int? result =
          await database.rawDelete('DELETE FROM expenses WHERE uid = ?', [uid]);
      debugPrint('Delete result: $result');
      return result;
    } catch (e) {
      debugPrint('Delete error: $e');
      return null;
    }
  }

}
