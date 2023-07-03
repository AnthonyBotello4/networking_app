import 'package:flutter/material.dart';
import 'package:networking_app/util/db_helper.dart';
import 'package:networking_app/util/http_helper.dart';

import '../models/movie.dart';
import 'movie_detail.dart';


class MovieList extends StatefulWidget {
  const MovieList({Key? key}) : super(key: key);

  @override
  State<MovieList> createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  late List<Movie> movies;
  late int moviesCount;

  int page = 1;
  bool loading = true;
  late HttpHelper helper;
  ScrollController? _scrollController;

  Future initialize() async{
    movies = <Movie>[];
    loadMore();
    initScrollController();
    movies = (await helper.getUpcoming('1'))!;
    // setState(() {
    //   moviesCount = movies.length;
    //   movies = movies;
    // });
  }
  @override
  void initState() {
    helper = HttpHelper();
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Películas'),
        actions: <Widget>[
          Container(
            padding: const EdgeInsets.only(right: 10.0),
            child: Row(
              children: <Widget>[
                const Text('See Favorites'),
                IconButton(
                  icon: const Icon(Icons.favorite_rounded),
                  onPressed: () {
                  },
                ),
              ],
            ),
          )
        ],
      ),
      body: ListView.builder(
          controller: _scrollController,
          itemCount: movies.length,
          itemBuilder: (BuildContext context, int index){
            return MovieRow(movies[index]);
          }),
    );
  }

  void loadMore(){
    helper.getUpcoming(page.toString()).then((value) {
      movies += value!;
      setState(() {
        moviesCount = movies.length;
        movies = movies;
        page++;
      });

      if (movies.length % 20 > 0){
        setState(() {
          loading = false;
        });
      }
    });
  }

  void initScrollController(){
    _scrollController = ScrollController();
    _scrollController!.addListener(() {
      if ((_scrollController!.position.pixels ==
          _scrollController!.position.maxScrollExtent)
          && loading){
        loadMore();
      }
    });
  }
}

class MovieRow extends StatefulWidget {

  final Movie movie;
  MovieRow(this.movie);

  @override
  _MovieRowState createState() => _MovieRowState(movie);
}

class _MovieRowState extends State<MovieRow> {

  final Movie movie;
  _MovieRowState(this.movie);
  bool favorite = false;
  DbHelper dbHelper = DbHelper();
  String path = '';

  @override
  void initState() {
    favorite = false;
    dbHelper = DbHelper();
    isFavorite(movie);
    super.initState();
  }

  @override
  void setState(fn) {
    if (mounted){
      super.setState(fn);
    }
  }

  Future isFavorite(Movie movie) async {
    await dbHelper.openDb();
    favorite = await dbHelper.isFavorite(movie);
    setState(() {
      movie.isFavorite = favorite;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (movie.posterPath != null){
      path = 'https://image.tmdb.org/t/p/w500${movie.posterPath}';
    } else {
      path = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png';
    }

    return Card(
      color: Colors.white,
      elevation: 2.0,
      child: ListTile(
        leading: Hero(
          tag: "poster_${widget.movie.id}",
          child: CircleAvatar(
            backgroundImage: NetworkImage(path),
          ),
        ),
        title: Text(widget.movie.title!),
        subtitle: Text(
          '${widget.movie.releaseDate!} - ${widget.movie.voteAverage}/10'
        ),
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (BuildContext context) =>
              MovieDetail(widget.movie)),
          ).then((value) {
            isFavorite(movie);
          });
        },
        trailing: IconButton(
          icon: const Icon(Icons.favorite),
          color: favorite ? Colors.red : Colors.grey,
          onPressed: (){
            favorite
              ? dbHelper.deleteMovie(movie)
              : dbHelper.insertMovie(movie);
            setState(() {
              favorite = !favorite;
              movie.isFavorite = favorite;
            });
          },
        ),
      ),
    );
  }
}