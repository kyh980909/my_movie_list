import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_movie_list/Model/movie.dart';
import '../Database/DBHelper.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DetailInfo extends StatefulWidget {
  final Movie movie;

  DetailInfo({Key key, @required this.movie}) : super(key: key);

  @override
  _DetailInfoState createState() => _DetailInfoState();
}

class _DetailInfoState extends State<DetailInfo> {
  Future<Movie> getMovieFromDB() async {
    var dbHelper = DBHelper();
    Future<Movie> movie = dbHelper.getMovie(widget.movie);

    return movie;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Detail Info'),
        ),
        body: ListView(
          children: <Widget>[
            Center(
              child: Container(
                child: FutureBuilder<Movie>(
                  future: getMovieFromDB(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      if (snapshot.hasData) {
                        return Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  snapshot.data.date,
                                  style: TextStyle(fontSize: 30.0),
                                ),
                                Image.memory(
                                  base64Decode(snapshot.data.ticket),
                                  height: 300,
                                  width: 300,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 10.0),
                                ),
                                Text(
                                  snapshot.data.title,
                                  style: TextStyle(fontSize: 30.0),
                                ),
                                FlutterRatingBarIndicator(
                                  itemCount: 5,
                                  rating: double.parse(snapshot.data.score),
                                  emptyColor: Colors.amber.withAlpha(50),
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
                                    child: Text(
                                      snapshot.data.review,
                                      style: TextStyle(fontSize: 30.0),
                                    ))
                              ],
                            ));
                      }
                    }
                    return Container(
                      alignment: AlignmentDirectional.center,
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ),
          ],
        ));
  }
}
