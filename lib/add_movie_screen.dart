import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'Database/DBHelper.dart';
import 'Model/movie.dart';
import 'dart:io' show Platform;

class AddMovieScreen extends StatefulWidget {
  @override
  _AddMovieScreenState createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  TextEditingController title = TextEditingController(); // 영화명 텍스트 필스 값 컨트롤 객체

  final df = DateFormat('yyyy년 MM월 dd일');
  String date = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new movie'),
      ),
      body: Column(
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
                )
              ],
            ),
          ),
          RaisedButton(
            onPressed: () {
              if(title.text == '') {
                Fluttertoast.showToast(msg: '영화명을 입력해주세요', toastLength: Toast.LENGTH_SHORT);
              }
              else if(date == '') {
                Fluttertoast.showToast(msg: '날짜를 입력해주세요.', toastLength: Toast.LENGTH_SHORT);
              } else {
                submitMovie(title.text);
                Navigator.pop(context);
              }
            },
            child: Text('저장'),
          )
        ],
      ),
    );
  }

  void submitMovie(String title) {
    var movie = Movie();

    movie.title = title;
    movie.date = date;

    var dbHelper = DBHelper();
    dbHelper.addMovie(movie);

    Fluttertoast.showToast(
        msg: 'Movie was saved', toastLength: Toast.LENGTH_SHORT);
  }
}
