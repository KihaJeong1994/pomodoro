import 'package:flutter/material.dart';
import 'package:pomodoro/screens/home_screen.dart';

void main(List<String> args) {
  runApp(Pomodoro());
}

class Pomodoro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        backgroundColor: Color.fromARGB(255, 101, 61, 165),
        textTheme: const TextTheme(
          headline1: TextStyle(
            color: Color(0xFF232B55),
          ),
        ),
        cardColor: const Color(0xFFF4EDDB),
      ),
      home: const HomeScreen(),
    );
  }
}
