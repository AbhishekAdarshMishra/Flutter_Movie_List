import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_list_application/helpers/database_helper.dart';
import 'package:movie_list_application/models/movie_model.dart';

class EditMovieScreen extends StatefulWidget {
  final Function updateMovieList;

  late final Movie movie;
  EditMovieScreen({required this.updateMovieList, required this.movie});
  @override
  _EditMovieScreenState createState() => _EditMovieScreenState();
}

class _EditMovieScreenState extends State<EditMovieScreen> {
  var _nameController = TextEditingController();
  var _directorController = TextEditingController();
  String _name = '';
  String _director = '';
  String _imagePath = '';
  late int _id;
  final picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    if (widget.movie != null) {
      print(widget.movie.id);
      _id = widget.movie.id;
      _nameController.text = widget.movie.name;
      _directorController.text = widget.movie.director;
      _name = widget.movie.name;
      _director = widget.movie.director;
      _imagePath = widget.movie.picture;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 80.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back_ios,
                      size: 30.0, color: Theme.of(context).primaryColor),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Update Movie',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                Column(children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Image.file(
                      File(_imagePath),
                      height: 100.0,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: TextField(
                      controller: _nameController,
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(color: Colors.red),
                        helperText: _name,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: TextField(
                      controller: _directorController,
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Director',
                        labelStyle: TextStyle(color: Colors.red),
                        helperText: _director,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    //padding: EdgeInsets.all(15),
                    height: 60.0,
                    width: 160.0,
                    // width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: TextButton(
                      child: Text(
                        'Change Image',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                      onPressed: () async {
                        final pickedFile =
                            await picker.getImage(source: ImageSource.gallery);
                        _imagePath = pickedFile!.path;
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20.0),
                    height: 60.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: TextButton(
                      child: Text(
                        'Edit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                      onPressed: () async {
                        if (_nameController.text != '' &&
                            _directorController.text != '' &&
                            _imagePath != '') {
                          _name = _nameController.text;
                          _director = _directorController.text;

                          print('$_name,$_director');

                          Movie movie = Movie.withId(
                            id: _id,
                            name: _name,
                            director: _director,
                            status: 0,
                            picture: _imagePath,
                          );
                          if (widget.movie == null) {
                            movie.status = 0;
                            DatabaseHelper.instance.insertMovie(movie);
                          } else {
                            movie.status = widget.movie.status;
                            DatabaseHelper.instance.updateMovie(movie);
                          }

                          widget.updateMovieList();
                          Navigator.pop(context);
                        } else {
                          print("Please Fill all required details!!!");
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    height: 60.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: TextButton(
                      child: Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                      onPressed: () async {
                        DatabaseHelper.instance.deleteMovie(widget.movie.id);
                        widget.updateMovieList();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
