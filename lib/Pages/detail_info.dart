import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_movie_list/Model/movie.dart';
import '../Database/DBHelper.dart';

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
        body: Container(
          child: FutureBuilder<Movie>(
            future: getMovieFromDB(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                if (snapshot.hasData) {
                  return Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        children: <Widget>[
                          Image.memory(base64Decode(snapshot.data.ticket)),
                          Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                          ),
                          Text(snapshot.data.id.toString()),
                          Text(snapshot.data.date),
                          Text(snapshot.data.title),
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
        ));
  }
}
