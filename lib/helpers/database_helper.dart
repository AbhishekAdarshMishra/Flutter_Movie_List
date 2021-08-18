import 'dart:io';

import 'package:movie_list_application/models/movie_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database? _db;
  DatabaseHelper._instance();

  String moviesTable = 'movie_table';
  String colId = 'id';
  String colName = 'name';
  String colDirector = 'director';
  String colStatus = 'status';
  String colPicture = 'picture';

  Future<Database?> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  Future<Database?> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'movie_list.db';
    final movieListDb =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return movieListDb;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $moviesTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colName TEXT, $colDirector TEXT,$colStatus INTEGER,$colPicture BLOB)',
    );
  }

  Future<List<Map<String, dynamic>>> getMovieMapList() async {
    Database? db = await this.db;
    final List<Map<String, dynamic>> result = await db!.query(moviesTable);
    return result;
  }

  Future<List<Movie>> getMovieList() async {
    final List<Map<String, dynamic>> movieMapList = await getMovieMapList();
    final List<Movie> movieList = [];
    movieMapList.forEach((movieMap) {
      movieList.add(Movie.fromMap(movieMap));
    });
    return movieList;
  }

  Future<int> insertMovie(Movie movie) async {
    Database? db = await this.db;
    final int result = await db!.insert(moviesTable, movie.toMap());
    return result;
  }

  Future<int> updateMovie(Movie movie) async {
    Database? dp = await this.db;
    final int result = await dp!.update(
      moviesTable,
      movie.toMap(),
      where: '$colId = ?',
      whereArgs: [movie.id],
    );
    return result;
  }

  Future<int> deleteMovie(int id) async {
    Database? db = await this.db;
    final int result = await db!.delete(
      moviesTable,
      where: '$colId = ?',
      whereArgs: [id],
    );
    return result;
  }
}
