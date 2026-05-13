import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/models/film_model.dart';
import '../../../data/providers/film_provider.dart';
import '../../home/controllers/home_controller.dart';

class AdminCrudController extends GetxController {
  final FilmProvider _filmProvider = Get.find<FilmProvider>();

  var isLoading = false.obs;
  var isEdit = false.obs;
  String? filmId;

  // Form Controllers Lengkap Sesuai Model
  final judulController = TextEditingController();
  final kategoriController = TextEditingController();
  final posterController = TextEditingController();
  final sampulController = TextEditingController();
  final ringkasanController = TextEditingController();
  final ratingController = TextEditingController();
  final rilisController = TextEditingController();
  final trailerController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Cek jika ada data film dikirim dari halaman Home (Mode Edit)
    if (Get.arguments != null && Get.arguments is FilmModel) {
      isEdit.value = true;
      FilmModel film = Get.arguments;
      filmId = film.id;

      // Autofill data ke controller
      judulController.text = film.judul ?? "";
      kategoriController.text = film.kategori ?? "";
      posterController.text = film.gambarPoster ?? "";
      sampulController.text = film.gambarSampul ?? "";
      ringkasanController.text = film.ringkasan ?? "";
      ratingController.text = (film.skorRating ?? 0).toString();
      rilisController.text = (film.tanggalRilis ?? 1778301187).toString();
      trailerController.text = film.urlTrailer ?? "";
    }
  }

  void saveFilm() async {
    if (judulController.text.isEmpty) {
      Get.snackbar("Error", "Judul tidak boleh kosong");
      return;
    }

    isLoading.value = true;

    // Siapkan objek film dengan konversi tipe data yang tepat (String ke int)
    FilmModel filmData = FilmModel(
      judul: judulController.text,
      kategori: kategoriController.text,
      gambarPoster: posterController.text,
      gambarSampul: sampulController.text,
      ringkasan: ringkasanController.text,
      urlTrailer: trailerController.text,
      // Pastikan konversi ke int agar tidak error di API
      skorRating: int.tryParse(ratingController.text) ?? 0,
      tanggalRilis: int.tryParse(rilisController.text) ?? 1778301187,
    );

    try {
      if (isEdit.value) {
        await _filmProvider.updateFilm(filmId!, filmData);
        Get.snackbar(
          "Sukses",
          "Film berhasil diperbarui",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        await _filmProvider.postFilm(filmData);
        Get.snackbar(
          "Sukses",
          "Film berhasil ditambahkan",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }

      // Refresh list di halaman Home
      Get.find<HomeController>().fetchFilms();
      Future.delayed(Duration(seconds: 1), () {
        Get.back(); // Kembali ke halaman sebelumnya setelah operasi selesai
      });
    } catch (e) {
      Get.snackbar(
        "Gagal",
        "Terjadi kesalahan: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // Dispose semua controller untuk menghindari memory leak
    judulController.dispose();
    kategoriController.dispose();
    posterController.dispose();
    sampulController.dispose();
    ringkasanController.dispose();
    ratingController.dispose();
    rilisController.dispose();
    trailerController.dispose();
    super.onClose();
  }
}
