import 'package:get/get.dart';
import '../models/film_model.dart';

class FilmProvider extends GetConnect {
  // Base URL dari API publik Anda
  final String url = "https://68ff8dfbe02b16d1753e765d.mockapi.io/film";

  @override
  void onInit() {
    // Konfigurasi GetConnect (opsional)
    httpClient.timeout = const Duration(seconds: 20);
    super.onInit();
  }

  // 1. READ (Ambil semua data film)
  Future<List<FilmModel>> getAllFilms() async {
    final response = await get(url);
    if (response.status.hasError) {
      return Future.error(response.statusText ?? "Terjadi kesalahan");
    } else {
      // Mengubah List JSON menjadi List Object FilmModel
      List data = response.body;
      return data.map((e) => FilmModel.fromJson(e)).toList();
    }
  }

  // 2. CREATE (Tambah data - Khusus Admin)
  Future<Response> postFilm(FilmModel film) {
    return post(url, film.toJson());
  }

  // 3. UPDATE (Ubah data - Khusus Admin)
  Future<Response> updateFilm(String id, FilmModel film) {
    return put('$url/$id', film.toJson());
  }

  // 4. DELETE (Hapus data - Khusus Admin)
  Future<Response> deleteFilm(String id) {
    return delete('$url/$id');
  }
}