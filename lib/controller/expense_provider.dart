import 'dart:async';
import 'package:expanse_tracker/controller/theme_provider.dart';
import 'package:expanse_tracker/models/expense_model.dart';
import 'package:expanse_tracker/router.dart';
import 'package:expanse_tracker/view/utils/database.dart';
import 'package:expanse_tracker/view/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class ExpenseProvider extends ChangeNotifier {
  navigateToHome() {
    Timer(
        const Duration(
          seconds: 3,
        ), () {
      router.go('/home');
    });
  }

  TextEditingController title = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController category = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController date = TextEditingController();

  DateTime? selectedDate;
  DateTime? initial;
  datePicker(BuildContext context, ThemeProvider theme) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: theme.isDark
              ? ThemeData.dark().copyWith(
                  primaryColor: Theme.of(context).primaryColor,
                  dialogTheme: DialogTheme(
                      backgroundColor: Theme.of(context).dividerColor,
                      titleTextStyle: const TextStyle(color: Colors.red),
                      contentTextStyle:
                          TextStyle(color: Theme.of(context).canvasColor)),
                  colorScheme: ColorScheme.dark(
                    primary: Theme.of(context).primaryColor,
                    surface: const Color.fromARGB(255, 26, 26, 26),
                    surfaceTint: const Color.fromARGB(255, 26, 26, 26),
                  ),
                )
              : ThemeData.light().copyWith(
                  primaryColor: Theme.of(context).primaryColor,
                  colorScheme: ColorScheme.light(
                      primary: Theme.of(context).primaryColor,
                      surface: const Color.fromARGB(255, 231, 235, 236),
                      surfaceTint: const Color.fromARGB(255, 231, 235, 236)),
                  dialogTheme: DialogTheme(
                      backgroundColor: Theme.of(context).dividerColor,
                      titleTextStyle: const TextStyle(color: Colors.red),
                      contentTextStyle:
                          TextStyle(color: Theme.of(context).canvasColor)),
                ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      initial = pickedDate;
      selectedDate = pickedDate;
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      date.text = formattedDate;
      notifyListeners();
    }
  }

  List<ExpenseData> data = [];

  addExpense() async {
    if (title.text.isEmpty) {
      SnackbarService.showSnackbar('Enter Title');
    } else if (amount.text.isEmpty) {
      SnackbarService.showSnackbar('Enter Amount');
    } else if (category.text.isEmpty) {
      SnackbarService.showSnackbar('Select Category');
    } else if (description.text.isEmpty) {
      SnackbarService.showSnackbar('Enter Description');
    } else if (date.text.isEmpty) {
      SnackbarService.showSnackbar('Select Date');
    } else {
      final expenseData = ExpenseData(
          uid: const Uuid().v4(),
          category: category.text,
          amount: amount.text,
          date: selectedDate!,
          description: description.text,
          title: title.text);
      await DatabaseHelper().saveExpenseData(expenseData);
      data.add(expenseData);
      SnackbarService.showSnackbar('Added Successfully');
      fetchTotal();
      router.go('/home');

      notifyListeners();
      debugPrint(expenseData.uid.toString());
    }
  }

  editDataList(ExpenseData expenseData) {
    int index = data.indexWhere((expense) => expense.uid == expenseData.uid);

    if (index != -1) {
      data[index].category = expenseData.category;
      data[index].amount = expenseData.amount;
      data[index].date = expenseData.date;
      data[index].description = expenseData.description;
      data[index].title = expenseData.title;
      debugPrint(data[index].amount.toString());
      debugPrint(expenseData.amount.toString());
    }
  }

  editExpense(String uid) async {
    if (title.text.isEmpty) {
      SnackbarService.showSnackbar('Enter Title');
    } else if (amount.text.isEmpty) {
      SnackbarService.showSnackbar('Enter Amount');
    } else if (category.text.isEmpty) {
      SnackbarService.showSnackbar('Select Category');
    } else if (description.text.isEmpty) {
      SnackbarService.showSnackbar('Enter Description');
    } else if (date.text.isEmpty) {
      SnackbarService.showSnackbar('Select Date');
    } else {
      final expenseData = ExpenseData(
        uid: uid,
        category: category.text,
        amount: amount.text,
        date: selectedDate!,
        description: description.text,
        title: title.text,
      );

      await DatabaseHelper().updateExpenseData(expenseData);
      debugPrint(uid.toString());
      ExpenseData? updatedData =
          await DatabaseHelper().fetchExpenseDataById(expenseData.uid);

      debugPrint(updatedData!.uid.toString());
      editDataList(updatedData);

      SnackbarService.showSnackbar('Updated Successfully');
      fetchTotal();
      router.go('/home');
      notifyListeners();
    }
  }

  void deleteExpenseById(String id) {
    data.removeWhere((expense) => expense.uid == id);
    notifyListeners();
  }

  deleteExpense(String id) async {
    await DatabaseHelper().deleteExpenseById(id);
    deleteExpenseById(id);
    SnackbarService.showSnackbar('Deleted Successfully');
    fetchTotal();
  }

  List<ExpenseData> getTodayExpenses(List<ExpenseData> expenses) {
    return expenses.where((expense) {
      final now = DateTime.now();
      return expense.date.year == now.year &&
          expense.date.month == now.month &&
          expense.date.day == now.day;
    }).toList();
  }

  List<ExpenseData> getOlderExpenses(List<ExpenseData> expenses) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return expenses.where((expense) {
      final expenseDate =
          DateTime(expense.date.year, expense.date.month, expense.date.day);
      return !expenseDate.isAtSameMomentAs(today);
    }).toList();
  }

  fetchData() async {
    data = await DatabaseHelper().getExpenseData();
    notifyListeners();
    fetchTotal();
  }

  int total = 0;
  fetchTotal() {
    total = 0;
    for (var e in data) {
      total += int.parse(e.amount);
      notifyListeners();
    }
    debugPrint(total.toString());
  }

  clear() {
    title.clear();
    amount.clear();
    description.clear();
    category.clear();
    date.clear();
    selectedDate = null;
    initial = null;
  }
}
