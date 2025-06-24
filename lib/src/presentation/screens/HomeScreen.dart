import 'package:flutter/material.dart';
import '../widgets/CustomNavBar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Benvenuto nella Home!')),
      bottomNavigationBar: const CustomNavBar(currentIndex: 0),
    );
  }
}
