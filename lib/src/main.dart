import 'package:flutter/material.dart';
import 'presentation/screens/HomeScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TV Tracker',
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {'/home': (_) => const HomeScreen()},
    );
  }
}
