import 'package:sqflite/sqflite.dart';
import '../data/local/DatabaseHelper.dart';
import '../data/models/SpecieModel.dart';

class SpecieRepository {
  SpecieRepository._privateConstructor();
  static final SpecieRepository instance = SpecieRepository._privateConstructor();

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Specie>> getTutteLeSpecie() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('specie');
    return maps.map((map) => Specie.fromMap(map)).toList();
  }
}
