import 'package:get/get.dart';
import '../../../data/models/film_model.dart';
import '../controllers/pesan_tiket_controller.dart';

class PesanTiketBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PesanTiketController(film: Get.arguments as FilmModel));
  }
}
