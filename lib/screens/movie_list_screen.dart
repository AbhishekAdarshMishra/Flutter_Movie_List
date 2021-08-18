import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movie_list_application/helpers/database_helper.dart';
import 'package:movie_list_application/models/movie_model.dart';
import 'package:movie_list_application/screens/add_movie_screen.dart';
import 'package:movie_list_application/screens/edit_movie_screen.dart';

class MovieListScreen extends StatefulWidget {
  MovieListScreen({Key? key}) : super(key: key);

  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  Future<List<Movie>>? _movieList;
  @override
  void initState() {
    super.initState();
    _updateMovieList();
  }

  _updateMovieList() {
    setState(() {
      _movieList = DatabaseHelper.instance.getMovieList();
    });
  }

  Widget _buildTask(Movie movie) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.red[600],
        elevation: 10,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Image.file(
                  File(movie.picture),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            ListTile(
              title: Text(
                movie.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  decoration: movie.status == 0
                      ? TextDecoration.none
                      : TextDecoration.lineThrough,
                ),
              ),
              subtitle: Text(
                movie.director,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[300],
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                  decoration: movie.status == 0
                      ? TextDecoration.none
                      : TextDecoration.lineThrough,
                ),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditMovieScreen(
                    updateMovieList: _updateMovieList,
                    movie: movie,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  //padding: EdgeInsets.all(15),
                  height: 40.0,
                  width: 100.0,
                  // width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.green[800],
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditMovieScreen(
                          updateMovieList: _updateMovieList,
                          movie: movie,
                        ),
                      ),
                    ),
                    child: Text('Edit', style: TextStyle(color: Colors.white)),
                  ),
                ),
                SizedBox(width: 20.0),
                Container(
                  //padding: EdgeInsets.all(15),
                  height: 40.0,
                  width: 100.0,
                  // width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue[800],
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      DatabaseHelper.instance.deleteMovie(movie.id);
                      _movieList = DatabaseHelper.instance.getMovieList();
                      setState(() {});
                      //_updateMovieList();
                    },
                    child:
                        Text('Delete', style: TextStyle(color: Colors.white)),
                  ),
                )
              ],
            ),
            Divider(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddMovieScreen(
              updateMovieList: _updateMovieList,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        child: Icon(Icons.add, color: Colors.red),
      ),
      body: FutureBuilder(
        future: _movieList,
        builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 70.0),
                    child: Text('No Data Found!!!',
                        style: TextStyle(color: Colors.red, fontSize: 20.0)),
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            );
          } else if (snapshot.data!.length <= 0) {
            return Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 70.0),
                    child: Text('No Data Found!!!',
                        style: TextStyle(color: Colors.red, fontSize: 20.0)),
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error');
          }

          // final int completedTaskCount = snapshot.data!
          //     .where((Movie movie) => movie.status == 1)
          //     .toList()
          //     .length;

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            itemCount: 1 + snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Watched Movies',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.0),
                    ],
                  ),
                );
              }
              return _buildTask(snapshot.data![index - 1]);
            },
          );
        },
      ),
    );
  }
}
