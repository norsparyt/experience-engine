import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ExperienceEngineApp());
}

class ExperienceEngineApp extends StatelessWidget {
  const ExperienceEngineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Experience Engine',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF6200EE),
        colorScheme: const ColorScheme.dark(
          primary: Colors.deepPurpleAccent,
          secondary: Colors.pinkAccent,
          surface: Color(0xFF0F0C20),
        ),
        scaffoldBackgroundColor: const Color(0xFF0F0C20),
      ),
      home: const HomeScreen(),
    );
  }
}
