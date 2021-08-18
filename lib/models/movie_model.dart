import 'dart:typed_data';

class Movie {
  late int id;
  String name;
  String director;
  int status;
  String picture; //0- Incomplete and 1- Complete

  Movie(
      {required this.name,
      required this.director,
      required this.status,
      required this.picture});
  Movie.withId(
      {required this.id,
      required this.name,
      required this.director,
      required this.status,
      required this.picture});

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    // if (id != null) {
    //   map['id'] = id;
    // }
    map['name'] = name;
    map['director'] = director;
    map['status'] = status;
    map['picture'] = picture;
    return map;
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    print(map['id']);
    print(map['name']);
    return Movie.withId(
      id: map['id'],
      name: map['name'],
      director: map['director'],
      status: map['status'],
      picture: map['picture'],
    );
  }
}
