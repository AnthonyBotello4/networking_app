import 'package:flutter/material.dart';
import 'package:networking_app/models/movie.dart';
import 'package:networking_app/util/db_helper.dart';

class MovieDetail extends StatefulWidget {
  final Movie movie;

  MovieDetail(this.movie);

  @override
  State<MovieDetail> createState() => _MovieDetailState(movie);
}

class _MovieDetailState extends State<MovieDetail> {
  final Movie movie;
  DbHelper dbHelper = DbHelper();
  String path = '';

  _MovieDetailState(this.movie);

  @override
  void initState() {
    dbHelper = DbHelper();
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    if (movie.posterPath != null) {
      path = 'https://image.tmdb.org/t/p/w500${movie.posterPath}';
    } else {
      path =
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title!),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16.0),
              height: height * 0.4,
              child: Hero(
                  tag: "poster_${movie.id}",
                  child: Image.network(
                    path,
                    height: height / 1.5,
                  )),
            ),
            IconButton(
              icon: const Icon(Icons.favorite),
              color: (movie.isFavorite!) ? Colors.red : Colors.grey,
              onPressed: () {
                movie.isFavorite!
                    ? dbHelper.deleteMovie(movie)
                    : dbHelper.insertMovie(movie);

                setState(() {
                  movie.isFavorite = !(movie.isFavorite!);
                });
              },
            ),
            Container(
                padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    bottom: 8.0,
                    top: 8.0
                ),
                child: Text(movie.overview!))
          ]),
        ),
      ),
    );
  }
}
