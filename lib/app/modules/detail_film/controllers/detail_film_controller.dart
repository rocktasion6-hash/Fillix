import 'package:get/get.dart';
import '../../../data/models/film_model.dart';

class DetailFilmController extends GetxController {
  // Simpan data film di observable agar UI bisa bereaksi jika ada perubahan
  late FilmModel film;

  @override
  void onInit() {
    super.onInit();
    // Menangkap data yang dikirim dari HomeView
    film = Get.arguments;
  }
}