import 'package:cricket_app/screens/tabs.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 147, 229, 250),
    surface: const Color.fromARGB(255, 47, 52, 55),
  ),
  scaffoldBackgroundColor: const Color.fromARGB(255, 50, 58, 60),
  textTheme: GoogleFonts.latoTextTheme(),
);

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: const TabsScreen(),
    );
  }
}
