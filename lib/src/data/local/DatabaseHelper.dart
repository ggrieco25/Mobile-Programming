import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/PiantaModel.dart';
import '../models/SpecieModel.dart';
import '../models/CategoriaModel.dart';
import '../models/AttivitaCuraModel.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;
  Future<Database> get database async => _database ??= await _initDB();

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'plant_care_v3.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate, onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'));
  }

  Future _onCreate(Database db, int version) async {
    var batch = db.batch();
    batch.execute(''
        'CREATE TABLE categorie('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'nome TEXT NOT NULL UNIQUE)'
        '');
    batch.execute('''CREATE TABLE specie(
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      nome TEXT NOT NULL UNIQUE, 
      descrizione TEXT, 
      idCategoria INTEGER NOT NULL, 
      FOREIGN KEY (idCategoria) 
      REFERENCES categorie(id) ON DELETE CASCADE)''');
    batch.execute('''CREATE TABLE piante(
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
      FOREIGN KEY (idSpecie) 
      REFERENCES specie(id) ON DELETE CASCADE)''');
    batch.execute('''CREATE TABLE attivitaCura(
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      idPianta INTEGER NOT NULL, 
      tipoAttivita TEXT NOT NULL, 
      data TEXT NOT NULL, 
      FOREIGN KEY (idPianta) 
      REFERENCES piante(id) ON DELETE CASCADE)''');
    await batch.commit(noResult: true);
  }

  // --- CRUD per Pianta (già presenti) ---

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

  // Metodi CRUD per Categoria

  /// Inserisce una nuova categoria nel database.
  Future<int> addCategoria(Categoria categoria) async {
    final db = await database;
    return await db.insert('categorie', categoria.toMap());
  }

  /// Recupera una singola categoria tramite il suo ID.
  Future<Categoria?> getCategoria(int id) async {
    final db = await database;
    final maps = await db.query(
      'categorie',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Categoria.fromMap(maps.first);
    }
    return null;
  }

  /// Recupera tutte le categorie dal database.
  Future<List<Categoria>> getAllCategorie() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('categorie');
    return List.generate(maps.length, (i) => Categoria.fromMap(maps[i]));
  }

  /// Aggiorna una categoria esistente.
  Future<int> updateCategoria(Categoria categoria) async {
    final db = await database;
    return await db.update(
      'categorie',
      categoria.toMap(),
      where: 'id = ?',
      whereArgs: [categoria.id],
    );
  }

  /// Elimina una categoria tramite il suo ID.
  /// Grazie a ON DELETE CASCADE, verranno eliminate anche tutte le specie
  /// e le piante associate a questa categoria.
  Future<int> deleteCategoria(int id) async {
    final db = await database;
    return await db.delete(
      'categorie',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  // Metodi CRUD per Specie

  /// Inserisce una nuova specie nel database.
  Future<int> addSpecie(Specie specie) async {
    final db = await database;
    return await db.insert('specie', specie.toMap());
  }

  /// Recupera una singola specie tramite il suo ID.
  Future<Specie?> getSpecie(int id) async {
    final db = await database;
    final maps = await db.query(
      'specie',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Specie.fromMap(maps.first);
    }
    return null;
  }

  /// Recupera tutte le specie dal database.
  Future<List<Specie>> getAllSpecie() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('specie');
    return List.generate(maps.length, (i) => Specie.fromMap(maps[i]));
  }

  /// Recupera tutte le specie appartenenti a una determinata categoria.
  /// Molto utile per i filtri nell'interfaccia utente.
  Future<List<Specie>> getSpecieByCategoria(int idCategoria) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'specie',
      where: 'idCategoria = ?',
      whereArgs: [idCategoria],
    );
    return List.generate(maps.length, (i) => Specie.fromMap(maps[i]));
  }


  /// Aggiorna una specie esistente.
  Future<int> updateSpecie(Specie specie) async {
    final db = await database;
    return await db.update(
      'specie',
      specie.toMap(),
      where: 'id = ?',
      whereArgs: [specie.id],
    );
  }

  /// Elimina una specie tramite il suo ID.
  /// Grazie a ON DELETE CASCADE, verranno eliminate anche tutte le piante
  /// associate a questa specie.
  Future<int> deleteSpecie(int id) async {
    final db = await database;
    return await db.delete(
      'specie',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  // Aggiungiamo il CRUD per AttivitaCura.
  Future<int> addAttivitaCura(AttivitaCura attivita) async {
    final db = await database;
    return await db.insert('attivitaCura', attivita.toMap());
  }

  Future<DateTime?> getUltimaAttivita(int idPianta, String tipoAttivita) async {
    final db = await database;
    final maps = await db.query(
      'attivitaCura',
      where: 'idPianta = ? AND tipoAttivita = ?',
      whereArgs: [idPianta, tipoAttivita],
      orderBy: 'data DESC',
      limit: 1,
    );
    if(maps.isNotEmpty) {
      return DateTime.parse(maps.first['data'] as String);
    }
    return null;
  }
}
