import 'package:expanse_tracker/controller/expense_provider.dart';
import 'package:expanse_tracker/controller/theme_provider.dart';
import 'package:expanse_tracker/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeProvider = ThemeProvider();
  await themeProvider.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ExpenseProvider()),
        ChangeNotifierProvider.value(value: themeProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Expense Tracker',
          theme: themeProvider.selectedTheme,
          routerConfig: router,
        );
      },
    );
  }
}
