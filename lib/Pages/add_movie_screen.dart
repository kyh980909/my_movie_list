import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../Database/DBHelper.dart';
import '../Model/movie.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AddMovieScreen extends StatefulWidget {
  @override
  _AddMovieScreenState createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  TextEditingController title = TextEditingController();
  File _image;
  final df = DateFormat('yyyy년 MM월 dd일');
  String date = '';
  double score;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new movie'),
      ),
      body: ListView(
        children: <Widget>[
          TextField(
            controller: title,
            autofocus: true,
            decoration: InputDecoration(
                hintText: '영화 이름을 입력하세요', contentPadding: EdgeInsets.all(16.0)),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0, left: 7.0, bottom: 20.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 5.0),
                ),
                Text(
                  '영화를 본 날짜 : ',
                  style: TextStyle(fontSize: 20.0),
                ),
                Text(
                  '$date',
                  style: TextStyle(fontSize: 20.0),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () {
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(1970),
                        maxTime: DateTime.now(), onConfirm: (date) {
                      setState(() {
                        this.date = df.format(date);
                      });
                    }, currentTime: DateTime.now(), locale: LocaleType.ko);
                  },
                ),
              ],
            ),
          ),
          IconButton(icon: Icon(Icons.camera), onPressed: getImageFromGallery),
          Center(
            child: _image == null
                ? Text('No image selected')
                : Image.file(
                    _image,
                    height: 400,
                    width: 300,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
            child: Center(
              child: FlutterRatingBar(
                  initialRating: 0,
                  fillColor: Colors.amber,
                  borderColor: Colors.amber.withAlpha(50),
                  allowHalfRating: true,
                  onRatingUpdate: (rating) {
                    score = rating;
                    print(rating);
                  }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 160, right: 160, bottom: 30.0),
            child: RaisedButton(
              onPressed: () {
                if (title.text == '') {
                  Fluttertoast.showToast(
                      msg: '영화명을 입력해주세요', toastLength: Toast.LENGTH_SHORT);
                } else if (date == '') {
                  Fluttertoast.showToast(
                      msg: '날짜를 입력해주세요.', toastLength: Toast.LENGTH_SHORT);
                } else if (_image == null) {
                  Fluttertoast.showToast(
                      msg: '사진을 업로드해주세요.', toastLength: Toast.LENGTH_SHORT);
                } else {
                  submitMovie(title.text, Image.file(_image));
                  Navigator.pop(context);
                }
              },
              child: Text(
                '저장',
                style: TextStyle(color: Colors.white),
              ),
              color: Color(0xff3fc4fe), //Color.fromRGBO(63, 196, 254, 100),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.camera_alt),
      ),
    );
  }

  Future submitMovie(String title, Image ticket) async {
    var movie = Movie();

    List<int> imageBytes = await _image.readAsBytes();
    String base64Image = base64Encode(imageBytes);

    movie.title = title;
    movie.date = date;
    movie.ticket = base64Image;
    movie.score = score.toString();

    var dbHelper = DBHelper();
    dbHelper.addMovie(movie);

    Fluttertoast.showToast(
        msg: 'Movie was saved', toastLength: Toast.LENGTH_SHORT);
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }
}
