import 'dart:convert';
import 'dart:io';
import 'package:networking_app/models/movie.dart';
import 'package:http/http.dart' as http;

class HttpHelper{
  final String urlBase = 'https://api.themoviedb.org/3/movie';
  final String urlUpcoming = '/upcoming?';
  final String urlKey = 'api_key=3cae426b920b29ed2fb1c0749f258325';
  final String urlPage = '&page=';


  Future<List<Movie>?> getUpcoming(String page) async {
    final String upcoming = urlBase + urlUpcoming + urlKey + urlPage + page;
    http.Response result = await http.get(Uri.parse(upcoming));
    if (result.statusCode == HttpStatus.ok){
      final jsonResponse = json.decode(result.body);
      final moviesMap = jsonResponse['results'];
      List<Movie> movies = moviesMap.map<Movie>((i) => Movie.fromJson(i)).toList();
      return movies;
    } else {
      print(result.body);
      return null;
    }
  }

}