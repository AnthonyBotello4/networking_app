import 'package:flutter/material.dart';
import 'package:networking_app/ui/movie_list.dart';

void main() {
  runApp(MyMovies());
}

class MyMovies extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Movies',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MovieList()
    );
  }
}