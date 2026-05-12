import 'package:get/get.dart';
import '../models/film_model.dart';

class ApiService extends GetConnect {

  final String baseUrl =
      "https://68ff8dfbe02b16d1753e765d.mockapi.io/film";

  @override
  void onInit() {
    httpClient.baseUrl = baseUrl;

    httpClient.defaultContentType =
        "application/json";

    super.onInit();
  }

  // =========================
  // GET ALL FILM
  // =========================
  Future<List<Film>> getFilms() async {

    final response = await get("");

    if (response.statusCode == 200) {

      List data = response.body;

      return data.map((json) =>
          Film.fromJson(json)).toList();

    } else {
      throw Exception(
          "Gagal mengambil data film");
    }
  }

  // =========================
  // GET DETAIL FILM
  // =========================
  Future<Film> getFilmById(String id) async {

    final response = await get("/$id");

    if (response.statusCode == 200) {

      return Film.fromJson(response.body);

    } else {
      throw Exception(
          "Film tidak ditemukan");
    }
  }

  // =========================
  // CREATE FILM
  // =========================
  Future<bool> createFilm(Film film) async {

    final response = await post(
      "",
      film.toJson(),
    );

    if (response.statusCode == 201 ||
        response.statusCode == 200) {

      return true;

    } else {

      return false;
    }
  }

  // =========================
  // UPDATE FILM
  // =========================
  Future<bool> updateFilm(
      String id,
      Film film,
      ) async {

    final response = await put(
      "/$id",
      film.toJson(),
    );

    if (response.statusCode == 200) {

      return true;

    } else {

      return false;
    }
  }

  // =========================
  // DELETE FILM
  // =========================
  Future<bool> deleteFilm(String id) async {

    final response = await delete(
      "/$id",
    );

    if (response.statusCode == 200) {

      return true;

    } else {

      return false;
    }
  }
}