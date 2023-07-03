import 'package:flutter/material.dart';
import 'package:networking_app/util/db_helper.dart';
import 'package:networking_app/models/movie.dart';

import 'movie_detail.dart';

class FavMovies extends StatefulWidget {
  const FavMovies({super.key});

  @override
  State<FavMovies> createState() => _FavMoviesState();
}

class _FavMoviesState extends State<FavMovies> {
  DbHelper dbHelper = DbHelper();
  List<Movie> movies = [];

  @override
  Widget build(BuildContext context) {
    showData();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Movies'),
      ),
      body: ListView.builder(
        itemCount: (movies != null) ? movies.length : 0,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
              key: Key(movies[index].id.toString()),
              background: Container(
                color: Colors.red,
                child: const Icon(Icons.delete),
              ),
              onDismissed: (direction)  {
                dbHelper.deleteMovie(movies[index]);
                setState(() {
                  movies.removeAt(index);
                });
              },
              child: Card(
                color: Colors.white,
                elevation: 2.0,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    backgroundImage: NetworkImage(
                        'https://image.tmdb.org/t/p/w500/${movies[index].posterPath!}'),
                  ),
                  title: Text(movies[index].title!),
                  //subtitle: Text(movies[index].overview!),
                  // trailing: IconButton(
                  //   icon: const Icon(Icons.delete),
                  //   onPressed: () async {
                  //     await dbHelper.deleteMovie(movies[index]);
                  //     setState(() {
                  //       movies.removeAt(index);
                  //     });
                  //   },
                  // ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MovieDetail(movies[index])));
                  },
                ),
              ));
        },
      ),
    );
  }

  Future showData() async {
    await dbHelper.openDb();
    movies = await dbHelper.getMovies();
    // setState(() {
    //   movies = movies;
    // });
  }
}
