import 'package:uno/uno.dart';
import '../models/film_model.dart';

class FilmProvider {
  // 1. Inisialisasi Uno
  final uno = Uno();
  
  // Base URL tetap sama
  final String url = "https://68ff8dfbe02b16d1753e765d.mockapi.io/film";

  // Pengganti onInit untuk timeout (Opsional di Uno)
  // Uno secara default sangat stabil, tapi kita bisa atur manual jika perlu.

  // 1. READ (Ambil semua data film)
  Future<List<FilmModel>> getAllFilms() async {
    try {
      final response = await uno.get(url);
      
      // Di Uno, data otomatis di-parse menjadi List/Map dan ada di properti .data
      List data = response.data;
      return data.map((e) => FilmModel.fromJson(e)).toList();
    } catch (e) {
      // Menangani error seperti response.statusText
      return Future.error("Terjadi kesalahan: $e");
    }
  }

  // 2. CREATE (Tambah data - Khusus Admin)
  Future<Response> postFilm(FilmModel film) async {
    // Uno mengembalikan objek Response yang strukturnya mirip GetConnect
    return await uno.post(url, data: film.toJson());
  }

  // 3. UPDATE (Ubah data - Khusus Admin)
  Future<Response> updateFilm(String id, FilmModel film) async {
    return await uno.put('$url/$id', data: film.toJson());
  }

  // 4. DELETE (Hapus data - Khusus Admin)
  Future<Response> deleteFilm(String id) async {
    return await uno.delete('$url/$id');
  }
}