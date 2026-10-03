import 'package:flutter/material.dart';
import 'screens/home_screen.dart';


void main() {
  runApp(const BunnyTodoApp());
}

class BunnyTodoApp extends StatelessWidget {
  const BunnyTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Bunny To-do',

      theme: ThemeData(
        useMaterial3: true,

        fontFamily: 'Times New Roman',

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF123B5D),
          primary: const Color(0xFF123B5D),
          secondary: const Color(0xFFCDECCF),
          surface: const Color(0xFFF4FAF2),
        ),

        scaffoldBackgroundColor: const Color(0xFFF4FAF2),
      ),

      home: const HomeScreen(),
    );
  }
}
