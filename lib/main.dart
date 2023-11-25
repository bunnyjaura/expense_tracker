import 'package:expanse_tracker/controller/expense_provider.dart';
import 'package:expanse_tracker/controller/theme_provider.dart';
import 'package:expanse_tracker/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ExpenseProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Expense Tracker',
            theme: themeProvider.selectedTheme,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
