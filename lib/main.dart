import 'package:flutter/material.dart';
import 'package:my_movie_list/movie_list.dart';

void main() => runApp(MyMovieListApp());

class MyMovieListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Movie List App',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: MovieList(),
    );
  }
}
