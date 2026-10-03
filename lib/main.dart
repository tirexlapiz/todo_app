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

        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF5D83)),

        scaffoldBackgroundColor: const Color(0xFFFFF8FA),
      ),

      home: const HomeScreen(),
    );
  }
}
