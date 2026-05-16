import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/models/film_model.dart';
import '../../../data/models/komentar_model.dart';
import '../../../data/providers/komentar_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/app_routes.dart';
import '../../pesan_tiket/bindings/pesan_tiket_binding.dart';
import '../../pesan_tiket/views/pesan_tiket_view.dart';

class DetailFilmController extends GetxController {
  final KomentarProvider _komentarProvider = KomentarProvider();

  late FilmModel film;
  RxList<KomentarModel> komentarList = <KomentarModel>[].obs;
  RxBool isLoadingKomentar = false.obs;
  final komentarController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    film = Get.arguments;
    loadKomentar();
  }

  Future<void> loadKomentar() async {
    try {
      isLoadingKomentar.value = true;
      komentarList.value =
          await _komentarProvider.getKomentarByFilm(film.id ?? '');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoadingKomentar.value = false;
    }
  }

  Future<void> kirimKomentar() async {
    if (komentarController.text.trim().isEmpty) return;

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      Get.snackbar('Error', 'Anda harus login terlebih dahulu');
      return;
    }

    try {
      await _komentarProvider.tambahKomentar(KomentarModel(
        userId: user.id,
        filmId: film.id,
        isi: komentarController.text.trim(),
        namaUser: user.email,
      ));
      komentarController.clear();
      await loadKomentar();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void navigateToTrailer() {
    Get.toNamed(Routes.TRAILER, arguments: film.urlTrailer);
  }

  void navigateToPesanTiket() {
    Get.to(
      () => const PesanTiketView(),
      binding: PesanTiketBinding(),
      arguments: film,
    );
  }

  @override
  void onClose() {
    komentarController.dispose();
    super.onClose();
  }
}
