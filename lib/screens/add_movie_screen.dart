import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:movie_list_application/helpers/database_helper.dart';
import 'package:movie_list_application/models/movie_model.dart';

class AddMovieScreen extends StatefulWidget {
  //AddMovieScreen({Key? key}) : super(key: key);
  final Function updateMovieList;
  AddMovieScreen({required this.updateMovieList});

  @override
  _AddMovieScreenState createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends State<AddMovieScreen> {
  //final _formKey = GlobalKey<FormState>();

  var _nameController = TextEditingController();
  var _directorController = TextEditingController();
  String _name = '';
  String _director = '';

  String imagePath = "";
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
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
                  'Add Movie',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                Column(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: TextField(
                      controller: _nameController,
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                      decoration: InputDecoration(
                        hoverColor: Colors.black,
                        labelText: 'Name',
                        labelStyle: TextStyle(color: Colors.red),
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
                        'Select Image',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                      onPressed: () async {
                        final pickedFile =
                            await picker.getImage(source: ImageSource.gallery);
                        imagePath = pickedFile!.path;
                      },
                    ),
                  ),
                  // imagePath != ""
                  //     ? Container(
                  //         padding: EdgeInsets.symmetric(horizontal: 15),
                  //         child: Image.file(File(imagePath)),
                  //       )
                  //     : Container(),
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
                        'Add',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                      onPressed: () async {
                        if (_nameController.text != '' &&
                            _directorController.text != '') {
                          _name = _nameController.text;
                          _director = _directorController.text;
                          if (imagePath == '') {
                            print('Pick a Image');
                          } else {
                            print('$_name,$_director');
                            Movie movie = Movie(
                                name: _name,
                                director: _director,
                                status: 0,
                                picture: imagePath);

                            movie.status = 0;
                            DatabaseHelper.instance.insertMovie(movie);

                            widget.updateMovieList();
                            Navigator.pop(context);
                          }
                        } else {
                          print("Please Fill all required details!!!");
                        }
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
