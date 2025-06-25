import 'package:flutter/material.dart';
import '../../data/models/PiantaModel.dart';
import 'dart:typed_data';

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

        Widget leadingWidget;
        if (pianta.foto != null && pianta.foto!.isNotEmpty) {
          leadingWidget = ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.memory(
              pianta.foto!,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          );
        } else {
          leadingWidget = const Icon(Icons.local_florist, size: 40);
        }

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: leadingWidget,
            title: Text(pianta.nome),
            subtitle: Text('${pianta.specie} • ${pianta.stato}'),
            trailing: Text(
              '${pianta.dataAcquisto.day.toString().padLeft(2, '0')}/${pianta.dataAcquisto.month.toString().padLeft(2, '0')}/${pianta.dataAcquisto.year}',
              style: const TextStyle(fontSize: 12),
            ),
            onTap: () {
              // TODO: Navigazione ai dettagli della pianta
            },
          ),
        );
      },
    );
  }
}
