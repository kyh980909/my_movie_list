import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_movie_list/Pages/detail_info.dart';
import '../Database/DBHelper.dart';
import '../Model/movie.dart';

import 'add_movie_screen.dart';

class MovieList extends StatefulWidget {
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
  }

  Future<List<Movie>> getMoviesFromDB() async {
    var dbHelper = DBHelper();
    Future<List<Movie>> movies = dbHelper.getMovies();

    return movies;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Movie List"),
      ),
      body: Container(
        child: FutureBuilder<List<Movie>>(
            future: getMoviesFromDB(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                if (snapshot.hasData) {
                  return RefreshIndicator(
                    key: _refreshIndicatorKey,
                    child: buildMovieListView(snapshot),
                    onRefresh: _refresh,
                  );
                }
              }
              return Container(
                alignment: AlignmentDirectional.center,
                child: CircularProgressIndicator(),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddMovieScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  ListView buildMovieListView(AsyncSnapshot<List<Movie>> snapshot) {
    return ListView.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (context, index) {
        return Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.20,
          child: ListTile(
            leading: Image.memory(base64Decode(snapshot.data[index].ticket)),
            title: Text(snapshot.data[index].title),
            subtitle: Text(snapshot.data[index].date),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailInfo(
                            movie: snapshot.data[index],
                          )));
            },
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
              icon: Icons.delete,
              color: Colors.red,
              caption: 'Deleted',
              onTap: () {
                var dbHelper = DBHelper();
                dbHelper.deleteMovie(snapshot.data[index]);
                Fluttertoast.showToast(
                    msg: 'Movie was deleted', toastLength: Toast.LENGTH_SHORT);
                setState(() {
                  getMoviesFromDB();
                });
              },
            )
          ],
        );
      },
    );
  }

  Future _refresh() {
    var dbHelper = DBHelper();

    return dbHelper.getMovies().then((_) {
      setState(() {
        getMoviesFromDB();
      });
    });
  }
}
