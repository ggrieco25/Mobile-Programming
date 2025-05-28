import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomNavBar({super.key, required this.currentIndex});

  void _onTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/discover');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/watchlist');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onTap(context, index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Scopri'),
        BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Watchlist'),
      ],
      selectedItemColor: Colors.deepPurple, // Personalizzabile
      unselectedItemColor: Colors.grey,
    );
  }
}
