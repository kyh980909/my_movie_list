import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Database/DBHelper.dart';
import 'Model/movie.dart';

import 'addMovieScreen.dart';

Future<List<Movie>> getMoviesFromDB() async {
  var dbHelper = DBHelper();
  Future<List<Movie>> movies = dbHelper.getMovies();

  return movies;
}

class MovieList extends StatefulWidget {
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  @override
  void initState() {
    super.initState();
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
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.20,
                        child: ListTile(
                          title: Text(snapshot.data[index].title),
                          subtitle: Text(snapshot.data[index].date),
                        ),
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            icon: Icons.delete,
                            color: Colors.red,
                            caption: 'Deleted',
                            onTap: () {
                              var dbHelper = DBHelper();
                              dbHelper.deleteMoive(snapshot.data[index]);
                              Fluttertoast.showToast(
                                  msg: 'Movie was deleted',
                                  toastLength: Toast.LENGTH_SHORT);
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
}
