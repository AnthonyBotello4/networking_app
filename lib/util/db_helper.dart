import 'package:networking_app/models/movie.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper{
  final int version = 1;
  Database? db;

  static final DbHelper dbHelper = DbHelper._internal();
  DbHelper._internal();
  factory DbHelper(){
    return dbHelper;
  }

  Future<Database> openDb() async {
     if (db == null){
       db = await openDatabase(
           join(await getDatabasesPath(), 'movies.dbb'),
           onCreate: (database, version){
             database.execute(
                 'CREATE TABLE movies(id INTEGER PRIMARY KEY, title TEXT, poster_path TEXT)'
             );
           },
           version: version
       );
     }

     return db!;
  }

  Future<int?> insertMovie(Movie movie) async {
    int? id = await db!.insert(
        'movies',
        movie.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );
    return id;
  }

  Future<bool> isFavorite(Movie movie) async {
    final List<Map<String, dynamic>> maps = await db!.query(
        'movies',
        where: 'id = ?',
        whereArgs: [movie.id]
    );
    return maps.length > 0;
  }

  Future<int> deleteMovie(Movie movie) async {
    int result = await db!.delete(
        'movies',
        where: 'id = ?',
        whereArgs: [movie.id]
    );
    return result;
  }

}