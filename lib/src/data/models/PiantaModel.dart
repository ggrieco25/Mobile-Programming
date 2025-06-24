
class Pianta {
  int? id; // L'ID sarà autoincrementato dal DB, quindi può essere nullo
  String nome;
  String specie;
  String dataAcquisto; // Memorizzata come Stringa (es. 'AAAA-MM-GG')
  String? percorsoFoto;
  int frequenzaInnaffiatura; // in giorni
  int frequenzaPotatura; // in giorni
  int frequenzaRinvaso; // in giorni
  String note;
  String stato; // Es. "Sana", "Da controllare", "Malata"

  Pianta({
    this.id,
    required this.nome,
    required this.specie,
    required this.dataAcquisto,
    this.percorsoFoto,
    required this.frequenzaInnaffiatura,
    required this.frequenzaPotatura,
    required this.frequenzaRinvaso,
    required this.note,
    required this.stato,
  });

  // Converte un oggetto Pianta in una Map.
  // Le chiavi devono corrispondere ai nomi delle colonne nel database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'specie': specie,
      'dataAcquisto': dataAcquisto,
      'percorsoFoto': percorsoFoto,
      'frequenzaInnaffiatura': frequenzaInnaffiatura,
      'frequenzaPotatura': frequenzaPotatura,
      'frequenzaRinvaso': frequenzaRinvaso,
      'note': note,
      'stato': stato,
    };
  }

  // Estrae un oggetto Pianta da una Map.
  factory Pianta.fromMap(Map<String, dynamic> map) {
    return Pianta(
      id: map['id'],
      nome: map['nome'],
      specie: map['specie'],
      dataAcquisto: map['dataAcquisto'],
      percorsoFoto: map['percorsoFoto'],
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