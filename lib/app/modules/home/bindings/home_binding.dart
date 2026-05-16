import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../data/providers/film_provider.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FilmProvider>(() => FilmProvider());
    Get.lazyPut<HomeController>(() => HomeController());
  }
}