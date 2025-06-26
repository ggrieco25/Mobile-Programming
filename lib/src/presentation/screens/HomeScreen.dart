import 'package:flutter/material.dart';
import '../widgets/ListaUltimePiante.dart';
import '../../data/local/database_helper.dart';
import '../../data/models/pianta_model.dart';
import '../widgets/CustomNavBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Pianta> piante = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPiante();
  }

  Future<void> _loadPiante() async {
    final pianteCaricate = await DatabaseHelper.instance.getAllPiante();
    setState(() {
      piante = pianteCaricate;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : piante.isEmpty
          ? const Center(child: Text('Nessuna pianta trovata.'))
          : ListaUltimePiante(piante: piante),
      bottomNavigationBar: const CustomNavBar(currentIndex: 0),
    );
  }
}
