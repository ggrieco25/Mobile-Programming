import 'package:sqflite/sqflite.dart';
import '../data/local/DatabaseHelper.dart';
import '../data/models/PiantaModel.dart';

class PiantaRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Pianta>> getTutteLePiante() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('pianta');

    return maps.map((map) => Pianta.fromMap(map)).toList();
  }
}
