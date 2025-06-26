import 'package:flutter/material.dart';

import '../../data/models/PromemoriaModel.dart';
import '../../domain/PromemoriaRepository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Un'istanza del nostro repository. In un'app più grande, useresti un sistema
  // di dependency injection come Riverpod o Provider per passarla.
  final PromemoriaRepository _promemoriaRepository = PromemoriaRepository();
  late Future<List<Promemoria>> _futurePromemoria;

  @override
  void initState() {
    super.initState();
    // All'avvio della schermata, chiedo al repository di caricare i promemoria.
    _futurePromemoria = _promemoriaRepository.getPromemoriaImminenti();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Plant Care')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Promemoria Imminenti', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _buildPromemoriaSection(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () { /* Naviga ad aggiungi pianta */ },
        label: const Text('Aggiungi Pianta'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPromemoriaSection() {
    // FutureBuilder è perfetto per gestire stati di caricamento, errore e successo.
    return FutureBuilder<List<Promemoria>>(
      future: _futurePromemoria,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Errore nel caricamento: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Text('Nessuna attività di cura imminente. Ottimo lavoro!', textAlign: TextAlign.center),
            ),
          );
        }

        final promemoriaList = snapshot.data!;
        // Usiamo ListView.builder che è più performante di una Column per liste lunghe.
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: promemoriaList.length,
          itemBuilder: (context, index) {
            return _buildPromemoriaCard(promemoriaList[index]);
          },
          separatorBuilder: (context, index) => const SizedBox(height: 12),
        );
      },
    );
  }

  Widget _buildPromemoriaCard(Promemoria promemoria) {
    final icona = _getIconForActivity(promemoria.attivita);
    final testoAttivita = _getTextForActivity(promemoria.attivita);
    final (testoScadenza, coloreScadenza) = _formatScadenza(promemoria.dataScadenza);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        leading: CircleAvatar(backgroundColor: icona.color?.withOpacity(0.1), child: icona),
        title: Text(promemoria.pianta.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(testoAttivita),
        trailing: Chip(
          label: Text(testoScadenza, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          backgroundColor: coloreScadenza,
        ),
      ),
    );
  }

  // Funzioni helper per la UI
   Icon _getIconForActivity(TipoAttivita attivita) {
    switch (attivita) {
      case TipoAttivita.innaffiatura: return const Icon(Icons.water_drop, color: Colors.blue);
      case TipoAttivita.potatura: return const Icon(Icons.content_cut, color: Colors.orange);
      case TipoAttivita.rinvaso: return const Icon(Icons.yard, color: Colors.brown);
    }
  }

  String _getTextForActivity(TipoAttivita attivita) {
    switch (attivita) {
      case TipoAttivita.innaffiatura: return 'Innaffiatura';
      case TipoAttivita.potatura: return 'Potatura';
      case TipoAttivita.rinvaso: return 'Rinvaso';
    }
  }

   (String, Color) _formatScadenza(DateTime scadenza) {
    final now = DateTime.now();
    final oggi = DateTime(now.year, now.month, now.day);
    final dataScadenza = DateTime(scadenza.year, scadenza.month, scadenza.day);
    final differenza = dataScadenza.difference(oggi).inDays;

    if (differenza < 0) return ('Scaduto', Colors.red.shade700);
    if (differenza == 0) return ('Oggi', Colors.red.shade500);
    if (differenza == 1) return ('Domani', Colors.orange.shade600);
    return ('Tra $differenza gg', Colors.blueGrey.shade400);
  }
}
