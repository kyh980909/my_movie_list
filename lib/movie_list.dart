import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Database/DBHelper.dart';
import 'Model/movie.dart';
import 'package:intl/intl.dart';

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
        onPressed: addMovieScreen,
        child: Icon(Icons.add),
      ),
    );
  }

  TextEditingController title = TextEditingController(); // 영화명 텍스트 필스 값 컨트롤 객체

  final df = DateFormat('yyyy년 MM월 dd일');
  String date = '년 월 일';

  void addMovieScreen() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
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
                  hintText: '영화 이름을 입력하세요',
                  contentPadding: EdgeInsets.all(16.0)),
            ),
            Text(date,style: TextStyle(fontSize: 24.0),),
            Builder(
              builder: (context) => RaisedButton(
                    onPressed: () {
                      var dateTime = showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate:
                              DateTime.now().subtract(Duration(days: 30)),
                          lastDate: DateTime.now().add(Duration(days: 30)));
                      dateTime.then((val) {
                        setState(() {
                          date = df.format(val);
                        });
                      });
                    },
                    child: Text('날짜'),
                  ),
            ),
            RaisedButton(
              onPressed: () {
                submitMovie(title.text);
                Navigator.pop(context);
              },
              child: Text('저장'),
            )
          ],
        ),
      );
    }));
  }

  void submitMovie(String title) {
    var movie = Movie();

    movie.title = title;
    movie.date = date;

    var dbHelper = DBHelper();
    dbHelper.addMovie(movie);

    Fluttertoast.showToast(msg: 'Movie was saved', toastLength: Toast.LENGTH_SHORT);
  }
}
