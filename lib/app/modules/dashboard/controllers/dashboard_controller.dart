import 'package:get/get.dart';
import '../../../data/providers/film_provider.dart';
import '../../../data/models/film_model.dart';

class DashboardController extends GetxController {
  final FilmProvider _filmProvider = Get.find<FilmProvider>();

  var featuredFilm = Rxn<FilmModel>();
  var recommended = <FilmModel>[].obs;
  var latest = <FilmModel>[].obs;
  var isLoading = true.obs;

  List<FilmModel> get featuredFilms => recommended.where(_hasImage).toList();

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() async {
    try {
      isLoading.value = true;
      final films = await _filmProvider.getAllFilms();

      if (films.isEmpty) {
        isLoading.value = false;
        return;
      }

      // 1. LATEST: Urutkan berdasarkan tanggalRilis (Terbaru ke Terlama)
      // Dikonversi ke String agar aman dari error tipe data
      final byDate = List<FilmModel>.from(films);
      byDate.sort((a, b) {
        String dateA = a.tanggalRilis?.toString() ?? "";
        String dateB = b.tanggalRilis?.toString() ?? "";
        return dateB.compareTo(dateA);
      });
      latest.assignAll(byDate.take(6).toList());

      // 2. RECOMMENDED: Urutkan berdasarkan skorRating (Tertinggi ke Terendah)
      // Dikonversi ke double agar aman (mencegah error jika tipe aslinya int/String)
      final byRating = List<FilmModel>.from(films);
      byRating.sort((a, b) {
        double ratingA =
            double.tryParse(a.skorRating?.toString() ?? "0") ?? 0.0;
        double ratingB =
            double.tryParse(b.skorRating?.toString() ?? "0") ?? 0.0;
        return ratingB.compareTo(ratingA);
      });
      recommended.assignAll(byRating.take(6).toList());

      // 3. FEATURED: Ambil dari list rating tertinggi yang memiliki gambar
      FilmModel? featured;
      for (final f in byRating) {
        if (_hasImage(f)) {
          featured = f;
          break; // Berhenti begitu menemukan 1 film terbaik yang punya gambar
        }
      }
      featuredFilm.value =
          featured ?? (byRating.isNotEmpty ? byRating.first : null);
    } catch (e) {
      Get.snackbar('Gagal Memuat Data', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Cukup cek apakah field database tidak kosong, urusan gambar rusak ditangani UI
  bool _hasImage(FilmModel film) {
    return (film.gambarPoster?.trim().isNotEmpty == true) ||
        (film.gambarSampul?.trim().isNotEmpty == true);
  }
}
