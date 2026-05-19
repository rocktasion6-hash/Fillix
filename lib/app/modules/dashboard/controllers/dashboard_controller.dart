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

      // ===============================
      // 1. TERBARU: Pilih sendiri dari ID API
      // ===============================
      final selectedLatestIds = [
        "94",
        "107",
        "110",
        "111",
      ];

      final selectedLatestFilms = films.where((film) {
        return selectedLatestIds.contains(
          film.id.toString(),
        );
      }).toList();

      latest.assignAll(selectedLatestFilms);

      // ===============================
      // 2. REKOMENDASI: Pilih sendiri dari ID API
      // ===============================
      final selectedRecommendationIds = [
        "98",
        "99",
        "100",
        "101",
        "102",
        "103",
        "104",
      ];

      final selectedRecommendedFilms = films.where((film) {
        return selectedRecommendationIds.contains(
          film.id.toString(),
        );
      }).toList();

      recommended.assignAll(selectedRecommendedFilms);

      // ===============================
      // 3. FEATURED / BANNER ATAS
      // Ambil dari rekomendasi pilihan
      // ===============================
      FilmModel? featured;

      for (final f in recommended) {
        if (_hasImage(f)) {
          featured = f;
          break;
        }
      }

      // Jika rekomendasi kosong, ambil dari latest
      if (featured == null) {
        for (final f in latest) {
          if (_hasImage(f)) {
            featured = f;
            break;
          }
        }
      }

      // Jika latest juga kosong, ambil dari semua film
      if (featured == null) {
        for (final f in films) {
          if (_hasImage(f)) {
            featured = f;
            break;
          }
        }
      }

      featuredFilm.value = featured;
    } catch (e) {
      Get.snackbar(
        'Gagal Memuat Data',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool _hasImage(FilmModel film) {
    return (film.gambarPoster?.trim().isNotEmpty == true) ||
        (film.gambarSampul?.trim().isNotEmpty == true);
  }
}