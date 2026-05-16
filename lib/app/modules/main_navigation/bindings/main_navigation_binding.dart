import 'package:get/get.dart';
import '../controllers/main_navigation_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../../data/providers/film_provider.dart';
import '../../dashboard/controllers/dashboard_controller.dart';

class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainNavigationController>(() => MainNavigationController());
    
    // Karena HomeView (List Film) ada di dalam Navbar, 
    // kita perlu load controllernya di sini juga.
    Get.lazyPut<FilmProvider>(() => FilmProvider());
    Get.lazyPut<HomeController>(() => HomeController());
    // Dashboard menggunakan film provider juga
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}
