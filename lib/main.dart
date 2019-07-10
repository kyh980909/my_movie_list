import 'package:flutter/material.dart';
import 'package:my_movie_list/movie_list.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras;

Future<void> main() async {
  cameras = await availableCameras();

  runApp(MyMovieListApp());
}

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
