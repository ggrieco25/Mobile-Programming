import 'package:flutter/material.dart';
import '../../data/models/PiantaModel.dart';

class ListaUltimePiante extends StatelessWidget {
  final List<Pianta> piante;

  const ListaUltimePiante({super.key, required this.piante});

  @override
  Widget build(BuildContext context) {
    List<Pianta> pianteOrdinate = [...piante];
    pianteOrdinate.sort((a, b) => b.dataAcquisto.compareTo(a.dataAcquisto));

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: pianteOrdinate.length,
      itemBuilder: (context, index) {
        final pianta = pianteOrdinate[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: pianta.foto != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.memory(
                pianta.foto!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            )
                : const Icon(Icons.local_florist),
            title: Text(pianta.nome),
            subtitle: Text('${pianta.specie} • ${pianta.stato}'),
            trailing: Text(
              '${pianta.dataAcquisto.day.toString().padLeft(2, '0')}/${pianta.dataAcquisto.month.toString().padLeft(2, '0')}/${pianta.dataAcquisto.year}',
              style: const TextStyle(fontSize: 12),
            ),
            onTap: () {
              // Vai ai dettagli della pianta
            },
          ),
        );
      },
    );
  }
}
