import 'dart:async';
import 'dart:typed_data'; // Necessario per Uint8List (BLOB)
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// --- MODELLI DI DATI CORRETTI ---

// La PK `id` è nullabile (`int?`) perché un oggetto Categoria
// appena creato in Dart (e non ancora salvato nel DB) non ha ancora un ID.
// L'ID viene assegnato dal DB solo al momento dell'inserimento.
class Categoria {
  final int? id;
  final String nome;

  Categoria({this.id, required this.nome});

  Map<String, dynamic> toMap() => {'id': id, 'nome': nome};

  factory Categoria.fromMap(Map<String, dynamic> map) => Categoria(
        id: map['id'],
        nome: map['nome'],
      );
}

class Specie {
  final int? id; // Nullabile per lo stesso motivo della Categoria
  final String nome;
  final String? descrizione;
  final int idCategoria;

  Specie({
    this.id,
    required this.nome,
    this.descrizione,
    required this.idCategoria,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'nome': nome,
        'descrizione': descrizione,
        'idCategoria': idCategoria,
      };

  factory Specie.fromMap(Map<String, dynamic> map) => Specie(
        id: map['id'],
        nome: map['nome'],
        descrizione: map['descrizione'],
        idCategoria: map['idCategoria'],
      );
}

class Pianta {
  final int? id; // Nullabile per lo stesso motivo della Categoria
  final String nome;
  final DateTime dataAcquisto;
  final Uint8List? foto; // Utilizziamo Uint8List per il tipo BLOB
  final int frequenzaInnaffiatura;
  final int frequenzaPotatura;
  final int frequenzaRinvaso;
  final String? note;
  final String stato;
  final int idSpecie;

  Pianta({
    this.id,
    required this.nome,
    required this.dataAcquisto,
    this.foto,
    required this.frequenzaInnaffiatura,
    required this.frequenzaPotatura,
    required this.frequenzaRinvaso,
    this.note,
    required this.stato,
    required this.idSpecie,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'dataAcquisto': dataAcquisto.toIso8601String(),
      'foto': foto,
      'frequenzaInnaffiatura': frequenzaInnaffiatura,
      'frequenzaPotatura': frequenzaPotatura,
      'frequenzaRinvaso': frequenzaRinvaso,
      'note': note,
      'stato': stato,
      'idSpecie': idSpecie,
    };
  }

  factory Pianta.fromMap(Map<String, dynamic> map) {
    return Pianta(
      id: map['id'],
      nome: map['nome'],
      dataAcquisto: DateTime.parse(map['dataAcquisto']),
      foto: map['foto'] as Uint8List?,
      frequenzaInnaffiatura: map['frequenzaInnaffiatura'],
      frequenzaPotatura: map['frequenzaPotatura'],
      frequenzaRinvaso: map['frequenzaRinvaso'],
      note: map['note'],
      stato: map['stato'],
      idSpecie: map['idSpecie'],
    );
  }
}


// --- DATABASE HELPER CORRETTO ---

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDB();

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'plant_care_v2.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
    );
  }

  Future _onCreate(Database db, int version) async {
    // Usiamo un batch per eseguire tutte le creazioni in una singola transazione.
    // È più sicuro e performante.
    var batch = db.batch();

    batch.execute('''
      CREATE TABLE categorie (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL UNIQUE
      )
    ''');

    batch.execute('''
      CREATE TABLE specie (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL UNIQUE,
        descrizione TEXT,
        idCategoria INTEGER NOT NULL,
        FOREIGN KEY (idCategoria) REFERENCES categorie(id) ON DELETE CASCADE
      )
    ''');
    
    // Corretta la tabella `piante` per usare BLOB e nomi consistenti
    batch.execute('''
      CREATE TABLE piante (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        dataAcquisto TEXT NOT NULL,
        foto BLOB,
        frequenzaInnaffiatura INTEGER NOT NULL,
        frequenzaPotatura INTEGER NOT NULL,
        frequenzaRinvaso INTEGER NOT NULL,
        note TEXT,
        stato TEXT NOT NULL,
        idSpecie INTEGER NOT NULL,
        FOREIGN KEY (idSpecie) REFERENCES specie(id) ON DELETE CASCADE
      )
    ''');
    
    await batch.commit(noResult: true); // Eseguiamo tutte le operazioni
  }

  // --- CRUD per Pianta ---
  Future<int> addPianta(Pianta pianta) async {
    Database db = await instance.database;
    // Uso il nome tabella corretto: 'piante'
    return await db.insert('piante', pianta.toMap());
  }

  Future<Pianta?> getPianta(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      'piante', // Nome tabella corretto
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Pianta.fromMap(maps.first);
    }
    return null;
  }
  
  Future<List<Pianta>> getAllPiante() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('piante'); // Nome tabella corretto
    return List.generate(maps.length, (i) => Pianta.fromMap(maps[i]));
  }

  Future<int> updatePianta(Pianta pianta) async {
    Database db = await instance.database;
    return await db.update(
      'piante', // Nome tabella corretto
      pianta.toMap(),
      where: 'id = ?',
      whereArgs: [pianta.id],
    );
  }

  Future<int> deletePianta(int id) async {
    Database db = await instance.database;
    return await db.delete(
      'piante', // Nome tabella corretto
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
