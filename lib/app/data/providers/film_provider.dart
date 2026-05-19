import 'package:uno/uno.dart';
import '../models/film_model.dart';

class FilmProvider {
  final uno = Uno();

  final String url =
      "https://68ff8dfbe02b16d1753e765d.mockapi.io/film";

  // 1. READ SEMUA DATA FILM
  Future<List<FilmModel>> getAllFilms() async {
    try {
      final response = await uno.get(url);

      List data = response.data;

      return data.map((e) => FilmModel.fromJson(e)).toList();
    } catch (e) {
      return Future.error("Terjadi kesalahan: $e");
    }
  }

  // 2. READ REKOMENDASI FILM
  Future<List<FilmModel>> getRecommendedFilms() async {
    try {
      final response = await uno.get(url);

      List data = response.data;

      List<FilmModel> films =
          data.map((e) => FilmModel.fromJson(e)).toList();

      // Ubah ID di sini sesuai film yang mau kamu tampilkan di rekomendasi
      final selectedRecommendationIds = [
        "1",
        "3",
        "5",
      ];

      return films.where((film) {
        return selectedRecommendationIds.contains(film.id.toString());
      }).toList();
    } catch (e) {
      return Future.error("Terjadi kesalahan: $e");
    }
  }

  // 3. CREATE DATA FILM
  Future<Response> postFilm(FilmModel film) async {
    return await uno.post(
      url,
      data: film.toJson(),
    );
  }

  // 4. UPDATE DATA FILM
  Future<Response> updateFilm(String id, FilmModel film) async {
    return await uno.put(
      '$url/$id',
      data: film.toJson(),
    );
  }

  // 5. DELETE DATA FILM
  Future<Response> deleteFilm(String id) async {
    return await uno.delete('$url/$id');
  }
}