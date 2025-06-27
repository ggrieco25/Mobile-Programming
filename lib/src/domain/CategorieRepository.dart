import 'package:sqflite/sqflite.dart';
import '../data/local/DatabaseHelper.dart';
import '../data/models/CategoriaModel.dart';

class CategorieRepository {
  CategorieRepository._privateConstructor();
  static final CategorieRepository instance = CategorieRepository._privateConstructor();

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Categoria>> getTutteLeCategorie() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('categorie');
    return maps.map((map) => Categoria.fromMap(map)).toList();
  }
}