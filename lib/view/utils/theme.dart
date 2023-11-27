import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

final ThemeData lightTheme = ThemeData.light(useMaterial3: true).copyWith(
  primaryColor: Colors.cyan[200],
   textTheme: Typography.material2018(platform: TargetPlatform.android).white.apply(
    fontFamily: 'Poppins',
  ),
  canvasColor: Colors.black,
  cardColor: Colors.grey[200],
  highlightColor: const Color.fromARGB(255, 240, 240, 240),
);

final ThemeData darkTheme = ThemeData.dark(useMaterial3: true).copyWith(
  primaryColor: Colors.cyan[200],
   textTheme: Typography.material2018(platform: TargetPlatform.android).white.apply(
    fontFamily: 'Poppins',
  ),
  canvasColor: Colors.white,
  cardColor: const Color.fromARGB(255, 20, 20, 20),
  highlightColor: Colors.black,
);
