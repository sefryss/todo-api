import 'package:flutter/material.dart';
import 'package:todo_api/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bootcamp API',
      theme: ThemeData.dark(),
      home: HomeScreen(),
    );
  }
}
