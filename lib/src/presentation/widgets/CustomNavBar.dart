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
        Navigator.pushReplacementNamed(context, '/piante');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/analitica');
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
        BottomNavigationBarItem(icon: Icon(Icons.local_florist_rounded), label: 'Piante'),
        BottomNavigationBarItem(icon: Icon(Icons.view_kanban_outlined), label: 'Analitica'),
      ],
<<<<<<< HEAD
      selectedItemColor: const Color.fromARGB(251, 56, 145, 62), // Personalizzabile
=======
      selectedItemColor: Color.fromARGB(255, 104, 181, 16), // Personalizzabile
>>>>>>> d25414e6649e84362f0e9cc3a0e9457958ceb919
      unselectedItemColor: Colors.grey,
      backgroundColor: Color.fromARGB(255, 221, 252, 221),
    );
  }
}