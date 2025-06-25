import 'dart:typed_data';

class Pianta {
  int? id; // L'ID sarà autoincrementato dal DB
  String nome;
  String specie;
  DateTime dataAcquisto; // Salvata come ISO8601 stringa nel DB
  Uint8List? foto; // Immagine salvata come BLOB
  int frequenzaInnaffiatura;
  int frequenzaPotatura;
  int frequenzaRinvaso;
  String note;
  String stato;

  Pianta({
    this.id,
    required this.nome,
    required this.specie,
    required this.dataAcquisto,
    this.foto,
    required this.frequenzaInnaffiatura,
    required this.frequenzaPotatura,
    required this.frequenzaRinvaso,
    required this.note,
    required this.stato,
  });

  /// Converte un oggetto Pianta in una Map per il DB
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'specie': specie,
      'dataAcquisto': dataAcquisto.toIso8601String(),
      'foto': foto, // Uint8List? → salvata come BLOB
      'frequenzaInnaffiatura': frequenzaInnaffiatura,
      'frequenzaPotatura': frequenzaPotatura,
      'frequenzaRinvaso': frequenzaRinvaso,
      'note': note,
      'stato': stato,
    };
  }

  /// Crea un oggetto Pianta a partire da una Map del DB
  factory Pianta.fromMap(Map<String, dynamic> map) {
    return Pianta(
      id: map['id'],
      nome: map['nome'],
      specie: map['specie'],
      dataAcquisto: DateTime.parse(map['dataAcquisto']),
      foto: map['foto'], // BLOB → Uint8List?
      frequenzaInnaffiatura: map['frequenzaInnaffiatura'],
      frequenzaPotatura: map['frequenzaPotatura'],
      frequenzaRinvaso: map['frequenzaRinvaso'],
      note: map['note'],
      stato: map['stato'],
    );
  }

  @override
  String toString() {
    return 'Pianta{id: $id, nome: $nome, specie: $specie}';
  }
}
