import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MovieProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Movie Discovery App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const MovieListScreen(),
      ),
    );
  }
}

class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterUrl;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterUrl,
  });
}

class MovieProvider with ChangeNotifier {
  List<Movie> _movies = [];
  final List<int> _favoriteMovieIds = [];
  bool _hasFetchedMovies = false; // To track if movies have been fetched

  List<Movie> get movies => _movies;
  List<int> get favoriteMovieIds => _favoriteMovieIds;

  bool get hasFetchedMovies => _hasFetchedMovies;

  Future<void> fetchMovies() async {
    if (!_hasFetchedMovies) {
      try {
        final response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/popular?api_key=86518f62c986249f28cf9f132d5b4ab2',
        ));

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          final List<Movie> parsedMovies =
              List<Movie>.from(data['results'].map((movieData) {
            return Movie(
              id: movieData['id'],
              title: movieData['title'],
              overview: movieData['overview'],
              posterUrl:
                  'https://image.tmdb.org/t/p/w500/${movieData['poster_path']}',
            );
          }));

          _movies = parsedMovies;
          _hasFetchedMovies = true;
          notifyListeners();
          print('Data fetched and parsed! $_movies');
        } else {
          throw Exception('Failed to load movies');
        }
      } catch (error) {
        // Handle errors
        print('Error fetching movies: $error');
      }
    }
  }

  void toggleFavorite(int movieId) {
    if (_favoriteMovieIds.contains(movieId)) {
      _favoriteMovieIds.remove(movieId);
    } else {
      _favoriteMovieIds.add(movieId);
    }
    notifyListeners();
  }
}

class MovieListScreen extends StatelessWidget {
  const MovieListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Discovery App'),
      ),
      body: FutureBuilder<void>(
        future: movieProvider.fetchMovies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading movies'));
          } else {
            final movies = movieProvider.movies;
            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: movie.posterUrl,
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                  title: Text(movie.title),
                  subtitle: Text(movie.overview),
                  trailing: IconButton(
                    icon: Icon(
                      movieProvider.favoriteMovieIds.contains(movie.id)
                          ? Icons.favorite
                          : Icons.favorite_border,
                    ),
                    onPressed: () {
                      movieProvider.toggleFavorite(movie.id);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailScreen(movie: movie),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: movie.posterUrl,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            const SizedBox(height: 16),
            Text(
              movie.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(movie.overview),
          ],
        ),
      ),
    );
  }
}
