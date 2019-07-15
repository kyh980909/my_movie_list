import 'dart:async';
import 'dart:io' as io;
import 'package:my_movie_list/Model/movie.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  final String tableName = "movie_info";
  static Database dbInstance;

  Future<Database> get db async {
    if (dbInstance == null) dbInstance = await initDB();
    return dbInstance;
  }

  initDB() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "movie.db");
    var db = await openDatabase(path, version: 1, onCreate: onCreateFunc);
    return db;
  }

  void onCreateFunc(Database db, int version) async {
    await db.execute(
        'create table $tableName(id integer primary key autoincrement, title text, date text, ticket text, score text, review text);');
  }

  // DB 에서 영화 목록 불러오기
  Future<List<Movie>> getMovies() async {
    var dbCon = await db;
    List<Map> list = await dbCon.rawQuery('select * from $tableName');
    List<Movie> movies = List();

    for (int i = 0; i < list.length; i++) {
      Movie movie = new Movie();
      movie.id = list[i]['id'];
      movie.title = list[i]['title'];
      movie.date = list[i]['date'];
      movie.ticket = list[i]['ticket'];
      movie.score = list[i]['score'];
      movie.review = list[i]['review'];

      movies.add(movie);
    }

    return movies;
  }

  Future<Movie> getMovie(Movie movieInfo) async {
    var dbCon = await db;
    List<Map> list = await dbCon
        .rawQuery('select * from $tableName where id=${movieInfo.id}');

    Movie movie = new Movie();

    movie.id = list[0]['id'];
    movie.title = list[0]['title'];
    movie.date = list[0]['date'];
    movie.ticket = list[0]['ticket'];
    movie.score = list[0]['score'];
    movie.review = list[0]['review'];

    return movie;
  }

  void addMovie(Movie movie) async {
    var dbCon = await db;
    String sql =
        'insert into $tableName(title, date, ticket, score, review) values ("${movie.title}","${movie.date}", "${movie.ticket}", "${movie.score}", "${movie.review}")';
    await dbCon.transaction((transaction) async {
      return await transaction.rawInsert(sql);
    });
  }

  void updateMovie(Movie movie) async {
    var dbCon = await db;
    String sql =
        'update $tableName set name = "${movie.title}, ${movie.date}", ${movie.ticket}, ${movie.score}", "${movie.review}" where id=${movie.id}';
    await dbCon.transaction((transaction) async {
      return await transaction.rawQuery(sql);
    });
  }

  void deleteMovie(Movie movie) async {
    var dbCon = await db;
    String sql = 'delete from $tableName where id=${movie.id}';
    await dbCon.transaction((transaction) async {
      return await transaction.rawQuery(sql);
    });
  }
}
