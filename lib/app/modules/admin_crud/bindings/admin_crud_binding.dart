import 'package:get/get.dart';
import '../controllers/admin_crud_controller.dart';
import '../../../data/providers/film_provider.dart';

class AdminCrudBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FilmProvider>(() => FilmProvider());
    Get.lazyPut<AdminCrudController>(() => AdminCrudController());
  }
}