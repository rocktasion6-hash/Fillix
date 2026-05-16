import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/models/film_model.dart';
import '../../../data/models/tiket_model.dart';
import '../../../data/providers/tiket_provider.dart';

class PesanTiketController extends GetxController {
  final TiketProvider _provider = TiketProvider();

  final tanggalController = TextEditingController();
  final jumlahKursiController = TextEditingController();

  RxBool isLoading = false.obs;

  final FilmModel film;

  PesanTiketController({required this.film});

  Future<void> pesanTiket() async {
    if (tanggalController.text.isEmpty || jumlahKursiController.text.isEmpty) {
      Get.snackbar('Error', 'Semua field harus diisi');
      return;
    }

    final jumlah = int.tryParse(jumlahKursiController.text);
    if (jumlah == null || jumlah < 1) {
      Get.snackbar('Error', 'Jumlah kursi harus berupa angka positif');
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
        jumlahKursi: jumlah,
      ));
      Get.back();
      Get.snackbar('Sukses', 'Tiket berhasil dipesan!');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    tanggalController.dispose();
    jumlahKursiController.dispose();
    super.onClose();
  }
}
