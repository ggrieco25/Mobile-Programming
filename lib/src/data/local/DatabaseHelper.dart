import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/PiantaModel.dart';  // importa il modello Pianta (e altre classi se vuoi)

// Se vuoi puoi importare anche Categoria e Specie dallo stesso modello, oppure crearli a parte.

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

    await batch.commit(noResult: true);
  }

  // --- CRUD per Pianta ---

  Future<int> addPianta(Pianta pianta) async {
    final db = await database;
    return await db.insert('piante', pianta.toMap());
  }

  Future<Pianta?> getPianta(int id) async {
    final db = await database;
    final maps = await db.query(
      'piante',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Pianta.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Pianta>> getAllPiante() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('piante');
    return List.generate(maps.length, (i) => Pianta.fromMap(maps[i]));
  }

  Future<int> updatePianta(Pianta pianta) async {
    final db = await database;
    return await db.update(
      'piante',
      pianta.toMap(),
      where: 'id = ?',
      whereArgs: [pianta.id],
    );
  }

  Future<int> deletePianta(int id) async {
    final db = await database;
    return await db.delete(
      'piante',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
