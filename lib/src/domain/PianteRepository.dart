import 'package:sqflite/sqflite.dart';
import '../data/local/DatabaseHelper.dart';
import '../data/models/PiantaModel.dart';

class PianteRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Pianta>> getTutteLePiante() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('piante');

    return maps.map((map) => Pianta.fromMap(map)).toList();
  }

  Future<void> aggiungiPianta(Pianta pianta) async {
    final db = await _dbHelper.database;
    await db.insert(
      'piante',
      pianta.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
