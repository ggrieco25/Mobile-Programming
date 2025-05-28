import 'package:flutter/material.dart';
import 'package:progetto_mp/HomeScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TV Tracker',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
