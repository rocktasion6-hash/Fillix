import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/models/film_model.dart';
import '../../../data/models/tiket_model.dart';
import '../../../data/providers/tiket_provider.dart';

class PesanTiketController extends GetxController {
  final TiketProvider _provider = TiketProvider();

  final tanggalController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isLoadingKursi = false.obs;

  // Kursi yang dipilih user
  RxList<String> kursiDipilih = <String>[].obs;
  // Kursi yang sudah terpesan orang lain
  RxList<String> kursiTerpesan = <String>[].obs;

  // Layout bioskop: 8 baris (A-H), 10 kolom
  final List<String> baris = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];
  final int jumlahKolom = 10;

  final FilmModel film;
  PesanTiketController({required this.film});

  void toggleKursi(String kursi) {
    if (kursiTerpesan.contains(kursi)) return;
    if (kursiDipilih.contains(kursi)) {
      kursiDipilih.remove(kursi);
    } else {
      kursiDipilih.add(kursi);
    }
  }

  Future<void> muatKursiTerpesan() async {
    if (tanggalController.text.isEmpty) return;
    try {
      isLoadingKursi.value = true;
      kursiDipilih.clear();
      final terpesan = await _provider.getKursiTerpesan(
        film.id ?? '',
        tanggalController.text,
      );
      kursiTerpesan.assignAll(terpesan);
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingKursi.value = false;
    }
  }

  Future<void> pesanTiket() async {
    if (tanggalController.text.isEmpty) {
      Get.snackbar('Error', 'Pilih tanggal tayang terlebih dahulu');
      return;
    }
    if (kursiDipilih.isEmpty) {
      Get.snackbar('Error', 'Pilih minimal 1 kursi');
      return;
    }

    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      Get.snackbar('Error', 'Anda harus login terlebih dahulu');
      return;
    }

    try {
      isLoading.value = true;
      await _provider.pesanTiket(TiketModel(
        userId: userId,
        filmId: film.id,
        judulFilm: film.judul,
        tanggalTayang: tanggalController.text,
        jumlahKursi: kursiDipilih.length,
        kursiDipilih: kursiDipilih.toList(),
      ));
      Get.back();
      Get.snackbar('Sukses',
          'Tiket berhasil dipesan! Kursi: ${kursiDipilih.join(', ')}');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    tanggalController.dispose();
    super.onClose();
  }
}
