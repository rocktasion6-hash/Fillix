import 'package:get/get.dart';
import '../models/film_model.dart';
import '../services/api_service.dart';

class FilmController extends GetxController {

  final ApiService apiService =
      Get.put(ApiService());

  // LIST FILM
  RxList<Film> filmList =
      <Film>[].obs;

  // LOADING
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    getFilms();
    super.onInit();
  }

  // =========================
  // GET ALL FILM
  // =========================
  Future<void> getFilms() async {

    try {

      isLoading.value = true;

      final data =
          await apiService.getFilms();

      filmList.value = data;

    } catch (e) {

      Get.snackbar(
        "Error",
        e.toString(),
      );

    } finally {

      isLoading.value = false;
    }
  }

  // =========================
  // CREATE FILM
  // =========================
  Future<void> createFilm(
      Film film,
      ) async {

    try {

      isLoading.value = true;

      bool success =
          await apiService.createFilm(
              film);

      if (success) {

        Get.snackbar(
          "Sukses",
          "Film berhasil ditambahkan",
        );

        getFilms();

      } else {

        Get.snackbar(
          "Error",
          "Gagal menambahkan film",
        );
      }

    } catch (e) {

      Get.snackbar(
        "Error",
        e.toString(),
      );

    } finally {

      isLoading.value = false;
    }
  }

  // =========================
  // UPDATE FILM
  // =========================
  Future<void> updateFilm(
      String id,
      Film film,
      ) async {

    try {

      isLoading.value = true;

      bool success =
          await apiService.updateFilm(
              id,
              film);

      if (success) {

        Get.snackbar(
          "Sukses",
          "Film berhasil diupdate",
        );

        getFilms();

      } else {

        Get.snackbar(
          "Error",
          "Gagal update film",
        );
      }

    } catch (e) {

      Get.snackbar(
        "Error",
        e.toString(),
      );

    } finally {

      isLoading.value = false;
    }
  }

  // =========================
  // DELETE FILM
  // =========================
  Future<void> deleteFilm(
      String id,
      ) async {

    try {

      isLoading.value = true;

      bool success =
          await apiService.deleteFilm(id);

      if (success) {

        Get.snackbar(
          "Sukses",
          "Film berhasil dihapus",
        );

        getFilms();

      } else {

        Get.snackbar(
          "Error",
          "Gagal menghapus film",
        );
      }

    } catch (e) {

      Get.snackbar(
        "Error",
        e.toString(),
      );

    } finally {

      isLoading.value = false;
    }
  }
}