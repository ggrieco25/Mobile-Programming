import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/PiantaModel.dart'; // Assicurati che il percorso sia corretto

class DatabaseHelper {
  // Singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  // Getter per il database. Se non esiste, lo inizializza.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  // Inizializzazione del database
  _initDB() async {
    String path = join(await getDatabasesPath(), 'plant_care.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate, // Eseguito solo la prima volta che il DB viene creato
    );
  }

  // Crea le tabelle del database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE piante (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        specie TEXT NOT NULL,
        dataAcquisto TEXT NOT NULL,
        percorsoFoto TEXT,
        frequenzaInnaffiatura INTEGER NOT NULL,
        frequenzaPotatura INTEGER NOT NULL,
        frequenzaRinvaso INTEGER NOT NULL,
        note TEXT,
        stato TEXT NOT NULL
      )
    ''');
    // Qui potresti creare altre tabelle, ad esempio per le Categorie
  }

  // --- Operazioni CRUD (Create, Read, Update, Delete) ---

  // Inserire una nuova pianta
  Future<int> addPianta(Pianta pianta) async {
    Database db = await instance.database;
    return await db.insert('piante', pianta.toMap());
  }

  // Ottenere una singola pianta tramite ID
  Future<Pianta?> getPianta(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      'piante',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Pianta.fromMap(maps.first);
    }
    return null;
  }

  // Ottenere tutte le piante
  Future<List<Pianta>> getAllPiante() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('piante');

    return List.generate(maps.length, (i) {
      return Pianta.fromMap(maps[i]);
    });
  }
  
  // Aggiornare una pianta
  Future<int> updatePianta(Pianta pianta) async {
    Database db = await instance.database;
    return await db.update(
      'piante',
      pianta.toMap(),
      where: 'id = ?',
      whereArgs: [pianta.id],
    );
  }

  // Eliminare una pianta
  Future<int> deletePianta(int id) async {
    Database db = await instance.database;
    return await db.delete(
      'piante',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}