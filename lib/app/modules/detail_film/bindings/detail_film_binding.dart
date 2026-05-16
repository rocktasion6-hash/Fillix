import 'package:get/get.dart';
import '../controllers/detail_film_controller.dart';

class DetailFilmBinding extends Bindings {
  @override
  void dependencies() {
    // Memasukkan controller ke dalam memori saat rute dipanggil
    Get.lazyPut<DetailFilmController>(
      () => DetailFilmController(),
    );
  }
}